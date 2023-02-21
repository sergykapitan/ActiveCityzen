//
//  UserStats.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 12.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

struct UserStats: Codable {
    let stepsCount: Int
    let distance: Double
    let activityTime: Double
    let speed: Double?
}
