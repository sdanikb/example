//
//  MnpOnboardingPageTableViewCell.swift
//  Kcell-Activ
//
//  Created by admin on 11/24/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit
import Kingfisher

final class MnpOnboardingPageTableViewCell: UITableViewCell {

    @IBOutlet private var categoryImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateColors()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }

    func configure(with cellModel: MnpOnboardingPageCellModel) {
        titleLabel.text = cellModel.title
        descriptionLabel.text = cellModel.description
        categoryImageView.kf.setImage(with: cellModel.image)
    }

    private func updateColors() {
        titleLabel.textColor = Colors.label1
        descriptionLabel.textColor = Colors.text2
    }
}
