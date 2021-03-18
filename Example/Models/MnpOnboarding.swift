//
//  MnpOnboarding.swift
//  Kcell-Activ
//
//  Created by admin on 12/1/20.
//  Copyright © 2020 company. All rights reserved.
//

import Foundation

struct MnpOnboarding: Codable {
    let id: String
    let title: String
    let icon: String
    let description: String
    let action: String
    
    init?(data: MnpOnboardingQuery.Data.OnboardingMnp?, baseUrl: String) {
        guard let id = data?.id,
            let title = data?.title,
            let icon = data?.icon,
            let description = data?.description,
            let action = data?.action else { return nil }
        self.id = id
        self.title = title
        self.icon = baseUrl + icon
        self.description = description
        self.action = action
    }
}
