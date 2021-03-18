//
//  MnpOnboardingStore.swift
//  Kcell-Activ
//
//  Created by admin on 11/24/20.
//  Copyright © 2020 company. All rights reserved.
//

import Foundation
import Promises

final class MnpOnboardingStore {

    enum Action {
        case didLoadView
        case didTapNextButton
        case didScroll(Int)
    }

    enum State {
        case loading
        case loaded([MnpOnboarding])
        case loadingFinished
        case error(String)
        case next(Int)
        case finished(MnpStepResponse)
        case changeNextButtonTitle(String)
    }
    
    @Observable private(set) var state: State?
    private let provider: MnpProvider
    
    private var onboardings: [MnpOnboarding] = []
    private var selectedIndex = 0 {
        didSet {            
            state = .changeNextButtonTitle(onboardings[selectedIndex].action)
        }
    }
    
    init(provider: MnpProvider) {
        self.provider = provider
    }
    
    func dispatch(action: Action) {
        switch action {
        case .didLoadView:
            state = .loading
            provider.getOnboarding().then { [weak self] result in
                guard let self = self else { return }
                self.onboardings = result
                self.state = .loaded(result)
                self.selectedIndex = 0
            }.catch { [weak self] error in
                guard let self = self else { return }
                self.state = .error(error.wrappedError.localizedDescription)
            }.always { [weak self] in
                self?.state = .loadingFinished
            }
        case .didTapNextButton:
            if selectedIndex + 1 < onboardings.count {
                selectedIndex += 1
                state = .next(selectedIndex)                
            } else {
                state = .loading
                provider.start().then { [weak self] response in
                    self?.state = .finished(response)
                }.catch { error in
                    // TODO - !!!: handle error
                    print(error)
                }.always { [weak self] in
                    self?.state = .loadingFinished
                }
            }
        case .didScroll(let index):
            selectedIndex = index
        }
    }    
}
