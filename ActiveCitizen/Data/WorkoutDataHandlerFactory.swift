//
//  WorkoutDataHandlerFactory.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.12.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//
import RxSwift
import RxSwiftExt
import HealthKit
import CoreLocation
import CoreMotion

class WorkoutDataHandlerFactory {
    
    @Inject var healthProvider: HealthProvider
    @Inject var motionProvider: MotionProvider
    
    private var lastAction: Action?
    
    func getWorkoutDataHandler(activityType: ActivityType) -> Observable<Action> {
        switch activityType {
        
        case .WALKING, .RUNNING: do {
            let locationObservable = LocationProvider.instance.getContinuousLocationUpdates()
                .map({ (clLocation) -> Location in
                Location(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)
            })
            
            let actionsObservable = motionProvider.getPedometer()
                .bufferWithTrigger(locationObservable)
                .zip(with: locationObservable, resultSelector: { (pedometerData: [CMPedometerData], location) -> ([CMPedometerData], Location) in
                    return (pedometerData, location)
                })
                .filter({ (pedometerDataArray, location) -> Bool in
                    !pedometerDataArray.isEmpty
                })
                .map({(pedometerDataArray, location) -> Action in
                    guard let lastAction = self.lastAction else {
                        // Should never happen
                        self.lastAction = Action()
                        return self.lastAction!
                    }
                    
                    let currentDate = Date()
                    let currentStepsCount = pedometerDataArray.sumBy(selector: { pedometerData -> Int in pedometerData.numberOfSteps.intValue})
                    let distanceBetweenLocations = lastAction.location!.computeDistanceTo(location2: location) / 1000 // Kilometers
                    let distanceBetweenLocationsMeters = lastAction.location!.computeDistanceTo(location2: location)
                    let actionDuration = (currentDate.timeIntervalSince(lastAction.timeEnd.iso8601!)) / 60 // Minutes
                    
                    var pace = 0.0
                    if distanceBetweenLocations == 0.0 {
                        pace = lastAction.currentPace
                    } else {
                        pace = actionDuration / distanceBetweenLocations
                    }
                    let action = Action(
                        timeStart: lastAction.timeEnd,
                        timeEnd: currentDate.iso8601,
                        location: location, activityTypeId: ActivityType.PENDING.rawValue)
                    action.currentPace = pace
                    action.stepsCount = currentStepsCount
                    action.distance = Int(distanceBetweenLocationsMeters)
                    
                    if !pedometerDataArray.isEmpty {
                        if pace.isInfinite {
                            action.activityTypeId = ActivityType.UNKNOWN.rawValue
                            pace = 0.0
                        }
                        else if  3...9 ~= pace {
                            action.activityTypeId = activityType.rawValue
                        }
                        else if 0...3 ~= pace {
                            action.activityTypeId = ActivityType.IN_VEHICLE.rawValue
                        }
                        else if pace > 9 {
                            action.activityTypeId = ActivityType.WALKING.rawValue // WALKING
                        }
                        else {
                            action.activityTypeId = ActivityType.UNKNOWN.rawValue
                        }}
                    self.lastAction = action
                    return action
                })
            
            return LocationProvider.instance.getCurrentLocationSingle()
                .map({ (clLocation) -> Location in
                    Location(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)
                })
                .flatMap { startingLocation -> Observable<Action> in
                    let timeWorkoutLaunch = Date().iso8601
                    self.lastAction = Action(platform: "appleHealth", stepsCount: 0, timeStart: timeWorkoutLaunch, timeEnd: timeWorkoutLaunch, location: startingLocation, activityTypeId: ActivityType.PENDING.rawValue)
                    return actionsObservable
                }
        }
        
        case .SKATES, .SKI: do {
            let locationObservable = LocationProvider.instance.getContinuousLocationUpdates().map({ (clLocation) -> Location in
                Location(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)
            })
            
            let actionsObservable = motionProvider.getPedometer()
                .bufferWithTrigger(locationObservable)
                .zip(with: locationObservable, resultSelector: { (pedometerData: [CMPedometerData], location) -> ([CMPedometerData], Location) in
                    return (pedometerData, location)
                })
                .filter({ (pedometerDataArray, location) -> Bool in
                    !pedometerDataArray.isEmpty
                })
                .map({(pedometerDataArray, location) -> Action in
                    guard let lastAction = self.lastAction else {
                        // Should never happen
                        self.lastAction = Action()
                        return self.lastAction!
                    }
                    
                    let currentDate = Date()
                    let currentStepsCount = pedometerDataArray.sumBy(selector: { pedometerData -> Int in pedometerData.numberOfSteps.intValue})
                    let distanceBetweenLocations = lastAction.location!.computeDistanceTo(location2: location) / 1000 // Kilometers
                    let distanceBetweenLocationsMeters = lastAction.location!.computeDistanceTo(location2: location)
                    let actionDuration = (currentDate.timeIntervalSince(lastAction.timeEnd.iso8601!)) / 60 // Minutes
                    
                    var pace = 0.0
                    if distanceBetweenLocations == 0.0 {
                        pace = lastAction.currentPace
                    } else {
                        pace = actionDuration / distanceBetweenLocations
                    }
                    
                    let action = Action(
                        timeStart: lastAction.timeEnd,
                        timeEnd: currentDate.iso8601,
                        location: location, activityTypeId: ActivityType.PENDING.rawValue)
                    action.currentPace = pace
                    action.stepsCount = currentStepsCount
                    action.distance = Int(distanceBetweenLocationsMeters)
                    if !pedometerDataArray.isEmpty {
                        if pace.isInfinite {
                            action.activityTypeId = ActivityType.UNKNOWN.rawValue
                            pace = 0.0
                        }
                       
                        else if 0...3 ~= pace {
                            action.activityTypeId = ActivityType.IN_VEHICLE.rawValue
                        }
                        else if pace > 3 {
                            action.activityTypeId = activityType.rawValue
                        }
                        
                        else {
                            action.activityTypeId = ActivityType.UNKNOWN.rawValue
                        }}
                    self.lastAction = action
                    return action
                })
            
            return LocationProvider.instance.getCurrentLocationSingle()
                .map({ (clLocation) -> Location in
                    Location(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)
                })
                .flatMap { startingLocation -> Observable<Action> in
                    let timeWorkoutLaunch = Date().iso8601
                    self.lastAction = Action(platform: "appleHealth", stepsCount: 0, timeStart: timeWorkoutLaunch, timeEnd: timeWorkoutLaunch, location: startingLocation, activityTypeId: ActivityType.PENDING.rawValue)
                    return actionsObservable
                }
        }
        
        case .ON_BICYCLE: do {
            let locationObservable = LocationProvider.instance.getContinuousLocationUpdates().map({ (clLocation) -> Location in
                Location(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)
            })
            
            let motionContinuousLocationDisposable =  motionProvider.getPedometer()
                .bufferWithTrigger(locationObservable).zip(with: locationObservable, resultSelector: { (pedometerData: [CMPedometerData], location) -> ([CMPedometerData], Location) in
                    return (pedometerData, location)
                }).filter({ (pedometerDataArray, location) -> Bool in
                    !pedometerDataArray.isEmpty
                })
                .map({ (pedometerDataArray, location) -> Action in
                    guard let lastAction = self.lastAction else {
                        // Should never happen
                        self.lastAction = Action()
                        return self.lastAction!
                    }
                    
                    let currentDate = Date()
                    let distanceBetweenLocations = lastAction.location!.computeDistanceTo(location2: location) / 1000 // Kilometers
                    let distanceBetweenLocationsMeters = lastAction.location!.computeDistanceTo(location2: location)
                    let actionDuration = currentDate.timeIntervalSince(lastAction.timeStart.iso8601!) / 3600 // Hours
                    let currentStepsCount = pedometerDataArray.sumBy(selector: { pedometerData -> Int in pedometerData.numberOfSteps.intValue})
                    
                    var speed = 0.0
                    
                    if distanceBetweenLocations == 0.0 {
                        speed = lastAction.currentPace
                    } else {
                        speed = distanceBetweenLocations / actionDuration
                    }
                    
                    
                    let action = Action(
                        timeStart: lastAction.timeEnd,
                        timeEnd: currentDate.iso8601,
                        location: location, activityTypeId: ActivityType.PENDING.rawValue)
                    action.currentPace = speed
                    action.stepsCount = currentStepsCount
                    action.distance = Int(distanceBetweenLocationsMeters)
                    action.timeEnd = currentDate.iso8601
                    action.stepsCount = pedometerDataArray.sumBy(selector: { pedometerData -> Int in
                        pedometerData.numberOfSteps.intValue
                    })

                    if speed.isInfinite {
                        action.activityTypeId = ActivityType.UNKNOWN.rawValue
                        speed = 0.0
                    }
                                        
                    else if  0 ..< 5 ~= speed {
                        action.activityTypeId = ActivityType.WALKING.rawValue 
                    }
                    else if 5...30 ~= speed {
                        action.activityTypeId = ActivityType.ON_BICYCLE.rawValue
                    }
                    else if speed > 30 {
                        action.activityTypeId = ActivityType.IN_VEHICLE.rawValue
                    }
                    else {
                        action.activityTypeId = ActivityType.UNKNOWN.rawValue
                    }
                    
                    self.lastAction = action
                    return action 
                })
            return LocationProvider.instance.getCurrentLocationSingle().map({ (clLocation) -> Location in
                Location(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)
            })
            .flatMap { startingLocation -> Observable<Action> in
                let timeWorkoutLaunch = Date().iso8601
                self.lastAction = Action(platform: "appleHealth", stepsCount: 0, timeStart: timeWorkoutLaunch, timeEnd: timeWorkoutLaunch, location: startingLocation, activityTypeId: ActivityType.PENDING.rawValue)
                return motionContinuousLocationDisposable
            }
        }
        
        case .RUN_IN_PLACE, .WALK_IN_PLACE: do {
            
            let locationObservableq = LocationProvider.instance.getContinuousLocationUpdates()
                .map({ (clLocation) -> Location in
                Location(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)
            })
          
            
            //   Old location stop in block Screen
            
             let locationObservable = LocationProvider.instance.getCurrentLocationSingle()
                .map({ (clLocation) -> Location in
                Location(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)
              })
            
            return Observable.combineLatest(locationObservable, self.motionProvider.getPedometer())
                .map {  location, pedometerData -> Action in
  
                    let currentDate = Date()
                    let currentDateEnd = Date().addingTimeInterval(3)
                    print("currentDate = \(currentDate)\n\ncurrentDateEnd = \(currentDateEnd)")
                    
                    let action = Action( platform: "appleHealth", stepsCount: 0,
                                         timeStart: currentDate.iso8601,
                                         timeEnd: currentDateEnd.iso8601,
                                         location: location, activityTypeId: activityType.rawValue)
    
                    action.stepsCount = pedometerData.numberOfSteps.intValue
                    
                    self.lastAction = action
                    return action
                }
        }
        
        default:
            return Observable.just(Action.init(timeStart: "", timeEnd: "", location: Location.nullIsland , activityTypeId: ActivityType.UNKNOWN.rawValue))
        }
    }
}
