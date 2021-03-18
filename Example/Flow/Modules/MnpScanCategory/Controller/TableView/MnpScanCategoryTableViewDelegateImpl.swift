//
//  MnpScanCategoryTableViewDelegateImpl.swift
//  Kcell-Activ
//
//  Created by admin on 12/7/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

final class MnpScanCategoryTableViewDelegateImpl: NSObject {
    var tableView: UITableView?
    var sections: [MnpScanCategorySection] = []
    private let store: MnpScanCategoryStore

    init(store: MnpScanCategoryStore) {
        self.store = store
    }
}

extension MnpScanCategoryTableViewDelegateImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .info:
            guard let cell = cell as? MnpScanCategoryInfoCell else { return }
            cell.configure()
        case let .category(category: category):
            guard let cell = cell as? MnpScanCategoryCell else { return }
            cell.delegate = self
            cell.configure(with: .init(category: category))        
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .info:
            return UITableView.automaticDimension
        case .category:
            return 52 + 8
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .info:
            return UITableView.automaticDimension
        case .category:
            return 52 + 8
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        heightForHeader(in: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        heightForHeader(in: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section].type {
        case .categories:
            let view: MnpScanCategoryHeaderView = tableView.dequeueReusableHeaderFooterView()
            view.configure(with: .init(section: sections[section]))
            return view
        default:
            return nil
        }
    }

    private func heightForHeader(in section: Int) -> CGFloat {
        switch sections[section].type {
        case .info:
            return .leastNonzeroMagnitude
        case .categories:
            return 24
        }
    }    
}

extension MnpScanCategoryTableViewDelegateImpl: MnpScanCategoryCellDelegate {
    func categoryButtonDidTap(_ cell: MnpScanCategoryCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        store.dispatch(action: .didSelectItem(index: indexPath.row))
    }
}
