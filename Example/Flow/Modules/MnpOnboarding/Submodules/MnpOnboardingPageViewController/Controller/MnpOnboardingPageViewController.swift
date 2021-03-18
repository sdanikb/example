//
//  MnpOnboardingPageViewController.swift
//  Kcell-Activ
//
//  Created by admin on 11/24/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

final class MnpOnboardingPageViewController: BaseViewController {
    let onboarding: MnpOnboarding
    
    @IBOutlet private var tableView: UITableView!
        
    init(onboarding: MnpOnboarding) {
        self.onboarding = onboarding
        super.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        [MnpOnboardingPageTableViewCell.self].forEach { tableView.register(cellClass: $0) }
    }

    private func updateColors() {
        view.backgroundColor = Colors.fill1
    }
}

extension MnpOnboardingPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MnpOnboardingPageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: .init(onboarding: onboarding))
        return cell
    }
}
