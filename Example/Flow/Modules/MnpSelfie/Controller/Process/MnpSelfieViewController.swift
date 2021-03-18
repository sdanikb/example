//
//  MnpSelfieViewController.swift
//  Kcell-Activ
//
//  Created by admin on 12/30/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit
import AVFoundation
import verilive_mobilesdk_ios

final class MnpSelfieViewController: UIViewController {

    private let store: MnpSelfieProcessStore
    private weak var delegate: MnpNavigationDelegate?
    
    init(store: MnpSelfieProcessStore,
         navigationDelegate: MnpNavigationDelegate) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        self.setupFace()
    }

    private func setupFace() {
        let vc = VeriFaceViewController()
        vc.urlPath = "https://alpha.activ.kz/api/veridoc-dev/" //TODO
        vc.delegate = self
       
        addChild(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
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

// TODO - !!!: handle errors
extension MnpSelfieViewController: VeriFaceViewControllerDelegate {
    func dismissByUser() {}
    
    func verifacePassed(_ encodedImage: String) {
        store.dispatch(action: .didCaptureImage(data: encodedImage))
    }
    
    func verifaceFailed(_ encodedImage: String) {
        self.showToast(category: .error, message: "verifaceFailed")
    }
    
    func verifaceError(_ errorText: String) {
        self.showToast(category: .error, message: "verifaceError")
    }
}
