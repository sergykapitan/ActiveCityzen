//
//  ActionsIntersections.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 23.07.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
 
struct ActivitiesIntersections: Codable {
    var activities: Array<Action> = []
    var intersections: Array<Intersection> = []
}
