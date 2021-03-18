//
//  MnpScanChooseStore.swift
//  Kcell-Activ
//
//  Created by admin on 12/7/20.
//  Copyright © 2020 company. All rights reserved.
//

import Foundation
import Promises

enum MnpScanCategoryType {
    case idCard, passport, residencePermit
}

struct MnpScanCategorySection {
    enum SectionType {
        case info, categories
    }

    enum RowType {
        case info
        case category(category: MnpScanCategoryType)
    }

    let type: SectionType
    let rows: [RowType]
}

final class MnpScanCategoryStore {

    enum Action {
        case didLoadView
        case didSelectItem(index: Int)
    }

    enum State {
        case initial(sections: [MnpScanCategorySection])
        case optionSelected(category: MnpScanCategoryType)
    }
    
    @Observable private(set) var state: State?
    private let provider: MnpProvider
    var categories: [MnpScanCategoryType] = []
    
    init(provider: MnpProvider) {
        self.provider = provider
    }
    
    func dispatch(action: Action) {
        switch action {
        case .didLoadView:
            configureSections()
        case let .didSelectItem(index):
            guard let category = categories[safe: index] else { return }
            state = .optionSelected(category: category)
        }
    }
    
    private func configureSections() {
        var sections: [MnpScanCategorySection] = []
        
        sections.append(.init(type: .info, rows: [.info]))
        
        categories = [.idCard, .passport, .residencePermit]
        sections.append(.init(type: .categories, rows: categories.compactMap { .category(category: $0) }))
        
        state = .initial(sections: sections)
    }
}
