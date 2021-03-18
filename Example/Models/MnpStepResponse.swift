//
//  MnpStepResponse.swift
//  Kcell-Activ
//
//  Created by admin on 11/22/20.
//  Copyright © 2020 company. All rights reserved.
//

import Foundation

struct MnpStepResponse: Decodable {
    let task: String
    let type: MnpStepType
    
    enum CodingKeys: String, CodingKey {
        case task, type = "step_code", vars
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let task = try? container.decode(String.self, forKey: .task)
        let typeString = try container.decode(String.self, forKey: .type)
        switch typeString {
        case "ENTERING_NUMBER":
            self.type = .enteringNumber
        case "OTP":
            self.type = .otp
        case "CONSENT":
            self.type = .consent
        case "TARIFF":
            self.type = .tariff
        case "SCAN_DOCUMENTS":
            self.type = .scan
        case "SELFIE":
            self.type = .selfie
        case "CONFIRMATION":
            let confirmationContainer = try container.nestedContainer(keyedBy: MnpUserInformation.ContainerKeys.self, forKey: .vars)
            let info = try confirmationContainer.decode(MnpUserInformation.self, forKey: .info)
            self.type = .confirmation(info: info)
        case "SIGN":
            self.type = .sign
        case "DONE":
            self.type = .done
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Received wrong mnp type")
        }
        
        switch (task, type) {
        case (nil, .done):
            self.task = ""
        case (.some(let task), _):
            self.task = task
        default:
            throw DecodingError.dataCorruptedError(forKey: .task, in: container, debugDescription: "Task is not provided")
        }
        
    }
}

enum MnpStepType {
    case enteringNumber
    case otp
    case consent
    case tariff
    case scan
    case selfie
    case confirmation(info: MnpUserInformation)
    case sign
    case done
}
