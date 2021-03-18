//
//  MnpScanCategoryInfoCell.swift
//  Kcell-Activ
//
//  Created by admin on 11/24/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit
import Kingfisher

final class MnpScanCategoryInfoCell: UITableViewCell {

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

    func configure() {
        // TODO - !!!: from server or localize
        titleLabel.text = "Отсканируйте документы"
        descriptionLabel.text = "Данные с документов, удостоверяющего личность, используются для прохождения верификации. Следуйте инструкциям на экране."
        categoryImageView.image = Assets.menuEsim.image
    }

    private func updateColors() {
        titleLabel.textColor = Colors.label1
        descriptionLabel.textColor = Colors.text2
    }
}
