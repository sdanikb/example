//
//  MnpSelfieProcessViewController.swift
//  Kcell-Activ
//
//  Created by admin on 12/3/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit
import AVFoundation
import VeridocSDK

final class MnpScanViewController: BaseViewController {

    private let store: MnpScanStore
    private weak var delegate: MnpNavigationDelegate?
        
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet private weak var visibleRect: UIView!
    @IBOutlet private weak var cameraView: UIView!
            
    init(store: MnpScanStore,
         navigationDelegate: MnpNavigationDelegate) {
        self.store = store        
        super.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()
        store.dispatch(action: .didLoadView)
    }
    
    private func setupUI() {        
        updateColors()
    }
    
    private func updateColors() {
        view.backgroundColor = Colors.fill1
    }
    
    private func setupScaner(category: MnpScanCategoryType) {
        
        let vc = ScannerViewController()
        vc.delegate = self
        switch category {
        case .idCard:
            vc.type = .IdentityDocument
            vc.recognitionMode = .TwoSidedDocument
        case .passport:
            vc.type = .Mrz
            vc.recognitionMode = .SingleImage
        case .residencePermit:
            vc.type = .IdentityDocument
            vc.recognitionMode = .TwoSidedDocument
        }
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
            case .didGet(let category):
                vc.setupScaner(category: category)
            case .finished(let response):
                vc.delegate?.process(response: response)            
            }
        }
    }
    
}

// TODO - !!!: handle errors
extension MnpScanViewController: ScannerViewControllerDelegate {
    func onSuccessCallback(_ result: [AnyHashable : Any]!) {
        guard let meta = result as? [String: Any] else { return }
        store.dispatch(action: .didCaptureImage(data: meta))
    }
    
    func onErrorCallback(_ result: [AnyHashable : Any]!) {
        self.showToast(category: .error, message: "onErrorCallback")
    }
    
    func onLogEventCallback(_ result: [AnyHashable : Any]!) {}
    
    func scannerSuspendedByUserAction() {}
}

