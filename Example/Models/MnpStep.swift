//
//  MnpStep.swift
//  Kcell-Activ
//
//  Created by admin on 11/21/20.
//  Copyright © 2020 company. All rights reserved.
//

import Alamofire

protocol MnpStep {
    var task: String { get }
    var input: [String: Any] { get }
}

extension MnpStep {
    var parameters: Parameters? {
        ["task": task,
         "input": input]
    }
}

struct MnpEnteringNumberStep: MnpStep {
    let task: String
    let phoneNumber: String
    let contactPhoneNumber: String
    let email: String

    var input: [String: Any] {
        ["msisdn": phoneNumber,
         "contact_number": contactPhoneNumber,
         "email": email]
    }
}


struct MnpSmsStep: MnpStep {
    let task: String
    let input: [String : Any]
    
    init(task: String, code: String) {
        self.task = task
        self.input = [
            "otp_code": code
        ]
    }
}

struct MnpConsentStep: MnpStep {
    let task: String
    let isConsent: Bool
    
    var input: [String : Any] {
        ["is_consent": isConsent ? 1 : 0]
    }
}

struct MnpTariffStep: MnpStep {
    let task: String
    let tariff: String

    var input: [String : Any] {
        ["tariff": tariff]
    }
}

struct MnpSelfieStep: MnpStep {
    
    let task: String
    let selfie: String
    
    var input: [String : Any] {
        ["selfie": selfie]
    }
    
}

struct MnpConfirmationStep: MnpStep {
    let task: String
    let city: String
    let postal: String
    let street: String
    let build: String
    
    var input: [String: Any] {
        ["city": city,
         "street": street,
         "postal": postal,
         "build": build]
    }
}

struct MnpScanStep: MnpStep {
    let task: String
    let meta: [String: Any]

    var input: [String: Any] {
        ["metadata": meta]
    }

}

struct MnpSignStep: MnpStep {
    let task: String
    let sign: String

    var input: [String : Any] {
        ["sign": sign]
    }
}
