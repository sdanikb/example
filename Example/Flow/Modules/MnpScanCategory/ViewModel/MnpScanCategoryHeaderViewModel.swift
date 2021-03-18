//
//  MnpScanCategoryHeaderViewModel.swift
//  Kcell-Activ
//
//  Created by admin on 12/7/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

struct MnpScanCategoryHeaderViewModel {
    var title: String? {
        switch section.type {
        case .categories:
            // TODO - !!!: localize
            return "Сканировать:"
        default:
            return nil
        }
    }

    private let section: MnpScanCategorySection

    init(section: MnpScanCategorySection) {
        self.section = section
    }
}
