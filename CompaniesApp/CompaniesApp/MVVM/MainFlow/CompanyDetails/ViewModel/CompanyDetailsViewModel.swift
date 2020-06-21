//
//  CompanyDetailsViewModel.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 21/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CompanyDetailsViewModelProtocol {
    
    init(provider: CompaniesProvider, companyID: Int)
    
    var onError: ((String) -> Void)? {get set}
    
    var company: BehaviorRelay<CompanyDetails?> {get}
    var provider: CompaniesProvider {get}
    
    func getCompany()
}

final class CompanyDetailsViewModel: CompanyDetailsViewModelProtocol {
    
    // MARK: FLOW COORDINATOR CALLBACKS
    
    var onError: ((String) -> Void)?
    
    // MARK: PUBLIC PROPERTIES
    
    let provider: CompaniesProvider
    let company = BehaviorRelay<CompanyDetails?>(value: nil)
    
    // MARK: PRIVATE PROPERTIES
    
    private let companyID: Int
    
    // MARK: INITIALIZERS
    
    required init(provider: CompaniesProvider = CompaniesProvider(), companyID: Int) {
        self.provider = provider
        self.companyID = companyID
        getCompany() 
    }
    
    // MARK: PUBLIC METHODS
    
    func getCompany() {
        provider.getCompanyDetails(for: companyID, completion: { [weak self] (company, errorMessage) in
            
            switch (company, errorMessage) {
            case (let company?, nil):
                self?.company.accept(company)
            case (_, .some(let errorMessage)):
                self?.onError?(errorMessage)
            case (.none, .none):
                self?.onError?("Coś poszło nie tak")
            }
        })
    }
}


