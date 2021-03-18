//
//  MnpSignStore.swift
//  Kcell-Activ
//
//  Created by admin on 12/3/20.
//  Copyright © 2020 company. All rights reserved.
//

import Promises

final class MnpSignStore {
    
    enum Action {
        case didLoadView
        case didCaptureImage(data: Data)
    }

    enum State {
        case error(message: String)
        case loading
        case loadingFinished
        case finished(response: MnpStepResponse)
    }
    
    @Observable private(set) var state: State?
    
    private let task: String
    
    private let provider: MnpProvider
    
    private var isRequestSent = false
    
    init(task: String,
         provider: MnpProvider) {
        self.provider = provider
        self.task = task
    }
    
    func dispatch(action: Action) {
        switch action {
        case .didLoadView:
            state = .loadingFinished
        case .didCaptureImage(let data):
            state = .loading
            let base64 = data.base64EncodedString()            
            let step = MnpSignStep(task: task, sign: base64)
            
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
