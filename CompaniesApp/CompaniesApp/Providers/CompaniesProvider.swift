//
//  CompaniesProvider.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 21/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import Foundation

protocol CompaniesProviderProtocol {
    func getCompanies(for page: Int, completion: @escaping (CompaniesList?, String?) -> Void)
    func getSearchedCompanies(for query: String, completion: @escaping ([Company]?, String?) -> Void)
    func getCompanyDetails(for id: Int, completion: @escaping (CompanyDetails?, String?) -> Void)
}

final class CompaniesProvider: CompaniesProviderProtocol {
    func getCompanies(for page: Int, completion: @escaping (CompaniesList?, String?) -> Void) {
        CompaniesListRequest(pageNumber: page)
        .dispatch(
            onSuccess: { (successResponse) in
                completion(successResponse, nil)
        },
            onFailure: { (errorResponse, error) in
                print("Error occurred during download process")
                if let errorResponse = errorResponse {
                    print("Error: \(errorResponse.error.info)")
                    completion(nil, errorResponse.error.info)
                }
        })
    }
    
    func getSearchedCompanies(for query: String, completion: @escaping ([Company]?, String?) -> Void) {
        CompaniesSearchRequest(for: query)
        .dispatch(
            onSuccess: { (successResponse) in
                completion(successResponse, nil)
        },
            onFailure: { (errorResponse, error) in
                print("Error occurred during download process")
                if let errorResponse = errorResponse {
                    print("Error: \(errorResponse.error.info)")
                    completion(nil, errorResponse.error.info)
                }
        })
    }
    
    func getCompanyDetails(for id: Int, completion: @escaping (CompanyDetails?, String?) -> Void) {
        CompanyDetailsRequest(for: id)
        .dispatch(
            onSuccess: { (successResponse) in
                completion(successResponse, nil)
        },
            onFailure: { (errorResponse, error) in
                print("Error occurred during download process")
                if let errorResponse = errorResponse {
                    print("Error: \(errorResponse.error.info)")
                    completion(nil, errorResponse.error.info)
                }
        })
    }
}
