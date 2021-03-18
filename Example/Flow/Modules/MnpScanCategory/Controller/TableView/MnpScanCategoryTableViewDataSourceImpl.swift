//
//  MnpScanCategoryTableViewDataSourceImpl.swift
//  Kcell-Activ
//
//  Created by admin on 12/7/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

final class MnpScanCategoryTableViewDataSourceImpl: NSObject {
    var sections: [MnpScanCategorySection] = []
}

extension MnpScanCategoryTableViewDataSourceImpl: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .info:
            let cell: MnpScanCategoryInfoCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure()
            return cell
        case let .category(category: category):
            let cell: MnpScanCategoryCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: .init(category: category))
            return cell
        }
    }    
}
