//
//  MnpSelfieIntroductionViewController.swift
//  Kcell-Activ
//
//  Created by admin on 12/3/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit
import AVFoundation

protocol MnpSelfieNavigationDelegate: class {
    func onIntroductionComplete(task: String)
}

final class MnpSelfieIntroductionViewController: BaseViewController {
    
    private weak var delegate: MnpSelfieNavigationDelegate?
    
    private let store: MnpSelfieIntroductionStore
    
    init(store: MnpSelfieIntroductionStore, delegate: MnpSelfieNavigationDelegate) {
        self.store = store
        self.delegate = delegate
        super.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }
     
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    @IBOutlet private weak var introductionTitle: UILabel!
    @IBOutlet private weak var introductionDescription: UILabel!
    @IBOutlet private weak var continueButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        setupUI()
        updateColors()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
    
    @IBAction private func continueButtonDidPress(_ sender: Any) {
        store.dispatch(action: .introductionCompleted)
    }
    
    private func setupObservers() {
        store.$state.observe(self) { vc, state in
            guard let state = state else { return }
            switch state {
            case .permissionGranted:
                vc.delegate?.onIntroductionComplete(task: vc.store.task)
            case .permissionDenied:
                break
            }
        }
    }
    
    private func setupUI() {
        continueButton.setTitle("", for: .normal)
    }
    
    private func updateColors() {
        view.backgroundColor = Colors.background
        introductionTitle.textColor = Colors.text1
        introductionDescription.textColor = Colors.gray1
    }
    
}
