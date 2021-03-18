//
//  TransferCategoryCell.swift
//  Kcell-Activ
//
//  Created by admin on 8/12/20.
//  Copyright © 2020 company. All rights reserved.
//

import Kingfisher
import UIKit

protocol MnpScanCategoryCellDelegate: class {
    func categoryButtonDidTap(_ cell: MnpScanCategoryCell)
}

final class MnpScanCategoryCell: UITableViewCell {
    weak var delegate: MnpScanCategoryCellDelegate?

    @IBOutlet private var categoryButton: OneLineButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }

    func configure(with cellModel: MnpScanCategoryCellModel) {
        categoryButton.setTitle(cellModel.title)
    }

    @objc
    private func categoryButtonDidTap() {
        delegate?.categoryButtonDidTap(self)
    }

    private func setup() {
        categoryButton.addTarget(self, action: #selector(categoryButtonDidTap), for: .touchUpInside)
    }
}
