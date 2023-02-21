//
//  PhysicalActivityService.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 13.01.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation
import Realm
import RealmSwift

class PhysicalActivityService {
    @Inject private var citizenApi: CitizenAPI
    @Inject private var motionProvider: MotionProvider

    lazy var healthProvider = HealthProvider()
    
    let realm = try! Realm(configuration: Realm.Configuration(schemaVersion: Constants.workoutRealmDatabaseSchemaVersion))
    
    private let disposeBag = DisposeBag()
    
    func uploadLatestActivities(completion: @escaping (Bool)-> ()) {
        let lastDateTimeUpload = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: Constants.dateLastActivityUploadUserDefaults))
        let currentDateTime = Date()
        
        if lastDateTimeUpload.timeIntervalSince1970 != 0 && (lastDateTimeUpload.addingTimeInterval(300)) <= currentDateTime && !WorkoutService.instance.isWorkoutRunning.get() {
            let stepsCountObservable = healthProvider.getStepCountSegmentedByDayObservable(from: lastDateTimeUpload, to: currentDateTime)
            let locationObservable = LocationProvider.instance.getCurrentLocationSingle().map({ (coreLocation: CLLocation) -> Location in
                return Location.init(latitude: coreLocation.coordinate.latitude, longitude: coreLocation.coordinate.longitude)
            })
            Observable.combineLatest( locationObservable, stepsCountObservable).map { (location, activities) -> Array<Action> in
                return activities.map { (timeStart, timeEnd, stepsCount) -> Action in
                   let action = Action.init(timeStart: timeStart.iso8601, timeEnd: timeEnd.iso8601, stepsCount: Int(stepsCount), activityTypeId: ActivityType.WALKING.rawValue)
                    action.location = location
                    return action
                }
            }.map { actions -> ActivitiesIntersections in
                return ActivitiesIntersections.init(activities: actions, intersections: [Intersection(location: actions.first?.location ?? Location.nullIsland, status: "exit", timeStart: lastDateTimeUpload.iso8601, timeEnd: currentDateTime.iso8601)])
            }.flatMap { (activitiesIntersections) -> Completable in
                return self.citizenApi.uploadActionsIntersections(activitiesIntersections:
                                                                    activitiesIntersections)
            }
            .subscribe(onError: {   error in
                completion(false)
            }, onCompleted: {
                UserDefaults.standard.set(currentDateTime.timeIntervalSince1970, forKey: Constants.dateLastActivityUploadUserDefaults)
                completion(true)
            }).disposed(by: self.disposeBag)
        }
        else if lastDateTimeUpload.timeIntervalSince1970 == 0 {
            UserDefaults.standard.set(currentDateTime.timeIntervalSince1970, forKey: Constants.dateLastActivityUploadUserDefaults)
            completion(false)
        } else {
            completion(false)
        }
    }
    
    func uploadActivitiesIntersections(activities: Array<Action>, intersection:  ThreadSafeReference<Intersection>) {
        DispatchQueue.main.async {
            guard let intersection = self.realm.resolve(intersection) else { return }
            self.citizenApi.uploadActionsIntersections(activitiesIntersections: ActivitiesIntersections.init(activities: activities, intersections: [intersection]))
                .subscribe(onCompleted: {
                            print("actions with intersections uploaded successfully")},
                           onError: {   error in
                            print(error)
                           }
                )}
    }
    deinit {
        print("PhysicalActivityService is being deinitialized")
    }
}
