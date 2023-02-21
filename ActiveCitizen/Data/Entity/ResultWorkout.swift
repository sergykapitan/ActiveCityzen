//
//  ResultWorkout.swift
//  ActiveCitizen
//
//  Created by Sergey on 17.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation
import RealmSwift
 
class ResultWorkout: Object {
    @objc dynamic var time = ""
    @objc dynamic var distance = ""
    @objc dynamic var pace = ""
    @objc dynamic var typeWorkout = ""
    @objc dynamic var imageName = ""
    @objc dynamic var created = NSDate()
}
