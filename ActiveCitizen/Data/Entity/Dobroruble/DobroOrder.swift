//
//  DobroOrder.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 02.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

struct DobroOrder: Codable {
    let mechanics, buttonText, header: String
    let price: Int
    let categories: [DobroOfferCategory]
    let offer: DobroOffer?
    let offerRule: DobroOfferRule
    let offerType, organizationName: String
    let orderId: Int
    let createdAt: String
    let offerId: Int
    let logoUrl, orderStatus, coupon: String
    let used: Bool
    let activationTime: String?
}
