//
//  MnpConsentStore.swift
//  Kcell-Activ
//
//  Created by admin on 12/3/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

final class MnpConsentStore {
    
    enum Action {
        case didLoadView
        case didTapConsentButton
        case didTapNextButton
    }

    enum State {
        case changeConsentState(isConsent: Bool)
        case error(message: String)
        case loading
        case loadingFinished
        case finished(response: MnpStepResponse)
    }
    
    @Observable private(set) var state: State?
    
    private let task: String
    private let provider: MnpProvider
    private var isConsent = true

    init(task: String, provider: MnpProvider) {
        self.task = task
        self.provider = provider
    }
    
    func dispatch(action: Action) {
        switch action {
        case .didLoadView:
            state = .changeConsentState(isConsent: isConsent)
        case .didTapConsentButton:
            isConsent.toggle()
            state = .changeConsentState(isConsent: isConsent)
        case .didTapNextButton:
            let step = MnpConsentStep(task: task, isConsent: isConsent)
            provider.step(step).always { [weak self] in
                self?.state = .loadingFinished
            }.then { [weak self] response in
                self?.state = .finished(response: response)
            }.catch { [weak self] error in
                self?.state = .error(message: error.localizedDescription)
            }
        }
    }
    
}
