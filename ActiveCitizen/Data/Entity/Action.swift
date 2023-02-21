//
//  Action.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 10.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

import RealmSwift
/// An atomic unit of user's physical activity.
class Action: Object, Codable {
    /// User's platform constant. In iOS it is always "appleHealth"
    @objc dynamic var platform: String = "appleHealth"
    /// How many steps passed since the last
    @objc dynamic var stepsCount: Int = -1
    @objc dynamic var distance: Int = 0
    /// When the activity was captured
    @objc dynamic var timeStart: String = ""
    /// When the activity was captured
    @objc dynamic var timeEnd: String = ""
    /// User location, where the activity 
    @objc dynamic var location: Location? = nil
    /// User's current pace
    @objc dynamic var currentPace: Double = 0.0
    /// Identifier of user activity
    dynamic var activityTypeId: Int? = nil
    
    convenience required init(timeStart: String, timeEnd: String, stepsCount: Int, activityTypeId: Int) {
        self.init()
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.stepsCount = stepsCount
        self.activityTypeId = activityTypeId
    }
    
    convenience required init(timeStart: String, timeEnd: String, location: Location, activityTypeId: Int) {
        self.init()
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.location = location
        self.activityTypeId = activityTypeId
    }
    
    convenience required init(timeStart: String, timeEnd: String, location: Location, activityTypeId: Int, currentPace: Double) {
        self.init()
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.location = location
        self.activityTypeId = activityTypeId
        self.currentPace = currentPace
    }
    
    convenience required init(platform: String, stepsCount: Int, timeStart: String, timeEnd: String, location: Location, activityTypeId: Int) {
        self.init()
        self.platform = platform
        self.stepsCount = stepsCount
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.location = location
        self.activityTypeId = activityTypeId
    }
    
    convenience required init(platform: String, stepsCount: Int, timeStart: String, timeEnd: String, location: Location) {
        self.init()
        self.platform = platform
        self.stepsCount = stepsCount
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.location = location
    }
}
