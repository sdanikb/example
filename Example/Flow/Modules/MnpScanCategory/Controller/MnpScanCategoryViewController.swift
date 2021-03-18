//
//  MnpScanCategoryViewController.swift
//  Kcell-Activ
//
//  Created by admin on 11/24/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

protocol MnpScanCategoryViewControllerDelegate: MnpNavigationDelegate {
    func didSelectCategory(_ viewController: MnpScanCategoryViewController, category: MnpScanCategoryType)
}

final class MnpScanCategoryViewController: BaseViewController {
    private weak var navigationDelegate: MnpScanCategoryViewControllerDelegate?
    private let store: MnpScanCategoryStore
    private let tableViewDataSourceImpl: MnpScanCategoryTableViewDataSourceImpl
    private let tableViewDelegateImpl: MnpScanCategoryTableViewDelegateImpl
    
    @IBOutlet private var tableView: UITableView!

    init(store: MnpScanCategoryStore,
         navigationDelegate: MnpScanCategoryViewControllerDelegate) {
        self.store = store
        self.navigationDelegate = navigationDelegate
        tableViewDataSourceImpl = .init()
        tableViewDelegateImpl = .init(store: store)
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
        setupTableView()
        updateColors()
    }
    private func setupTableView() {
        tableViewDelegateImpl.tableView = tableView
        tableView.dataSource = tableViewDataSourceImpl
        tableView.delegate = tableViewDelegateImpl
        [MnpScanCategoryHeaderView.self].forEach { tableView.register(aClass: $0) }
        [MnpScanCategoryInfoCell.self, MnpScanCategoryCell.self].forEach { tableView.register(cellClass: $0) }
    }
    private func updateColors() {
        view.backgroundColor = Colors.fill1
    }
    
    private func setupObservers() {
        store.$state.observe(self) { vc, state in
            guard let state = state else { return }
            switch state {
            case let .initial(sections):
                vc.tableViewDataSourceImpl.sections = sections
                vc.tableViewDelegateImpl.sections = sections
                vc.tableView.reloadData()
            case let .optionSelected(category):
                vc.tableView.setContentOffset(.zero, animated: true)
                vc.navigationDelegate?.didSelectCategory(self, category: category)
            }
        }
    }
}
