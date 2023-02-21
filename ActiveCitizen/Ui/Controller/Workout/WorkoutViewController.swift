//
//  WorkoutViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import RxSwift

class WorkoutViewController: UIViewController, WorkoutTypePickerDelegate {
    
    @IBOutlet weak var labelWorkoutTimer: UILabel!
    @IBOutlet weak var labelWorkoutDistance: UILabel!
    @IBOutlet weak var labelWorkoutPaceSpeed: UILabel!
    @IBOutlet weak var imageWorkoutPaceSpeed: UIImageView!
    @IBOutlet weak var labelWorkoutPaceSpeedTitle: UILabel!
    
    @IBOutlet weak var buttonWorkoutStartStop: UIButton!
    
    var workoutActivityType: ActivityType?
    
    private var compositeDisposable = CompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonWorkoutStartStop.addTarget(self, action: #selector(startStopWorkout), for: .touchUpInside)
        
        if let workoutType = workoutActivityType {
            onTypePicked(type: workoutType)
        } else {
            if let workoutType = WorkoutService.instance.getCurrentWorkoutType() {
                self.setWorkoutMiscFor(workoutType: workoutType)
                self.resumeWorkoutSubscriptions(type: workoutType)
            }
        }
    }


    private func resumeWorkoutSubscriptions(type: ActivityType) {
        workoutActivityType = type
        self.buttonWorkoutStartStop.setTitle("Завершить тренировку", for: .normal)
        let activityUpdatesDisposable = WorkoutService.instance.workoutActivityDataUpdates.observeOn(SerialDispatchQueueScheduler.init(qos: .default))
            .observeOn(MainScheduler.asyncInstance).debug()
            .subscribe(onNext: { stats in
                self.updateDistance(stats: stats)
                if !stats.workoutPace.isInfinite {
                    self.updatePaceSpeed(paceSpeed: stats.workoutPace.rounded(toPlaces: 1))
                }
            }, onError: { error in
                print(error)
            })
        compositeDisposable.insert(activityUpdatesDisposable)
        //&& stats.workoutPace < 100 delete because the pace update does not start
        let observableTimer = WorkoutService.instance.workoutActivityTimeUpdates.subscribe(onNext: { elapsed in
            self.updateTimer(timeElapsed: elapsed)
            }
        )
        self.compositeDisposable.insert(observableTimer)
    }
    
    
    @objc func startStopWorkout() {
        
        if WorkoutService.instance.isWorkoutRunning.get() {
            WorkoutService.instance.stopWorkout()
            self.compositeDisposable.dispose()
            self.compositeDisposable = CompositeDisposable()
            self.buttonWorkoutStartStop.setTitle("Начать тренировку", for: .normal)
        } else {
            let workoutTypeViewController = WorkoutTypeModalViewController()
            workoutTypeViewController.workoutTypePickerDelegate = self
            workoutTypeViewController.modalPresentationStyle = .overCurrentContext
            workoutTypeViewController.modalTransitionStyle = .crossDissolve
            self.present(workoutTypeViewController, animated: true, completion: nil)
        }
    }
    
    func onTypePicked(type: ActivityType) {
        
         workoutActivityType = type
        self.resetLabels(type: type)
        
        self.buttonWorkoutStartStop.setTitle("Завершить тренировку", for: .normal)
        WorkoutService.instance.initWorkoutWith(activity: type)
        
        self.labelWorkoutPaceSpeedTitle.text = "Темп"
      //  self.labelWorkoutPaceSpeed.text = "0 мин/км"
        
        self.setWorkoutMiscFor(workoutType: type)
        let observableTimer = WorkoutService.instance.workoutActivityTimeUpdates.subscribe(onNext: { elapsed in
            self.updateTimer(timeElapsed: elapsed)
        }
        )
        self.compositeDisposable.insert(observableTimer)
        
        let activityUpdatesDisposable = WorkoutService.instance.workoutActivityDataUpdates.observeOn(SerialDispatchQueueScheduler.init(qos: .default))
            .observeOn(MainScheduler.asyncInstance).debug()
            .subscribe(onNext: { stats in
                self.updateDistance(stats: stats)
                if !stats.workoutPace.isInfinite {
                    self.updatePaceSpeed(paceSpeed: stats.workoutPace.rounded(toPlaces: 1))
                }
            }, onError: { error in
                print(error)
            })
        compositeDisposable.insert(activityUpdatesDisposable)
    }
    //&& stats.workoutPace < 100 delete because the pace update does not start
    private func setWorkoutMiscFor(workoutType: ActivityType) {
        switch workoutType {
        case .RUNNING: do {
            self.imageWorkoutPaceSpeed.image = UIImage(named: "iconRunningMan")
        }
        case .WALKING: do {
            self.imageWorkoutPaceSpeed.image = UIImage(named: "iconWorkoutWalking")
        }
        case .SKI: do {
            self.imageWorkoutPaceSpeed.image = UIImage(named: "iconWorkoutSkiing")
        }
        case .SKATES: do {
            self.imageWorkoutPaceSpeed.image = UIImage(named: "iconWorkoutWinterSkating")
        }
        case .ON_BICYCLE: do {
            self.labelWorkoutPaceSpeedTitle.text = "Скорость"
            self.labelWorkoutPaceSpeed.text = "0 км/ч"
            self.imageWorkoutPaceSpeed.image = UIImage(named: "iconBicycleDriver")
        }
        case .WALK_IN_PLACE: do {
            self.labelWorkoutDistance.text = "–"
            self.labelWorkoutPaceSpeed.text = "–"
            self.imageWorkoutPaceSpeed.image = UIImage(named: "iconWorkoutHomeWalking")
        }
        
        case .RUN_IN_PLACE: do {
            self.labelWorkoutDistance.text = "–"
            self.labelWorkoutPaceSpeed.text = "–"
            self.imageWorkoutPaceSpeed.image = UIImage(named: "iconWorkoutHomeRunning")
        }
        default:
            print("Unsupported workout type")
        }
    }
    
    private func resetLabels(type: ActivityType) {
        self.labelWorkoutTimer.text = "00:00"
        self.labelWorkoutDistance.text = "0,0 км"
        
        switch type {
        case .RUNNING:
            self.labelWorkoutPaceSpeed.text = "0 мин/км"
        case .RUN_IN_PLACE, .WALK_IN_PLACE: do {
            self.labelWorkoutDistance.text = "–"
            self.labelWorkoutPaceSpeed.text = "–"
        }
        default:
            self.labelWorkoutPaceSpeed.text = "0 мин/км"
        }
    }
    
    private func updateTimer(timeElapsed: Int) {
        let quotientRemainder = timeElapsed.quotientAndRemainder(dividingBy: 60)
        var minutes = ""
        var seconds = ""
        
        if quotientRemainder.quotient < 10 {
            minutes = "0\(quotientRemainder.quotient)"
        } else {  minutes = "\(quotientRemainder.quotient)" }
        if quotientRemainder.remainder < 10 {
            seconds = "0\(quotientRemainder.remainder)"
        } else {
            seconds = "\(quotientRemainder.remainder)"
        }
        
        self.labelWorkoutTimer.text = "\(minutes):\(seconds)"
    }
    
    private func updateDistance(stats: WorkoutStats) {
        let distance = stats.workoutDistance
        
        switch workoutActivityType {
        case .RUNNING:
            self.labelWorkoutDistance.text = "\(distance) км"
        case .RUN_IN_PLACE, .WALK_IN_PLACE:
            self.labelWorkoutDistance.text = "–"
        case .ON_BICYCLE :
            self.labelWorkoutDistance.text = "\(distance) км"
        default:
            self.labelWorkoutDistance.text = "\(distance) км"
        }

    }
    
    
    private func updatePaceSpeed(paceSpeed: Double) {
        switch workoutActivityType {
        case .RUNNING:
            self.labelWorkoutPaceSpeed.text = "\(paceSpeed) мин/км"
        case .RUN_IN_PLACE, .WALK_IN_PLACE:
            self.labelWorkoutPaceSpeed.text = "–"
        case .ON_BICYCLE :
            self.labelWorkoutPaceSpeed.text = "\(paceSpeed) км/ч"
        default:
            self.labelWorkoutPaceSpeed.text = "\(paceSpeed) мин/км"
        }
    }
}

