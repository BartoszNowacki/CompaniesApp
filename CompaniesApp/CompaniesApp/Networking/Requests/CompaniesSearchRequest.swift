//
//  CompaniesSearchRequest.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 21/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import Foundation

struct CompaniesSearchRequest: Codable, APIEndpoint {
    let searchText: String
    
    init(for text: String) {
        self.searchText = text
    }
    
    func endpoint() -> String {
        return "companies/search"
    }
    
    func params() -> [URLQueryItem]? {
        return [URLQueryItem(name: "query", value: searchText)]
    }
    
    func dispatch(
        onSuccess successHandler: @escaping ((_: [Company]) -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _: Error) -> Void)) {
        
        APIRequest.get(
            request: self,
            onSuccess: successHandler,
            onError: failureHandler)
    }
}
