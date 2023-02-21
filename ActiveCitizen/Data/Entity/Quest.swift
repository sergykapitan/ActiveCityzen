//
//  Quest.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 12.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

class Quest: Codable {
    let id: Int
    let title, description, hint, additional: String
    let image: String?
    let rate: Int
    let isGlobal: Bool
    let activityTypeId: Int?
//    let activityType: ActivityType
    let maxDailyMax: Int?
    let maxMultiplier: Double?
    let maxPrize: Int?
    let maxActivityPay: Double?
    let places: [Place]?
}

