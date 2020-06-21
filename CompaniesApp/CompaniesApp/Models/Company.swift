//
//  CompaniesList.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 21/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import Foundation

struct Company: Codable {
    let id: Int
    let name: String
    let cover_image: String
    let address: Address
}

struct Address: Codable {
    let city: String
    let coordinates: Coordinates
}

struct Coordinates: Codable {
    let latitude: String
    let longitude: String
}

struct CompanyDetails: Codable {
    let address: Address
    let cover_image: String
    let description: String
    let id: Int
    let name: String
}
