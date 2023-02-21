//
//  WorkoutService.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 08.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Realm
import RealmSwift
import RxSwift
import RxSwiftExt
import CoreMotion
import RxCocoa
//TODO: Refactor according to SOLID
class WorkoutService {
    
    @Inject var healthProvider: HealthProvider
    @Inject var motionProvider: MotionProvider
    @Inject var citizenApi: CitizenAPI
    @Inject var workoutDataHandlerFactory: WorkoutDataHandlerFactory
    
    var isWorkoutRunning = AtomicBoolean()
    static var instance = WorkoutService()
    private init(){}
    
    private let workoutDao = RealmDao<Workout>()
    var disposeBagLet: DisposeBag?
    
    var workoutActivityDataUpdates: BehaviorSubject<WorkoutStats> = BehaviorSubject<WorkoutStats>(value: WorkoutStats(workoutDistance: 0.0, workoutPace: 0.0, workoutSpeed: 0.0,workoutSteps: 0))
    
    var workoutActivityTimeUpdates: BehaviorSubject<Int> = BehaviorSubject<Int>(value: 0)

    var isStart =  BehaviorRelay<Bool>(value: true)
    private var compositeDisposable = CompositeDisposable()
    
    private var workout: Workout?
    var timerDisposable: Disposable?
    
    func getCurrentWorkoutType() -> ActivityType? {
        return workout?.activityType
    }
    
    func getRecentWorkout() {
        guard let pendingWorkout = self.workoutDao.getAllFiltered(filter: "isFinished == false").last else { return }
        print("pendingWorkout = \(pendingWorkout)")
        self.workout = pendingWorkout
    }
    
    func initWorkoutWith(activity type: ActivityType) {
        let workout = Workout.init(startTime: Date().iso8601)
        workout.activityType = type
        self.workout = workout        
        startWorkout()
    }
    
    func getCurrentWorkoutDistance() -> Double? {
        guard let workout = workout else { return nil }
        let locations = workout.activities.filter({ action -> Bool in
            action.location != nil
        }).map { (action) -> Location in
            return action.location!
        }
        return (calculatePathDistance(locations: locations) / 1000).rounded(toPlaces: 1)
    }
    
    
    func getCountSteps() -> Int? {
        guard let workout = workout else { return nil }
        let steps = workout.activities.filter ({ action -> Bool in
            !action.currentPace.isInfinite
        }).map { (action) -> Int in
            return action.stepsCount
        }.reduce(0) { $0 + $1 }
        return steps
    }
 
    private func startWorkout() {
        guard let workout = workout else { return }
        self.isWorkoutRunning.getAndSet(value: true)
        disposeBagLet = DisposeBag()
        self.isStart.accept(true)
        isStart.asObservable()
                   .flatMapLatest {  isStart in
                    isStart ? self.workoutDataHandlerFactory.getWorkoutDataHandler(activityType: workout.activityType) : .empty()
                   }
                   .observeOn(MainScheduler.asyncInstance)
                   .subscribe(onNext: { result in
                    self.workout?.activities.append(result)
                    self.workoutActivityDataUpdates.onNext(WorkoutStats(workoutDistance: self.getCurrentWorkoutDistance() ?? 0.0, workoutPace: result.currentPace,workoutSteps: self.getCountSteps()))
                }, onError: { error in
                    print(error.localizedDescription)
                })
            .disposed(by: disposeBagLet!)
        
//        let workoutDataObservable = workoutDataHandlerFactory.getWorkoutDataHandler(activityType: workout.activityType)
//            .observeOn(MainScheduler.asyncInstance)
//            .subscribe(
//                onNext: { result in
//                    self.workout?.activities.append(result)
//                    self.workoutActivityDataUpdates.onNext(WorkoutStats(workoutDistance: self.getCurrentWorkoutDistance() ?? 0.0, workoutPace: result.currentPace))
//                }, onError: { error in
//                    print(error.localizedDescription)
//                }
//           )
        //Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
       // timerDisposable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) as! Disposable
        
        isStart.asObservable()
                   .flatMapLatest {  isStart in
                    isStart ? Observable<Int>.interval(.seconds(1), scheduler: SerialDispatchQueueScheduler.init(qos: .default)) : .empty()
                   }
                   .flatMapWithIndex { (int, index) in Observable.just(index) }
                   .observeOn(MainScheduler.asyncInstance)
                   .subscribe(onNext:{ (elapsed) in
                    self.workoutActivityTimeUpdates.onNext(elapsed)
                }, onError: { error in
                    print(error)
                })
            .disposed(by: disposeBagLet!)

 
//        let observableTimer = Observable<Int>.interval(.seconds(1), scheduler: SerialDispatchQueueScheduler.init(qos: .default))
//            .observeOn(MainScheduler.asyncInstance)
//            .subscribe (onNext:{ (elapsed) in
//                self.workoutActivityTimeUpdates.onNext(elapsed)
//            }, onError: { error in
//                print(error)
//            })
//        compositeDisposable.insert(observableTimer)
 //       compositeDisposable.insert(workoutDataObservable)
    }
    
    func resumeWorkout(sender: UIButton) {
        self.isWorkoutRunning.getAndSet(value: true)
        self.isStart.accept(true)
    }
    
    func pauseWorkout(sender: UIButton) {
        LocationProvider.instance.stopContinuousLocationUpdates()
        self.isWorkoutRunning.getAndSet(value: false)
        self.isStart.accept(false)
    }
    
    func stopWorkout() {
        guard let workout = workout, !workout.activities.isEmpty else {
            self.isWorkoutRunning.getAndSet(value: false)
            self.workout = nil
            LocationProvider.instance.stopContinuousLocationUpdates()
            self.compositeDisposable.dispose()
            self.compositeDisposable = CompositeDisposable()
            return
        }
        
       self.citizenApi.uploadWorkout(workout: workout).subscribe(onNext: {
           self.isWorkoutRunning.getAndSet(value: false)
            LocationProvider.instance.stopContinuousLocationUpdates()
            print("Workout has been uploaded successfully")
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: Constants.dateLastActivityUploadUserDefaults)
            self.workoutActivityTimeUpdates = BehaviorSubject<Int>(value: 0)
            self.workoutActivityDataUpdates = BehaviorSubject<WorkoutStats>(value: WorkoutStats(workoutDistance: 0.0, workoutPace: 0.0, workoutSpeed: 0.0))
            self.disposeBagLet = nil
            self.compositeDisposable.dispose()
            self.compositeDisposable = CompositeDisposable()
            self.workout = nil
        }, onError: {   error in
            print(error)
            LocationProvider.instance.stopContinuousLocationUpdates()
        })
    }
    
    deinit {
        print("deinit")
        self.isWorkoutRunning.getAndSet(value: false)
        LocationProvider.instance.stopContinuousLocationUpdates()
    }
}
