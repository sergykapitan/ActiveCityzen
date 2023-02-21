//
//  DobroOfferRule.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 02.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

struct DobroOfferRule: Codable {
    let startTime, endTime: String
    let expirationTime: String?
    let saleLimit, minAge, maxAge: Int?
}
