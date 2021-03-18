//
//  MnpCoordinator.swift
//  Activ
//
//  Created by admin on 11/16/20.
//  Copyright © 2020 company. All rights reserved.
//

import Foundation
import Swinject
import FloatingPanel

protocol MnpCoordinatorDelegate: class {
    
}

final class MnpCoordinator: Coordinator {
    private let repository: MnpRepository
    private let moduleFactory: MnpModuleFactory
    private weak var delegate: MnpCoordinatorDelegate?
    
    init(router: Router, assembler: Assembler, delegate: MnpCoordinatorDelegate) {
        let provider = assembler.resolver.resolve(Provider.self)!
        self.repository = MnpRepository(provider: provider)
        self.moduleFactory = MnpModuleFactory(assembler: assembler)
        self.delegate = delegate
        super.init(router: router)
    }

    override func start() {
        showSign(task: "")
//        showOnboarding()
    }
    
    private func showSelfieIntroduction(task: String) {
        let selfie = moduleFactory.makeSelfieIntroduction(task: task, navigationDelegate: self)
        router.push(selfie)
    }
    
    private func showSelfieProcess(task: String) {
        let vc = moduleFactory.makeSelfieProcess(task: task, navigationDelegate: self)
        router.push(vc)
    }
    
    private func showConfirmation(task: String, info: MnpUserInformation) {
        let vc = moduleFactory.makeConfirmation(task: task, info: info, navigationDelegate: self)
        router.push(vc)
    }

    private func showEnterTransferNumber(task: String) {
        let enterTransferNumber = moduleFactory.makeTransferNumber(task: task, repository: repository, navigationDelegate: self)
        router.push(enterTransferNumber)
    }
    
    private func showSmsVerify() {
        let phoneNumber = repository.transferPhoneNumber ?? ""
        let inputParameters = MnpSmsVerifyInputParameters(phoneNumber: phoneNumber)
        let smsVerify = moduleFactory.makeSmsVerify(repository: repository, inputParameters: inputParameters, navigationDelegate: self)
        router.push(smsVerify)
    }
    
    private func showOnboarding() {
        let onboarding = moduleFactory.makeTransferOnboarding(navigationDelegate: self)
        router.push(onboarding)
    }
    
    private func showConsent(task: String) {
        let consent = moduleFactory.makeMnpConsent(task: task, navigationDelegate: self)
        router.present(consent)
    }
    
    private func showTariffsNew(viewState: TariffsNewStore.ViewState) {
        let vc = moduleFactory.makeTariffsNew(viewState: viewState, navigationDelegate: self) //TODO: process selected tariff
        router.push(vc)
    }
    
    private func showScanCategory() {
        let vc = moduleFactory.makeScanCategory(navigationDelegate: self)
        router.push(vc)
    }
    
    private func showScan(category: MnpScanCategoryType) {
        let vc = moduleFactory.makeScan(task: repository.currentTask ?? "",
                                        category: category,
                                        navigationDelegate: self)
        router.push(vc)
    }
    
    private func showSign(task: String) {
        let vc = moduleFactory.makeSign(task: task,
                                        navigationDelegate: self)
        router.push(vc)
    }
    
    private func runAgreementsFlow() {
        let (coordinator, module) = moduleFactory.makeAgreements(delegate: self)
        addDependency(coordinator)
        coordinator.start()
        router.presentFloatingPanel(module, animated: true, delegate: self)
    }
}

extension MnpCoordinator: MnpNavigationDelegate {
    func process(response: MnpStepResponse) {
        repository.currentTask = response.task
        switch response.type {
        case .enteringNumber:
            showEnterTransferNumber(task: response.task)
        case .otp:
            showSmsVerify()
        case .consent:
            showConsent(task: response.task)
        case .tariff:
            showTariffsNew(viewState: .tariffs)
        case .scan:
            showScanCategory()
        case .selfie:
            showSelfieIntroduction(task: response.task)
        case let .confirmation(info):
            showConfirmation(task: response.task, info: info)
        case .sign:
            showSign(task: response.task)
        case .done:
            break //TODO: Finish process
        }
    }
}

//TODO: Sms resending
extension MnpCoordinator: SmsVerifyNavigationDelegate {
    func onVerifyLimitDidExceed<InputParameters: SmsVerifyInputParameters>(_ viewController: SmsVerifyViewController<InputParameters>) {
        router.popModule()
    }

    func verifyDidFailWithError<InputParameters: SmsVerifyInputParameters>(_ viewController: SmsVerifyViewController<InputParameters>,
                                                                           errorMessage: String?) {
        router.popModule()
    }

    func verifyDidFail<InputParameters: SmsVerifyInputParameters>(_ viewController: SmsVerifyViewController<InputParameters>) {
        router.popModule()
    }

    func verifyDidFinish<InputParameters: SmsVerifyInputParameters>(_ viewController: SmsVerifyViewController<InputParameters>) {
        guard let response = repository.response else { return }
        process(response: response)
    }
}

extension MnpCoordinator: MnpSelfieNavigationDelegate {
    
    func onIntroductionComplete(task: String) {
        showSelfieProcess(task: task)
    }
    
}

//TODO
extension MnpCoordinator: TariffsNewNavigationDelegate {
    
    func tariffDidSelect(_ viewController: TariffsNewViewController, category: FinanceCategory?, tariff: Tariff) {
        
    }
    
    func connectDidTap(_ viewController: TariffsNewViewController, data: TariffConnectConfirmData) {
        
    }
    
    func viewStateDidSelect(_ viewController: TariffsNewViewController, viewState: TariffsNewStore.ViewState) {
        
    }

}
 
extension MnpCoordinator: MnpScanCategoryViewControllerDelegate {
    func didSelectCategory(_ viewController: MnpScanCategoryViewController, category: MnpScanCategoryType) {
        showScan(category: category)
    }
}

extension MnpCoordinator: MnpSignViewControllerDelegate {
    func agreementsDidTap(_ viewController: MnpSignViewController) {
        runAgreementsFlow()
    }
}

// MARK: - AgreementsCoordinatorDelegate

extension MnpCoordinator: AgreementsCoordinatorDelegate {
    func didFinish(_ coordinator: AgreementsCoordinator) {
        removeDependency(coordinator)
    }
}

extension MnpCoordinator: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        FullFloatingPanelLayout()
    }

    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        guard let coordinator = childCoordinators.first(where: { $0.router.navigationController == vc.contentViewController }) else { return }
        removeDependency(coordinator)
    }
}
