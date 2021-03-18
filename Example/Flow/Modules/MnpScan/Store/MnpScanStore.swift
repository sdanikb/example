//
//  MnpSelfieStore.swift
//  Kcell-Activ
//
//  Created by admin on 12/3/20.
//  Copyright © 2020 company. All rights reserved.
//

import AVFoundation
import Promises

struct ScanData {
    let birthDate: String
    let docType: String
    let dueDate: String
    let facePicture: String
}

final class MnpScanStore {
    
    enum Action {
        case didLoadView
        case didCaptureImage(data: [String: Any])
    }

    enum State {
        case error(message: String)
        case loading
        case loadingFinished
        case didGet(category: MnpScanCategoryType)
        case finished(response: MnpStepResponse)
    }
    
    @Observable private(set) var state: State?
    
    private let task: String
    
    private let category: MnpScanCategoryType
    private let provider: MnpProvider
    
    private var isRequestSent = false
    
    init(task: String,
         category: MnpScanCategoryType,
         provider: MnpProvider) {
        self.provider = provider
        self.task = task
        self.category = category
    }
    
    func dispatch(action: Action) {
        switch action {
        case .didLoadView:
            state = .didGet(category: category)
        case .didCaptureImage(let data):
            let step = MnpScanStep(task: task, meta: data)
            
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
