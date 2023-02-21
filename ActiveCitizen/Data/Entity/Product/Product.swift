//
//  Product.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 17.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation

struct Product: Codable {
    let id: Int
    let images: [String]
    let productTypeId: Int
    let eventId: Int?
    let title, description: String
    let url: String
    let timeZone, agencyId: Int
    let isPublished: Bool
    let rules, additional, preview: String?
    let places: [Place]?
    let agency: Agency
    let event: Event?
    let productType: ProductType
    let productInfo: [ProductInfo]
    let partner: Partner
}
