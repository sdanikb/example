//
//  MnpUserInformationCell.swift
//  Kcell-Activ
//
//  Created by admin on 12/8/20.
//  Copyright © 2020 company. All rights reserved.
//
    
import UIKit

struct MnpUserInformation: Codable {
    let birthdate: String
    let docIssueDate: String
    let firstName: String
    let middleName: String
    let lastName: String
    let gender: String
    let docNumber: String
    let iin: String
    
    enum ContainerKeys: String, CodingKey {
        case info
    }
    
    enum CodingKeys: String, CodingKey {
        case birthdate = "birth_date"
        case docIssueDate = "doc_issue_date"
        case firstName = "first_name"
        case middleName = "middle_name"
        case lastName = "last_name"
        case docNumber = "doc_num"
        case iin = "idn"
        case gender
    }
}

final class MnpUserInformationCell: UITableViewCell {

    //MARK: - Photo and fullname
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var topFullNameLabel: UILabel!
    
    //MARK: - Fullname detailed
    @IBOutlet private weak var surnameTitleLabel: UILabel!
    @IBOutlet private weak var surnameLabel: UILabel!
    @IBOutlet private weak var nameTitleLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var lastNameTitleLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var genderTitleLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    
    //MARK: - Document info detailed
    @IBOutlet private weak var iinTitleLabel: UILabel!
    @IBOutlet private weak var iinLabel: UILabel!
    @IBOutlet private weak var docNumberTitleLabel: UILabel!
    @IBOutlet private weak var docNumberLabel: UILabel!
    @IBOutlet private weak var issueDateTitleLabel: UILabel!
    @IBOutlet private weak var issueDateLabel: UILabel!
    @IBOutlet private weak var birthdateTitleLabel: UILabel!
    @IBOutlet private weak var birthdateLabel: UILabel!
    
    private var titles: [UILabel?] {
        [surnameTitleLabel, nameTitleLabel, lastNameTitleLabel,
         genderTitleLabel, iinTitleLabel, docNumberTitleLabel,
         issueDateTitleLabel, birthdateTitleLabel]
    }
    
    private var lables: [UILabel?] {
        [surnameLabel, nameLabel, lastNameLabel,
         genderLabel, iinLabel, docNumberLabel,
         issueDateLabel, birthdateLabel]
    }
    
    func configure(with info: MnpUserInformation) {
        topFullNameLabel.text = info.firstName + " " + info.middleName
        nameLabel.text = info.firstName
        surnameLabel.text = info.middleName
        lastNameLabel.text = info.lastName
        genderLabel.text = info.gender
        iinLabel.text = "info"
        docNumberLabel.text = info.docNumber
        issueDateLabel.text = info.docIssueDate
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
    
    private func updateColors() {
        titles.forEach { $0?.textColor = Colors.gray1 }
        lables.forEach { $0?.textColor = Colors.text1 }
        topFullNameLabel.textColor = Colors.text1
    }
    
}
