//
//  Location.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 10.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

import Foundation
//import Realm
import RealmSwift

/// Entity that specifies user's location
class Location: Object, Codable {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0

   convenience required init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
    static let nullIsland = Location(latitude: 0.0, longitude: 0.0)
}
