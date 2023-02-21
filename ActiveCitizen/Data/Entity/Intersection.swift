//
//  Intersection.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 17.06.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Intersection: Object, Codable {
    dynamic var id = ""
    @objc dynamic var location: Location?
    @objc dynamic var status: String = ""
    @objc dynamic var timeStart: String = ""
    @objc dynamic var timeEnd: String? // Should not equal "null" the completion of the intersection
    dynamic var placeId = RealmOptional<Int>()
    dynamic var placePointId = RealmOptional<Int>()
    
    convenience required init(location: Location, status: String, timeStart: String, timeEnd: String) {
        self.init()
        self.location = location
        self.status = status
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.placeId = RealmOptional.init(nil)
        self.placePointId = RealmOptional.init(nil)
    }
    
    private enum CodingKeys: String, CodingKey {
        case location, status, timeStart, timeEnd, placeId, placePointId
    }
}
