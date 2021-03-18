//
//  MnpRepository.swift
//  Kcell-Activ
//
//  Created by admin on 11/22/20.
//  Copyright © 2020 company. All rights reserved.
//

import Promises

struct MnpSmsVerifyInputParameters: SmsVerifyInputParameters {
    let digitsCount = 4
    let phoneNumber: String
    let resendDelay = 30
}

final class MnpRepository {
    typealias InputParameters = MnpSmsVerifyInputParameters
    
    private(set) var response: MnpStepResponse?
    
    var transferPhoneNumber: String?
    var lastStep: MnpStep?
    var currentTask: String?
    
    private let provider: MnpProvider
    
    init(provider: MnpProvider) {
        self.provider = provider
    }
    
}

extension MnpRepository: SmsVerifyRepository {
    
    func resend(inputParameters: MnpSmsVerifyInputParameters) -> Promise<SmsResendResponse> {
        Promise(SmsResendResponse(resendDelay: inputParameters.resendDelay))
    }
    
    func verify(inputParameters: MnpSmsVerifyInputParameters, sms: String) -> Promise<Void> {
        let request = provider.smsVerify(MnpSmsStep(task: currentTask ?? "", code: sms))
        return request.then { [weak self] response in
            self?.response = response
        }
    }
  
}
