//
//  MnpSelfieProcessViewController.swift
//  Kcell-Activ
//
//  Created by admin on 12/3/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

protocol MnpSignViewControllerDelegate: MnpNavigationDelegate {
    func agreementsDidTap(_ viewController: MnpSignViewController)
}

final class MnpSignViewController: BaseViewController {

    private let store: MnpSignStore
    private weak var delegate: MnpSignViewControllerDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var signView: MnpSignature!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet private var agreementsTextView: LinkTextView!
    
    @IBAction
    func clearButtonDidTap(_ sender: Any) {
        signView.clear()
    }
    
    @IBAction
    func continueButtonDidTap(_ sender: Any) {
        guard let data = signView.getSignatureAsData() else { return }
        store.dispatch(action: .didCaptureImage(data: data))
    }
    
    init(store: MnpSignStore,
         navigationDelegate: MnpSignViewControllerDelegate) {
        self.store = store
        self.delegate = navigationDelegate
        super.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSign()
        setupObservers()
        store.dispatch(action: .didLoadView)
    }
    
    private func setupUI() {
        agreementsTextView.links = [(L10n.authUsernameAgreementsUrl, "")]
        clearButton.setImage(Assets.storeDelete.image, for: .normal)
        clearButton.backgroundColor = Colors.black
        clearButton.layer.cornerRadius = 12.0
        clearButton.clipsToBounds = true
        agreementsTextView.delegate = self
        setupLocalization()
        updateColors()
    }
    
    private func setupLocalization() {
        // TODO - !!!: localize
        titleLabel.text = "Распишитесь, пожалуйста"
        messageLabel.text = "Оставьте вашу подпись ниже, это необходимо для составления договора"
        continueButton.setTitle("Continue", for: .normal)
        agreementsTextView.text = L10n.authUsernameAgreementsBody
    }
    
    private func updateColors() {
        view.backgroundColor = Colors.fill1
    }
    
    private func setupSign() {
        signView.backgroundColor = Colors.white
        
    }
    
    private func setupObservers() {
        store.$state.observe(self) { vc, state in
            guard let state = state else { return }
            switch state {
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
}

// MARK: - UITextViewDelegate

extension MnpSignViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if textView.gestureRecognizers?.contains(where: { $0.isKind(of: UITapGestureRecognizer.self) && $0.state == .ended }) == true {
            delegate?.agreementsDidTap(self)
            return false
        }

        return true
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
}
