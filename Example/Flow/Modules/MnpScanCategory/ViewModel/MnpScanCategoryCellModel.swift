//
//  MnpScanCategoryCellModel.swift
//  Kcell-Activ
//
//  Created by admin on 12/7/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

struct MnpScanCategoryCellModel {
// TODO - !!!: is it from server or localize
    var title: String {
        switch category {
        case .idCard: return "Удостоверение личности"
        case .passport: return "Паспорт"
        case .residencePermit: return "Вид на жительство"
        }
    }

    private let category: MnpScanCategoryType

    init(category: MnpScanCategoryType) {
        self.category = category
    }
}
