//
//  MnpConfirmationStore.swift
//  Kcell-Activ
//
//  Created by admin on 12/8/20.
//  Copyright © 2020 company. All rights reserved.
//

import Foundation

final class MnpConfirmationStore {
    
    enum Action {
        case didTapConfirmButton(city: String, street: String, house: String, apartment: String, zipcode: String)
    }
    
    enum State {
        case error(String)
        case finished(response: MnpStepResponse)
    }
    
    private let task: String
    private let provider: MnpProvider
    
    @Observable private(set) var state: State?
    
    init(task: String, provider: MnpProvider) {
        self.task = task
        self.provider = provider
    }
    
    func dispatch(action: Action) {
        switch action {
        case let .didTapConfirmButton(city, street, house, apartment, zipcode):
            let step = MnpConfirmationStep(task: task, city: city, postal: zipcode, street: street, build: house)
            provider.step(step).then { [weak self] response in
                self?.state = .finished(response: response)
            }.catch { [weak self] error in
                self?.state = .error(error.localizedDescription)
            }
        }
    }
        
}
