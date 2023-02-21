//
//  LocationProvider.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 10.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RealmSwift
import SwiftLocation
import Network

class LocationProvider {
    
    static let instance = LocationProvider()
    private init() {}
    private let locationsSubject: PublishSubject<CLLocation> = PublishSubject()
    private let singleLocationSubject: PublishSubject<CLLocation> = PublishSubject()
    
    private var singleLocationRequest: GPSLocationRequest?
    private var continuousLocationRequest: GPSLocationRequest?
    
    private func startContinuousLocationUpdates() {
        
    SwiftLocation.requestAuthorization(.plist) { newStatus in
        self.continuousLocationRequest = SwiftLocation.gpsLocationWith {
   
                if Connectivity.isCellular {
                    print("cellular")
                    $0.subscription = .continous
                    $0.accuracy = .custom(1500)
                    $0.minTimeInterval = 15
                    $0.activityType = .fitness
                    $0.precise = .fullAccuracy
                    
                }
                if Connectivity.isWiFi {
                    print("wifi")
                    $0.subscription = .continous
                    $0.accuracy = .custom(100)
                    $0.activityType = .fitness
                    $0.precise = .fullAccuracy
                }
            }
        }
        continuousLocationRequest?.then { result in // you can attach one or more subscriptions via `then`.
            switch result {
            case .success(let newData):
                self.locationsSubject.onNext(newData)
            
            case .failure(let error):
                print("An error has occurred: \(error.localizedDescription)")
               
            }
        }
    }
    
    func getContinuousLocationUpdates()-> Observable<CLLocation> {
        startContinuousLocationUpdates()
        return self.locationsSubject.map({ ( clLocation) -> CLLocation in
            return clLocation
        }).debug("locationsSubject")
    }    
    func getCurrentLocationSingle()-> Observable<CLLocation> {
        SwiftLocation.requestAuthorization(.plist) { newStatus in
            if newStatus == .authorizedAlways || newStatus == .authorizedWhenInUse {
                self.singleLocationRequest = SwiftLocation.gpsLocationWith { options in
                    if SwiftLocation.preciseAccuracy == .fullAccuracy {
                        options.subscription = .single
                        options.activityType = .other
                        options.accuracy = .custom(2500)
                        options.precise = .fullAccuracy
                        options.avoidRequestAuthorization = true
                    }
                }
            }
        }
  
        singleLocationRequest?.then { result in
            switch result {
            case .success(let location): do {
                self.singleLocationSubject.onNext(location)
            }
            case .failure(let error): do {
                self.singleLocationSubject.onError(error)
                
              }
           }
        }
        return singleLocationSubject.take(1).do(afterCompleted: {
            self.stopSingleLocationUpdates()
        }).debug("singleLocationSubject")
    }

    private func stopSingleLocationUpdates() {
        singleLocationRequest?.cancelRequest()
        singleLocationRequest = nil
    }
    
    func stopContinuousLocationUpdates() {
        continuousLocationRequest?.cancelRequest()
        continuousLocationRequest = nil
    }

}
