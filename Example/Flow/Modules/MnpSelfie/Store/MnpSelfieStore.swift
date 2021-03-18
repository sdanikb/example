//
//  MnpSelfieStore.swift
//  Kcell-Activ
//
//  Created by admin on 12/3/20.
//  Copyright © 2020 company. All rights reserved.
//

import AVFoundation
import Promises

final class MnpSelfieProcessStore {
    
    enum Action {
        case didCaptureImage(data: String)
    }

    enum State {
        case error(message: String)
        case loading
        case loadingFinished
        case finished(response: MnpStepResponse)
    }
    
    let text: String
    
    @Observable private(set) var state: State?
    
    private let task: String
    private let provider: MnpProvider
    
    private var isRequestSent = false
    
    init(task: String, text: String, provider: MnpProvider) {
        self.text = text
        self.provider = provider
        self.task = task
    }
    
    func dispatch(action: Action) {
        switch action {
        case .didCaptureImage(let data):
            let step = MnpSelfieStep(task: task, selfie: data)
            
            provider.step(step).always { [weak self] in
                self?.state = .loadingFinished
            }.then { [weak self] response in
                self?.state = .finished(response: response)
            }.catch { [weak self] error in
                self?.state = .error(message: error.localizedDescription)
            }
        }
    }
}


final class MnpSelfieIntroductionStore {
    
    enum Action {
        case introductionCompleted
    }
    
    enum State {
        case permissionGranted
        case permissionDenied
    }
    
    let task: String
    
    init(task: String) {
        self.task = task
    }
        
    @Observable private(set) var state: State?

    func dispatch(action: Action) {
        switch action {
        case .introductionCompleted:
            checkCameraPermission()
        }
    }
    
    private func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.state = granted ? .permissionGranted : .permissionDenied
                }
            }
        case .restricted, .denied:
            state = .permissionDenied
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .authorized:
            state = .permissionGranted
        @unknown default:
            state = .permissionDenied
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
