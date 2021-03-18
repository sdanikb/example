//
//  MnpEnterStore.swift
//  Activ
//
//  Created by admin on 11/19/20.
//  Copyright © 2020 company. All rights reserved.
//

import Foundation
import Promises

fileprivate enum MnpEnterError: Error {
    case emailsNotMatch
}

extension MnpEnterError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emailsNotMatch:
            return "Email не совпадают"
        }
    }
}

final class MnpEnterStore {

    enum Action {
        case didTapNextButton(primaryPhone: String, contactPhone: String, email: String, confirmEmail: String)
    }

    enum State {
        case error(message: String)
        case emailError(message: String)
        case loading
        case finished(response: MnpStepResponse)
    }
    
    @Observable private(set) var state: State?
    
    private let task: String
    private let provider: MnpProvider
    private let phoneNumberFormatter: PhoneNumberFormatter
    private weak var repository: MnpRepository?

    init(task: String, repository: MnpRepository, provider: MnpProvider, formatter: PhoneNumberFormatter) {
        self.task = task
        self.provider = provider
        self.phoneNumberFormatter = formatter
        self.repository = repository
    }
    
    func dispatch(action: Action) {
        switch action {
        case let .didTapNextButton(primaryPhone, contactPhone, email, confirmEmail):
            let task = self.task
            state = .loading
            verifyFields(
                primaryPhone: primaryPhone,
                contactPhone: contactPhone,
                email: email,
                confirmEmail: confirmEmail
            ).then { [weak repository] in
                repository?.transferPhoneNumber = primaryPhone
            }.then { [weak self] in
                MnpEnteringNumberStep(
                    task: task,
                    phoneNumber: self?.phoneNumberFormatter.rawPhoneNumber(from: primaryPhone) ?? "",
                    contactPhoneNumber: self?.phoneNumberFormatter.rawPhoneNumber(from: contactPhone) ?? "",
                    email: email
                )
            }.then(performStep)
            .then(finish)
            .catch(processError)
        }
    }
    
    private func performStep(_ step: MnpStep) -> Promise<MnpStepResponse> {
        provider.step(step)
    }
    
    private func finish(response: MnpStepResponse) {
        state = .finished(response: response)
    }
    
    private func verifyFields(primaryPhone: String, contactPhone: String, email: String, confirmEmail: String) -> Promise<Void> {
        let validationErrors: [Error] = [
            validate(phoneNumber: primaryPhone),
            validate(phoneNumber: contactPhone),
            validate(email: email),
            validate(email: confirmEmail)
        ].compactMap { $0 }
        
        return Promise { fulfill, reject  in
            guard validationErrors.isEmpty else {
                return reject(validationErrors[0])
            }
            
            if email != confirmEmail {
                return reject(MnpEnterError.emailsNotMatch)
            }
            return fulfill(Void())
        }
    }

    private func processError(error: Error)  {
        state = .error(message: error.localizedDescription)
    }
    
}

//MARK: - Validation helpers
private extension MnpEnterStore {
    
    func validate(phoneNumber: String) -> Error? {
        let rawNumber = phoneNumberFormatter.rawPhoneNumber(from: phoneNumber) ?? ""
        switch rawNumber.validate(rule: ValidationRulePhoneNumber()) {
        case let .invalid(errors):
            return errors.first
        case .valid:
            return nil
        }
    }
    
    func validate(email: String) -> Error? {
        switch email.validate(rule: ValidationRuleEmailAddress()) {
        case let .invalid(errors):
            return errors.first
        case .valid:
            return nil
        }
    }
    
}
