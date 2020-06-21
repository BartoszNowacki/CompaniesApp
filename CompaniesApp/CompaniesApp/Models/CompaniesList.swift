//
//  Companies.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 21/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import Foundation

struct CompaniesList: Codable {
    let page: String
    let results: [Company]
}
