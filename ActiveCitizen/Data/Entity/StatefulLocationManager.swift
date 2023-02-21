//
//  StatefulLocationManager.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 18.11.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import CoreLocation
import RxSwift

class StatefulLocationManager: CLLocationManager {
    
    var isUpdatingLocation = AtomicBoolean()
    
    override init() {
        super.init()
        isUpdatingLocation.getAndSet(value: false)
    }
    
    override func startUpdatingLocation() {
        super.startUpdatingLocation()
        isUpdatingLocation.getAndSet(value: true)

    }
    
    override func stopUpdatingLocation() {
        super.stopUpdatingLocation()
        isUpdatingLocation.getAndSet(value: false)

    }
    
    
}
