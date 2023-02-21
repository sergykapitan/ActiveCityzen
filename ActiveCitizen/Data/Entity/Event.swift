//
//  Event.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 17.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation

struct Event: Codable {
    let id: Int
    let images: [String]
    let agencyId, placeId: Int?
    let title, description: String?
    let isFinished: Bool
    let startTime, endTime: String?
    let url: String
    let type: String?
    let place: Place?
    let rate, timeZone: Int
}
