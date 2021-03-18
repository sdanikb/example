//
//  MnpConsentViewController.swift
//  Kcell-Activ
//
//  Created by admin on 12/1/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit
import Promises
// TODO - !!!: add options
final class MnpConsentViewController: BaseViewController {
    
    @IBOutlet private weak var consentButton: UIButton!
    
    private let store: MnpConsentStore
    private weak var delegate: MnpNavigationDelegate?
    
    init(store: MnpConsentStore, navigationDelegate: MnpNavigationDelegate?) {
        self.store = store
        self.delegate = navigationDelegate
        super.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
    }

    private func setupObservers() {
        store.$state.observe(self) { vc, state in
            guard let state = state else { return }
            switch state {
            case .changeConsentState(let isConsent):
                vc.changeConsentButton(isConsent)
            case let .error(message):
                vc.showToast(category: .error, message: message)
            case .loading:
                ProgressHud.startAnimating()
            case .loadingFinished:
                ProgressHud.stopAnimating()
            case .finished(let response):
                vc.delegate?.process(response: response)
            }
        }
    }
    
    @IBAction private func consentButtonDidPress(_ sender: Any) {
        store.dispatch(action: .didTapConsentButton)
    }
    
    private func changeConsentButton(_ isConsent: Bool) {
        consentButton.isEnabled = isConsent
    }
    
    @IBAction func continueButtonDidPress(_ sender: Any) {
        store.dispatch(action: .didTapNextButton)
    }
    
}
