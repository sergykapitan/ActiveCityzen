//
//  ActivityType.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 11.06.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import CoreMotion

enum ActivityType: Int {
    case WALKING = 1,
         RUNNING = 2,
         ON_BICYCLE = 3,
         IN_VEHICLE = 4,
         STILL = 5,
         ON_FOOT = 6,
         UNKNOWN = 7,
         SWIMMING = 8,
         SKATES = 9,
         SKI = 10,
         WALK_IN_PLACE = 11,
         RUN_IN_PLACE = 12,
         PENDING = -1,
         PAUSED = -2
}
