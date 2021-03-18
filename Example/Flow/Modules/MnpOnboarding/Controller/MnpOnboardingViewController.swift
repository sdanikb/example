//
//  MnpOnboardingViewController.swift
//  Kcell-Activ
//
//  Created by admin on 11/24/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

final class MnpOnboardingViewController: BaseViewController {
    private var pageViewController: PageViewController?
    private weak var navigationDelegate: MnpNavigationDelegate?
    private let store: MnpOnboardingStore
    

    @IBOutlet private var containerView: UIView!
    @IBOutlet private var nextView: MnpOnboardingNextView!

    init(store: MnpOnboardingStore,
         navigationDelegate: MnpNavigationDelegate) {
        self.store = store
        self.navigationDelegate = navigationDelegate
        super.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()
        store.dispatch(action: .didLoadView)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }

    private func setupUI() {
        setupNextView()
        updateColors()
    }

    private func setupNextView() {
        nextView.isHidden = true
        nextView.delegate = self
    }
    
    private func setupPageViewController() {
        guard let pageViewController = pageViewController else { return }
        pageViewController.delegate = self
        containerView.addSubview(pageViewController.view)
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            pageViewController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
            pageViewController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0),
            pageViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
    }

    private func updateColors() {
        view.backgroundColor = Colors.fill1
    }
    
    private func setupObservers() {
        store.$state.observe(self) { vc, state in
            guard let state = state else { return }
            switch state {
            case .finished(let response):
                vc.navigationDelegate?.process(response: response)
            case .loading:
                ProgressHud.startAnimating()
            case .loadingFinished:
                ProgressHud.stopAnimating()
            case .loaded(let onboardings):                
                vc.showPages(onboardings: onboardings)
            case .next(let selectedIndex):
                vc.pageViewController?.selectedIndex = selectedIndex
            case .error(let message):
                vc.showToast(category: .error, message: message)
            case .changeNextButtonTitle(let title):
                vc.nextView.isHidden = false
                vc.nextView.configure(with: title)
            }
        }
    }
}

extension MnpOnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first,
            let index = self.pageViewController?.allViewControllers.firstIndex(of: viewController) else { return }
        store.dispatch(action: .didScroll(index))
    }
}

extension MnpOnboardingViewController: MnpOnboardingNextViewDelegate {
    func nextButtonDidTap(_ view: MnpOnboardingNextView) {
        store.dispatch(action: .didTapNextButton)
    }
}

extension MnpOnboardingViewController {
    func showPages(onboardings: [MnpOnboarding]) {
        let vcs = onboardings
            .map { MnpOnboardingPageViewController(onboarding: $0) }
        pageViewController = PageViewController(viewControllers: vcs)
        setupPageViewController()
    }
}
