//
//  ProductPurchaseResponse.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 20.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

struct ProductPurchaseStatus: Codable {
    let key: String?
    let userId, orderId: String
    let pendingProducts: [PendingProduct]
    let purchasesTimestamps: [Int]?
    let status: String
}
