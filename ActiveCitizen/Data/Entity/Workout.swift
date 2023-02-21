//
//  Workout.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 08.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import RealmSwift

class Workout: Object, Codable {
    @objc dynamic var startTime: String = ""
    @objc dynamic var endTime: String?
    dynamic var activities: [Action] = [Action]()
    @objc dynamic var isFinished: Bool = false
    dynamic var activityType: ActivityType = .PENDING
    
    var workout: String = "workout"
    
    convenience init(startTime: String) {
        self.init()
        self.startTime = startTime
    }
    
    convenience required init(startTime: String, endTime: String, actions: [Action], isFinished: Bool) {
        self.init()
        self.startTime = startTime
        self.endTime = endTime
        self.activities = actions
        self.isFinished = isFinished
    }
    
    private enum CodingKeys: String, CodingKey {
        case activities = "activities", workout
    }
}
