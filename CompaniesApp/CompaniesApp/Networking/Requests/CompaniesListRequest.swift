//
//  Requests.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 21/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import Foundation

struct CompaniesListRequest: Codable, APIEndpoint {
    let pageNumber: Int
    
    init(pageNumber: Int) {
        self.pageNumber = pageNumber
    }
    
    func endpoint() -> String {
        return "companies"
    }
    
    func params() -> [URLQueryItem]? {
        return [URLQueryItem(name: "page_number", value: String(pageNumber))]
    }
    
    func dispatch(
        onSuccess successHandler: @escaping ((_: CompaniesList) -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _: Error) -> Void)) {
        
        APIRequest.get(
            request: self,
            onSuccess: successHandler,
            onError: failureHandler)
    }
}
