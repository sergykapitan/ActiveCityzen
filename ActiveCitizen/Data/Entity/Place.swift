//
//  Place.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 09.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//
struct Place: Codable {
    let id: Int
    let title, description: String
    let images: [String]
    let addressId: Int
    let shortTitle, qrLocation: String
    let qrLocationImage: String?
    let qrLocationImages: [String]?
    let address: Address?
    let instagram, vk, phoneNumber: String
    let rate, agencyId, institutionId: Int
    let dailyMax, prize: Int?
    let maxPrize: Int?
    let maxDailyMax: Int?
    let schedule: String?
    let placePolygons: [PlacePolygons]?
    let distance: Double?
}
