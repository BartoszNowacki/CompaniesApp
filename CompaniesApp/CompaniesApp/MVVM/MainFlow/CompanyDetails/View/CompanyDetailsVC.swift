//
//  CompanyDetailsVC.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 21/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class CompanyDetailsVC: UIViewController, IInstantiate {
    
    // MARK: STATIC
    
    static var navigationControllerIdentifier = "CompaniesNC"
    static var storyboardName = "Main"
    static var viewControllerIdentifier = "CompaniesVC"
    
    // MARK: OUTLETS
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: CompanyDetailsViewModelProtocol?
    
    static func instantiate(viewModel: CompanyDetailsViewModelProtocol) -> CompanyDetailsVC {
        let vc = instantiate()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getCompany()
    }
    
    private func bindUI() {
        viewModel?.company.asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] company in
                self?.setup(with: company)
            }).disposed(by: disposeBag)
    }
    
    private func setup(with company: CompanyDetails?) {
        if let company = company {
            nameLabel.text = company.name
            descriptionLabel.text = company.description
            cityLabel.text = company.address.city
            coordinatesLabel.text = "Długość: \(company.address.coorinates.longitude)  Szerokość: \(company.address.coorinates.latitude)"
            if let url = URL(string: company.cover_image) {
                KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
                    switch result {
                    case .success(let value):
                        self?.iconView.image = value.image                    case .failure(let error):
                        print("[KingfisherManager] image download error: \(error)")
                    }
                }
            }
            loadingIndicator.stopAnimating()
            loadingView.isHidden = true
        }
    }
}



