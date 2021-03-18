//
//  MnpOnboardingNextView.swift
//  Kcell-Activ
//
//  Created by admin on 7/23/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

protocol MnpOnboardingNextViewDelegate: class {
    func nextButtonDidTap(_ view: MnpOnboardingNextView)
}

final class MnpOnboardingNextView: UIView, NibOwnerLoadable {
    weak var delegate: MnpOnboardingNextViewDelegate?

    @IBOutlet private var nextButton: PrimaryButton! 

    @IBAction
    private func didTapNextButton() {
        delegate?.nextButtonDidTap(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
    
    func configure(with title: String) {
        nextButton.setTitle(title, for: .normal)
    }

    private func setup() {
        loadNibContent()
        updateColors()
    }

    private func updateColors() {
        backgroundColor = Colors.fill2
    }
}
