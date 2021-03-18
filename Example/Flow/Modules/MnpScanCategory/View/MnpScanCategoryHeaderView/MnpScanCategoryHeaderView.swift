//
//  FAQSectionHeaderView.swift
//  Kcell-Activ
//
//  Created by admin on 9/24/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

final class MnpScanCategoryHeaderView: UITableViewHeaderFooterView {
    @IBOutlet private var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        updateColors()
    }

    func configure(with viewModel: MnpScanCategoryHeaderViewModel) {
        titleLabel.text = viewModel.title
    }

    private func updateColors() {
        titleLabel.textColor = Colors.fill5
    }
}
