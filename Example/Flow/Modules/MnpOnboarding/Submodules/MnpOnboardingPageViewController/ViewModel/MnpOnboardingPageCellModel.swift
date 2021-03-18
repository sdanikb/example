//
//  MnpOnboardingPageCellModel.swift
//  Kcell-Activ
//
//  Created by admin on 11/24/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

struct MnpOnboardingPageCellModel {
    var title: String {
        return onboarding.title
    }

    var description: String? {
        return onboarding.description.html2AttributedString?.string
    }

    var image: URL? {
        return URL(string: onboarding.icon)
    }

    private let onboarding: MnpOnboarding
    
    init(onboarding: MnpOnboarding) {
        self.onboarding = onboarding
    }
}

