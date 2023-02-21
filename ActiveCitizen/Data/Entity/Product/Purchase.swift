//
//  Purchase.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 20.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

struct Purchase: Codable {
    let userId: String
    let timestamp: Int
    let createdAt: String
    let expireDate: String?
    let invoiceTimestamp: Int
    let isActivated: Bool
    let productInfoId: Int
    let promocode: String?
    let purchaseInfo: PurchaseInfo
}

struct PurchaseInfo: Codable {
    let productInfoId, productId, productOptionId, price: Int
    let count: Int
    let startTime: String
    let endTime, expireDate: String?
    let discountPercent, costRub: Int
    let title, description: String
    let url: String
    let timeZone, agencyId: Int
    let images: [String]
    let productTypeId: Int
    let eventId: Int?
    let productType: ProductType
    let productOption: ProductOption
}
