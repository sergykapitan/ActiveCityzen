//
//  RedesingWorkoutTypeViewController.swift
//  ActiveCitizen
//
//  Created by Sergey on 10.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Instructions

protocol StopTraningDelegate: class {
    func onButtonTapStop()
}


class RedesingWorkoutTypeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var workoutActivityType: ActivityType?
    private var compositeDisposable = CompositeDisposable()
    let redesingWorkoutView = RedesingWorkoutTypeViewControllerCode()
    let coachMarksController = CoachMarksController()
    
    weak var delegate: StopTraningDelegate?
    
    lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        page.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        page.numberOfPages = 4
        page.backgroundColor = .clear
        page.pageIndicatorTintColor = .white
        page.currentPageIndicatorTintColor = .blue
        return page
    }()
    
    //MARK: - LifeCicle
    override func loadView() {
        super.loadView()
        view = redesingWorkoutView
        view.backgroundColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        createCoachMark()
        redesingWorkoutView.bottomView.buttonStopWorkout.isHidden = true
        redesingWorkoutView.bottomView.stopLabel.isHidden = true

        redesingWorkoutView.bottomView.buttonProceedWorkout.isHidden = true
        redesingWorkoutView.bottomView.proccesedLabel.isHidden = true
        
        guard let workoutType = workoutActivityType else { return  }
        onTypePicked(type: workoutType)
        redesingWorkoutView.bottomView.circleAnimation.angle = 0

    }
    override func viewDidLayoutSubviews() {
        configureButton()
       }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startInstractions()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    private func createCoachMark() {
        self.coachMarksController.delegate = self
        self.coachMarksController.animationDelegate = self
        self.coachMarksController.dataSource = self
        
        coachMarksController.overlay.isUserInteractionEnabled = false
        coachMarksController.overlay.backgroundColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 0.64)
    }

    func configureButton() {
        redesingWorkoutView.bottomView.buttonPauseWorkout.layer.cornerRadius = 0.5 * redesingWorkoutView.bottomView.buttonPauseWorkout.bounds.size.width
        redesingWorkoutView.bottomView.buttonPauseWorkout.clipsToBounds = true
        
        redesingWorkoutView.bottomView.buttonStopWorkout.layer.cornerRadius = 0.5 * redesingWorkoutView.bottomView.buttonStopWorkout.bounds.size.width
        redesingWorkoutView.bottomView.buttonStopWorkout.clipsToBounds = true
        
        redesingWorkoutView.bottomView.buttonProceedWorkout.layer.cornerRadius = 0.5 * redesingWorkoutView.bottomView.buttonProceedWorkout.bounds.size.width
        redesingWorkoutView.bottomView.buttonProceedWorkout.clipsToBounds = true
      
    }
    func actionButton() {
        redesingWorkoutView.bottomView.buttonPauseWorkout.addTarget(self, action: #selector(pauseButton), for: .touchUpInside)
        redesingWorkoutView.bottomView.buttonProceedWorkout.addTarget(self, action: #selector(proceedButton), for: .touchUpInside)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTape))
        longPressRecognizer.minimumPressDuration = 0
        redesingWorkoutView.bottomView.buttonStopWorkout.addGestureRecognizer(longPressRecognizer)
    }

    //MARK: - Animation
    @objc func longTape (_ sender : UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            redesingWorkoutView.bottomView.circleAnimation.animate(toAngle: 360, duration: 2) { (endAnimation) in
                print(endAnimation)
                if endAnimation {
                    self.loadViewNext()
                }
            }
        } else if sender.state == .ended {
            redesingWorkoutView.bottomView.circleAnimation.animate(fromAngle: 1, toAngle: 0, duration: 0.01, completion: nil)
        }
    }
    func loadViewNext() {
        WorkoutService.instance.stopWorkout()
            
        let resultView = ResultWorkoutViewController()
        resultView.activityType = workoutActivityType
        resultView.setUI(typeActivity: redesingWorkoutView.topView.workoutLabel.text ?? "",
                         time: redesingWorkoutView.bottomView.workoutBottomTimerLabel.text ?? "",
                         distance: redesingWorkoutView.bottomView.workoutDistanceChangeLabel.text ?? "",
                         pace: redesingWorkoutView.bottomView.workoutPaceChangeLabel.text ?? "")
        self.compositeDisposable.dispose()
        self.compositeDisposable = CompositeDisposable()
        self.navigationController?.pushViewController(resultView, animated: false)
    }

    @objc func pauseButton(_ sender: UIButton) {
        guard let workout = workoutActivityType else { return }
        redesingWorkoutView.bottomView.buttonProceedWorkout.isHidden = false
        redesingWorkoutView.bottomView.proccesedLabel.isHidden = false
        redesingWorkoutView.bottomView.buttonStopWorkout.isHidden = false
        redesingWorkoutView.bottomView.stopLabel.isHidden = false
        redesingWorkoutView.bottomView.buttonPauseWorkout.isHidden = true
        redesingWorkoutView.bottomView.pauseLabel.isHidden = true
        redesingWorkoutView.topView.workoutTitleLabel.text = "Пауза"
        WorkoutService.instance.pauseWorkout(sender: sender)
     
    }
    @objc func proceedButton(_ sender: UIButton) {
        guard let workout = workoutActivityType else { return }
        redesingWorkoutView.topView.workoutTitleLabel.text = "Тренировка"
        redesingWorkoutView.bottomView.buttonPauseWorkout.isHidden = false
        redesingWorkoutView.bottomView.pauseLabel.isHidden = false
        redesingWorkoutView.bottomView.buttonProceedWorkout.isHidden = true
        redesingWorkoutView.bottomView.proccesedLabel.isHidden = true
        redesingWorkoutView.bottomView.buttonStopWorkout.isHidden = true
        redesingWorkoutView.bottomView.stopLabel.isHidden = true
        WorkoutService.instance.resumeWorkout(sender: sender)
    }
    
    private func resetLabels(type: ActivityType) {
        redesingWorkoutView.bottomView.workoutBottomTimerLabel.text = "00:00"
        redesingWorkoutView.bottomView.workoutDistanceChangeLabel.text = "0,0 км"
        
        switch type {
        case .RUNNING:
            print("RUNNING")
            redesingWorkoutView.bottomView.workoutPaceChangeLabel.text = "0 мин/км"
        case .RUN_IN_PLACE, .WALK_IN_PLACE: do {
            print("RUN_IN_PLACE")
            redesingWorkoutView.bottomView.workoutPaceChangeLabel.isHidden = true
            redesingWorkoutView.bottomView.workoutPaceLabel.isHidden = true
            redesingWorkoutView.bottomView.workoutDistanceLabel.isHidden = true
            redesingWorkoutView.bottomView.workoutDistanceChangeLabel.isHidden = true
        }
        case .ON_BICYCLE:
            redesingWorkoutView.bottomView.workoutPaceLabel.text = "Скорость"
        default:
            print("default")
            redesingWorkoutView.bottomView.workoutPaceChangeLabel.text = "0 мин/км"
        }
    }
    private func updateTimer(timeElapsed: Int) {
        let quotientRemainder = timeElapsed.quotientAndRemainder(dividingBy: 3600)
        var hours = ""
        var minutes = ""
        var seconds = ""
        if quotientRemainder.quotient < 10 {
            hours = "0\(quotientRemainder.quotient)"
        } else { hours = "\(quotientRemainder.quotient)" }
        if quotientRemainder.remainder / 60 < 10 {
            minutes = "0\(quotientRemainder.remainder / 60)"
        } else { minutes = "\(quotientRemainder.remainder / 60)"}
        if quotientRemainder.remainder % 60 < 10 {
            seconds = "0\(quotientRemainder.remainder % 60)"
        } else { seconds = "\(quotientRemainder.remainder % 60)"}
        redesingWorkoutView.bottomView.workoutBottomTimerLabel.text = "\(hours):\(minutes):\(seconds)"
        redesingWorkoutView.topView.workoutTimerLabel.text = "\(hours):\(minutes):\(seconds)"
    }
    
    private func updatePaceSpeed(paceSpeed: Double, type: ActivityType ,stats: WorkoutStats) {
        let steps = stats.workoutSteps
        switch workoutActivityType {
        case .RUNNING:
            print("RUNNING = \(paceSpeed)")
            redesingWorkoutView.bottomView.workoutPaceChangeLabel.text = "\(paceSpeed) мин/км"
        case .RUN_IN_PLACE, .WALK_IN_PLACE:
            print("RUN_IN_PLACE = \(paceSpeed)")
            
            redesingWorkoutView.bottomView.stackHorisontalFirst.widthEqualToMultiplier(inView: redesingWorkoutView.bottomView.cardView, multiplier: 0.5)
            
            redesingWorkoutView.bottomView.stackHorisontalThird.widthEqualToMultiplier(inView: redesingWorkoutView.bottomView.cardView, multiplier: 0.5)
            
            redesingWorkoutView.bottomView.workoutPaceChangeLabel.text = "\(steps ?? 0) "
            redesingWorkoutView.bottomView.workoutPaceLabel.text = "Шаги"
        case .ON_BICYCLE :
            print("ON_BICYCLE = \(paceSpeed)")
            redesingWorkoutView.bottomView.workoutPaceLabel.text = "Скорость"
            redesingWorkoutView.bottomView.workoutPaceChangeLabel.text = "\(paceSpeed) км/ч"
        default:
            print("default")
            redesingWorkoutView.bottomView.workoutPaceChangeLabel.text = "\(paceSpeed) мин/км"
        }
    }
    private func updateDistance(stats: WorkoutStats) {
        let distance = stats.workoutDistance
        
        switch workoutActivityType {
        case .RUNNING:
            print("RUNNING = \(distance)")
            redesingWorkoutView.bottomView.workoutDistanceChangeLabel.text = "\(distance) км"
        case .RUN_IN_PLACE, .WALK_IN_PLACE:
            print("RUN_IN_PLACE = \(distance)")
            redesingWorkoutView.bottomView.workoutDistanceLabel.isHidden = true
            redesingWorkoutView.bottomView.workoutDistanceChangeLabel.isHidden = true
        case .ON_BICYCLE :
            print("ON_BICYCLE = \(distance)")
            redesingWorkoutView.bottomView.workoutDistanceChangeLabel.text = "\(distance) км"
        default:
            print("default")
            redesingWorkoutView.bottomView.workoutDistanceChangeLabel.text = "\(distance) км"
        }
    }
    func startInstractions() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "startTraning")
        if launchedBefore  {
            self.coachMarksController.start(in: .window(over: self))
        } else { }
    }
}
   
extension RedesingWorkoutTypeViewController: WorkoutTypePickerDelegate {
    func onTypePicked(type: ActivityType) {
        workoutActivityType = type
        WorkoutService.instance.initWorkoutWith(activity: type)
        
        
        let observableTimer = WorkoutService.instance.workoutActivityTimeUpdates.subscribe(onNext: { elapsed in
            self.updateTimer(timeElapsed: elapsed)
        }
        )
        
        let activityUpdatesDisposable = WorkoutService.instance.workoutActivityDataUpdates.observeOn(SerialDispatchQueueScheduler.init(qos: .default))
            .observeOn(MainScheduler.asyncInstance)
            .debug()
            .subscribe(onNext: { stats in
                self.updateDistance(stats: stats)
                if !stats.workoutPace.isInfinite && stats.workoutPace < 100 {
                    self.updatePaceSpeed(paceSpeed: stats.workoutPace.rounded(toPlaces: 1), type: type, stats: stats)
                }
            }, onError: { error in
                print(error)
            })
        compositeDisposable.insert(observableTimer)
        compositeDisposable.insert(activityUpdatesDisposable)
    }
  
}
