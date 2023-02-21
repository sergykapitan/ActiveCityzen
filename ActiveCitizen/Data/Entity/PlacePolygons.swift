//
//  PlacePolygons.swift
//  ActiveCitizen
//
//  Created by Sergey on 28.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

struct PlacePolygons : Codable {
    let id, placeID: Int
    let coordinates: [[Double]]

        enum CodingKeys: String, CodingKey {
            case id
            case placeID = "placeId"
            case coordinates
        }

}
