//
//  CompaniesViewModel.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 21/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CompaniesViewModelProtocol {
    
    init(provider: CompaniesProvider)
    
    var onShowCompanyDetails: ((Int) -> Void)? {get set}
    
    var companies: BehaviorRelay<[Company]> {get}
    var errorMessage: BehaviorRelay<String> {get}
    var provider: CompaniesProvider {get}
    var companiesCount: Int {get}

    func getCompaniesList()
    func getSearchedCompaniesList(for query: String)
    func getCompany(row: Int) -> Company
}

final class CompaniesViewModel: CompaniesViewModelProtocol {
    
    // MARK: FLOW COORDINATOR CALLBACKS
    
    var onShowCompanyDetails: ((Int) -> Void)?
    
    // MARK: PUBLIC PROPERTIES
    
    let provider: CompaniesProvider
    let companies = BehaviorRelay<[Company]>(value: [Company]())
    let errorMessage = BehaviorRelay<String>(value: "")
    
    var companiesCount: Int {
        return companies.value.count
    }
    
    // MARK: PRIVATE PROPERTIES
    
    private var page = 0
    private var allCompaniesList = [Company]()
    
    // MARK: INITIALIZERS

    required init(provider: CompaniesProvider = CompaniesProvider()) {
        self.provider = provider
        self.getCompaniesList()
    }
    
    // MARK: PUBLIC METHODS
    
    func getCompaniesList() {
        page+=1
        provider.getCompanies(for: page, completion: { [weak self] (companiesList, errorMessage) in
            
            switch (companiesList, errorMessage) {
            case (let companiesList?, nil):
                if let baseList = self?.allCompaniesList {
                    self?.allCompaniesList = baseList + companiesList.results
                    self?.companies.accept(baseList + companiesList.results)
                }
            case (_, .some(let errorMessage)):
                self?.errorMessage.accept(errorMessage)
            case (.none, .none):
                self?.errorMessage.accept("Coś poszło nie tak")
            }
        })
    }
    
    func getSearchedCompaniesList(for query: String) {
        provider.getSearchedCompanies(for: query, completion: { [weak self] (companiesList, errorMessage) in
            switch (companiesList, errorMessage) {
            case (let companiesList?, nil):
                self?.companies.accept(companiesList)
            case (_, .some(let errorMessage)):
                self?.errorMessage.accept(errorMessage)
            case (.none, .none):
                self?.errorMessage.accept("Coś poszło nie tak")
            }
        })
    }
    
    func getCompany(row: Int) -> Company {
        return companies.value[row]
    }
}

