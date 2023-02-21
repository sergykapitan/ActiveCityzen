//
//  Invoice.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 12.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

struct Invoice: Codable {
    let userId, firstTimestamp, lastTimestamp: String
    let amount: Double
//    let purchasedProducts: [Product]
    let quest: Quest
    let place: Place?
    let isActivity: Bool
}
