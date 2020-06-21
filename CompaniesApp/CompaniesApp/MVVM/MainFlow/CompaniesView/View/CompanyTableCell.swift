//
//  CompanyTableCell.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 21/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import UIKit
import Kingfisher

class CompanyTableCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setup(with company: Company) {
        self.nameLabel.text = company.name
        if let url = URL(string: company.cover_image) {
            KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.iconView.image = value.image
                case .failure(let error):
                    print("[KingfisherManager] image download error: \(error)")
                }
            }
        }
    }
}
