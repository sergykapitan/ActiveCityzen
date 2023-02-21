//
//  ProductInfo.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 17.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation

struct ProductInfo: Codable {
    let id, productId, productOptionId, price: Int
    let count: Int?
    let startTime: String
    let expireDate: String?
    let endTime: String?
    let discountPercent, costRub, activityTypeId, distance: Int
    let description: String
    let isPromocodes: Bool
    let productOption: ProductOption?
}
