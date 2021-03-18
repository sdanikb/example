//
//  MnpConfirmationViewController.swift
//  Kcell-Activ
//
//  Created by admin on 12/8/20.
//  Copyright © 2020 company. All rights reserved.
//
    
import UIKit

enum MnpConfirmationSection {
    case info(MnpUserInformation)
    case input
}

final class MnpConfirmationViewController: BaseViewController {
    
    private let sections: [MnpConfirmationSection]
    private let store: MnpConfirmationStore
    private weak var delegate: MnpNavigationDelegate?
    
    init(store: MnpConfirmationStore, sections: [MnpConfirmationSection], delegate: MnpNavigationDelegate) {
        self.store = store
        self.sections = sections
        self.delegate = delegate
        super.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil}
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var continueButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.reloadData()
        setupObservers()
    }
    
    private func setupObservers() {
        store.$state.observe(self) { vc, state in
            guard let state = state else { return }
            switch state {
            case let .error(error):
                vc.showToast(category: .error, message: error)
            case let .finished(response):
                vc.delegate?.process(response: response)
            }
        }
    }
    
    private func setupUI() {
        [MnpUserInformationCell.self, MnpUserDataInputCell.self].forEach {
            tableView.register(cellClass: $0)
        }
        updateColors()
    }
    
    private func updateColors() {
        tableView.backgroundColor = Colors.background
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
    
}

extension MnpConfirmationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case let .info(info):
            let cell: MnpUserInformationCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: info)
            return cell
        case .input:
            let cell: MnpUserDataInputCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
        
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
    
}
