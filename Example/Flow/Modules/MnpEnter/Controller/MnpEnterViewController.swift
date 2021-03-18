//
//  MnpEnterViewController.swift
//  Kcell-Activ
//
//  Created by admin on 11/16/20.
//  Copyright © 2020 company. All rights reserved.
//
    

import UIKit

protocol MnpNavigationDelegate: class {
    func process(response: MnpStepResponse)
}

final class MnpEnterViewController: BaseViewController {
    
    @IBOutlet private weak var topDescriptionLabel: UILabel!
    @IBOutlet private weak var enterPhoneNumberToTransferField: PhoneNumberTextField!
    @IBOutlet private weak var contactPhoneNumberField: PhoneNumberTextField!
    @IBOutlet private weak var emailField: EmailTextField!
    @IBOutlet private weak var confirmEmailField: EmailTextField!
    @IBOutlet private weak var nextButton: UIButton!

    private let store: MnpEnterStore
    private weak var delegate: MnpNavigationDelegate?
    
    init(store: MnpEnterStore, navigationDelegate: MnpNavigationDelegate) {
        self.store = store
        self.delegate = navigationDelegate
        super.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
    
    private func setupObservers() {
        store.$state.observe(self) { vc, state in
            guard let state = state else { return }
            switch state {
            case let .error(message):
                vc.showToast(category: .error, message: message)
            case let .emailError(message):
                vc.confirmEmailField.setErrorMessage(message, animated: true)
            case .loading:
                break
            case .finished(let response):
                vc.delegate?.process(response: response)
            }
        }
    }
    
    private func setupUI() {
        setupLocalization()
        updateColors()
    }
    
    private func setupLocalization() {
        navigationItem.title = "Введите номер для переноса"
        topDescriptionLabel.text = "Введите номер, который хотите перенести в Kcell"
        enterPhoneNumberToTransferField.placeholder = "Номер для переноса"
        contactPhoneNumberField.placeholder = "Контактный номер"
        contactPhoneNumberField.setNoteMessage("По этому номеру мы свяжемся с Вами для уточнения деталей")
        emailField.placeholder = "E-mail"
        confirmEmailField.placeholder = "Подтвердите e-mail"
        nextButton.setTitle("Далее", for: .normal)
    }
    
    private func updateColors() {
        view.backgroundColor = Colors.background
        topDescriptionLabel.backgroundColor = Colors.text1
    }
    
    @IBAction func nextButtonDidPress(_ sender: Any) {
        store.dispatch(action:
            .didTapNextButton(
                primaryPhone: enterPhoneNumberToTransferField.text ?? "",
                contactPhone: contactPhoneNumberField.text ?? "",
                email: emailField.text ?? "",
                confirmEmail: confirmEmailField.text ?? ""
            )
        )
    }
}
