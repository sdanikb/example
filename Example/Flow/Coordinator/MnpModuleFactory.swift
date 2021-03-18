//
//  MnpModuleFactory.swift
//  Activ
//
//  Created by admin on 11/16/20.
//  Copyright © 2020 company. All rights reserved.
//

import Foundation
import Swinject

final class MnpModuleFactory {
    private let assembler: Assembler

    init(assembler: Assembler) {
        self.assembler = assembler
    }

    func makeTransferNumber(task: String, repository: MnpRepository, navigationDelegate: MnpNavigationDelegate) -> UIViewController {
        let store = MnpEnterStore(
            task: task,
            repository: repository,
            provider: assembler.resolver.resolve(Provider.self)!,
            formatter: assembler.resolver.resolve(PropertyFormatter.self)!)
        return MnpEnterViewController(store: store, navigationDelegate: navigationDelegate)
    }
    
    func makeSmsVerify(repository: MnpRepository,
                       inputParameters: MnpSmsVerifyInputParameters,
                       navigationDelegate: SmsVerifyNavigationDelegate) -> UIViewController {
        let store = SmsVerifyStore(repository: AnySmsVerifyRepository(repository: repository),
                                   inputParameters: inputParameters,
                                   formatter: assembler.resolver.resolve(PropertyFormatter.self)!)
        return SmsVerifyViewController(store: store, navigationDelegate: navigationDelegate)
    }

    func makeTransferOnboarding(navigationDelegate: MnpNavigationDelegate) -> UIViewController {
        let store = MnpOnboardingStore(provider: assembler.resolver.resolve(Provider.self)!)
        return MnpOnboardingViewController(store: store, navigationDelegate: navigationDelegate)
    }
    
    func makeMnpConsent(task: String, navigationDelegate: MnpNavigationDelegate) -> UIViewController {
        let store = MnpConsentStore(task: task, provider: assembler.resolver.resolve(Provider.self)!)
        return MnpConsentViewController(store: store, navigationDelegate: navigationDelegate)
    }
    
    func makeTariffsNew(viewState: TariffsNewStore.ViewState, navigationDelegate: TariffsNewNavigationDelegate) -> UIViewController {
        let store = TariffsNewStore(viewState: viewState,
                                    provider: assembler.resolver.resolve(Provider.self)!,
                                    storage: assembler.resolver.resolve(Storage.self)!,
                                    formatter: assembler.resolver.resolve(PropertyFormatter.self)!)
        return TariffsNewViewController(store: store, navigationDelegate: navigationDelegate)
    }
    
    func makeSelfieIntroduction(task: String, navigationDelegate: MnpSelfieNavigationDelegate) -> UIViewController {
        let store = MnpSelfieIntroductionStore(task: task)
        let selfieIntro = MnpSelfieIntroductionViewController(store: store, delegate: navigationDelegate)
        return selfieIntro
    }
    
    func makeSelfieProcess(task: String, navigationDelegate: MnpNavigationDelegate) -> UIViewController {
        //TODO text
        let store = MnpSelfieProcessStore(task: task, text: "", provider: assembler.resolver.resolve(Provider.self)!)
        let selfieProcess = MnpSelfieViewController(store: store, navigationDelegate: navigationDelegate)
        return selfieProcess
    }
    
    func makeConfirmation(task: String, info: MnpUserInformation, navigationDelegate: MnpNavigationDelegate) -> UIViewController {
        let store = MnpConfirmationStore(task: task, provider: assembler.resolver.resolve(Provider.self)!)
        return MnpConfirmationViewController(store: store, sections: [.info(info), .input], delegate: navigationDelegate)
    }
    
    func makeScanCategory(navigationDelegate: MnpScanCategoryViewControllerDelegate) -> UIViewController {
        let store = MnpScanCategoryStore(provider: assembler.resolver.resolve(Provider.self)!)
        return MnpScanCategoryViewController(store: store, navigationDelegate: navigationDelegate)
    }
    
    func makeScan(task: String,
                  category: MnpScanCategoryType,
                  navigationDelegate: MnpScanCategoryViewControllerDelegate) -> UIViewController {
        let store = MnpScanStore(task: task, category: category, provider: assembler.resolver.resolve(Provider.self)!)
        return MnpScanViewController(store: store, navigationDelegate: navigationDelegate)
    }
    
    func makeSign(task: String,
                  navigationDelegate: MnpSignViewControllerDelegate ) -> UIViewController {
        let store = MnpSignStore(task: task, provider: assembler.resolver.resolve(Provider.self)!)
        return MnpSignViewController(store: store, navigationDelegate: navigationDelegate)
    }
    
    func makeAgreements(delegate: AgreementsCoordinatorDelegate) -> (coordinator: Coordinator, module: UIViewController) {
        let navigationController = BaseNavigationController()
        let coordinator = AgreementsCoordinator(router: Router(navigationController: navigationController),
                                                presentInFloatingPanel: true,
                                                assembler: assembler,
                                                delegate: delegate)
        return (coordinator, navigationController)
    }
}
