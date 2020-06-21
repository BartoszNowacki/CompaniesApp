//
//  CompanyDetailsRequest.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 21/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import Foundation
import Foundation

struct CompanyDetailsRequest: Codable, APIEndpoint {
    let id: Int
      
      init(for id: Int) {
          self.id = id
      }
    
    func endpoint() -> String {
        return "companies/\(id)"
    }
    
    func params() -> [URLQueryItem]? {
        return nil
    }
    
    func dispatch(
        onSuccess successHandler: @escaping ((_: CompanyDetails) -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _: Error) -> Void)) {
        
        APIRequest.get(
            request: self,
            onSuccess: successHandler,
            onError: failureHandler)
    }
}
