//
//  DobrorubleOffer.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 25.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

struct DobroOffer: Codable {
    let mechanics, buttonText, header: String
    let price: Int
    let offerType: String
    let categories: [DobroOfferCategory]
    let description: String
    let createdAt: String?
    let activationTime: String?
    let redirectUrl: String
    let offerId: Int
    let inStock: Int
    let logoUrl, imageUrl : String
    let smallImageUrl : String
    let used: Int
    let isPartnerQr, isPersonalQr: Bool
}
