//
//  RedesingWorkoutViewController.swift
//  ActiveCitizen
//
//  Created by Sergey on 10.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftLocation
import Instructions

class RedesingWorkoutViewController: UIViewController {

    let redesingView = RedesingWorkoutViewControllerCode()
    var activityType: ActivityType?
    let coachMarksController = CoachMarksController()
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
        view = redesingView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        createNavBar()
        actionStartButton()
        activityType = .WALKING
        redesingView.workoutView.setUI(image: "iconWorkoutWalking", text: "Ходьба")
        view.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
        createCouchMark()
        WorkoutTypeRepo.shared.timerMounts()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startInstractions()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Metods
    private func createNavBar() {        
        let closeController = UIBarButtonItem(image: #imageLiteral(resourceName: "iconCrossGray"), style: .plain, target: self, action: #selector(dissmissController))
        navigationItem.leftBarButtonItem = closeController
        navigationItem.title = "Тренировка"
    }
    private func createCouchMark() {
        self.coachMarksController.delegate = self
        self.coachMarksController.animationDelegate = self
        self.coachMarksController.dataSource = self
        
        coachMarksController.overlay.isUserInteractionEnabled = false
        coachMarksController.overlay.backgroundColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 0.64)
        
        let skipView = CoachMarkSkipDefaultView()
        skipView.isStyledByInstructions = false
        skipView.setTitle("Пропустить", for: .normal)
        skipView.setTitleColor(UIColor.white, for: .normal)
        skipView.setBackgroundImage(nil, for: .normal)
        skipView.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        skipView.titleLabel?.textAlignment = .right
        skipView.setBackgroundImage(nil, for: .highlighted)
        skipView.layer.cornerRadius = 0
        skipView.backgroundColor = .clear
        self.coachMarksController.skipView = skipView
       
    }
    private func actionStartButton() {
        redesingView.butttonStartWorkout.addTarget(self, action: #selector(presentWorkoutController), for: .touchUpInside)
        redesingView.workoutView.changeWorkoutButton.addTarget(self, action: #selector(openModalWorkoutViewController), for: .touchUpInside)
    }
   
    // MARK: - Selectors
    @objc func openModalWorkoutViewController() {
        let workoutTypeViewController = RedesingModalTypeViewController()
        workoutTypeViewController.workoutTypePickerDelegate = self
        workoutTypeViewController.modalPresentationStyle = .overCurrentContext
        workoutTypeViewController.modalTransitionStyle = .crossDissolve
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.present(workoutTypeViewController, animated: true, completion: nil)
    }
    @objc func dissmissController() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func presentWorkoutController() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied: do {
                displayGpsError()
            }
            case .authorizedAlways, .authorizedWhenInUse: do {
                
                if SwiftLocation.preciseAccuracy == .fullAccuracy {
        
                let redesingWorkout = RedesingWorkoutTypeViewController()
                redesingWorkout.modalPresentationStyle = .fullScreen
                redesingWorkout.workoutActivityType = activityType
                redesingWorkout.redesingWorkoutView.topView.workoutLabel.text = redesingView.workoutView.workoutLabel.text
                self.navigationController?.pushViewController(redesingWorkout, animated: true)
                } else {
                  displayGpsAccuracyError()
                }
            }
            @unknown default:
                break
            }

        } else {
            displayGpsError()
        }
    }
    private func displayGpsError() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let enableGeolocationHintController = ResultModalViewController()
        enableGeolocationHintController.resultTitle = "Не работает GPS"
        enableGeolocationHintController.resultDescription = "В телефоне выключена функция геолокации, поэтому данные о тренировке будут засчитаны не точно"
        enableGeolocationHintController.imageName = "iconLocationMdRes"
        enableGeolocationHintController.modalTransitionStyle = .crossDissolve
        enableGeolocationHintController.modalPresentationStyle = .currentContext
        enableGeolocationHintController.resultBottomButtonTitle = "Перейти в настройки"
        enableGeolocationHintController.view.backgroundColor = .init(white: 1.0, alpha: 0.5)
        enableGeolocationHintController.onDismiss = {
            if let appSettings = URL(string: UIApplication.openSettingsURLString  ) {                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        self.present(enableGeolocationHintController, animated: true, completion: nil)
    }
    private func displayGpsAccuracyError() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let enableGeolocationHintController = ResultModalViewController()
        enableGeolocationHintController.imageName = "iconCrossFailure"
        enableGeolocationHintController.resultTitle = "Не включенно точное определение GPS"
        enableGeolocationHintController.resultDescription = "В телефоне выключена функция точного определения геолокации, поэтому данные о тренировке будут засчитаны не точно"
        enableGeolocationHintController.modalPresentationStyle = .fullScreen
        enableGeolocationHintController.modalTransitionStyle = .crossDissolve
        enableGeolocationHintController.modalPresentationStyle = .currentContext
        enableGeolocationHintController.resultBottomButtonTitle = "Перейти в настройки"
        enableGeolocationHintController.view.backgroundColor = .init(white: 1.0, alpha: 0.5)
        enableGeolocationHintController.onDismiss = {
            if let appSettings = URL(string: UIApplication.openSettingsURLString  ) {                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        self.present(enableGeolocationHintController, animated: true, completion: nil)
    }
    func presentWorkoutForTheInstraction(){
        let redesingWorkout = RedesingWorkoutTypeViewController()
        redesingWorkout.modalPresentationStyle = .fullScreen
        redesingWorkout.workoutActivityType = activityType
        redesingWorkout.redesingWorkoutView.topView.workoutLabel.text = redesingView.workoutView.workoutLabel.text
        self.navigationController?.pushViewController(redesingWorkout, animated: true)
    }
}
extension RedesingWorkoutViewController: WorkoutTypePickerDelegate {
    func onTypePicked(type: ActivityType) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)      
        self.activityType = type
        print(activityType)
        switch type {
        case .WALK_IN_PLACE:
            redesingView.workoutView.setUI(image: "iconWorkoutHomeWalking", text:UserDefaults.standard.string(forKey: Constants.WALK_IN_PLACE) ?? "Ходьба на месте")
            redesingView.workoutDescriptionLabel.attributedText =  NSMutableAttributedString()
                .normal("Во время домашней тренировки приложение будет отслеживать")
                .bold(" время ")
                .normal("твоих занятий.\n\n")
                .normal("Держи телефон при себе, чтобы получить дополнительные доброрубли")
        case .RUN_IN_PLACE:
            redesingView.workoutView.setUI(image: "iconWorkoutHomeRunning", text:UserDefaults.standard.string(forKey: Constants.RUN_IN_PLACE) ?? "Бег на месте")
            redesingView.workoutDescriptionLabel.attributedText =  NSMutableAttributedString()
                .normal("Во время домашней тренировки приложение будет отслеживать")
                .bold(" время ")
                .normal("твоих занятий.\n\n")
                .normal("Держи телефон при себе, чтобы получить дополнительные доброрубли")
        case .ON_BICYCLE:
            redesingView.workoutView.setUI(image: "iconBicycleDriver", text:UserDefaults.standard.string(forKey: Constants.ON_BICYCLE) ??  "Велосипед")
        case .RUNNING:
            redesingView.workoutView.setUI(image: "iconRunningMan", text: UserDefaults.standard.string(forKey: Constants.RUNNING) ?? "Бег")
        case .WALKING:
            redesingView.workoutView.setUI(image: "iconWorkoutWalking", text: UserDefaults.standard.string(forKey: Constants.WALKING) ?? "Ходьба")
        case .SKATES:
            redesingView.workoutView.setUI(image: "iconWorkoutWinterSkating", text: UserDefaults.standard.string(forKey: Constants.SKATES) ?? "Катание на коньках")
        case .SKI:
            redesingView.workoutView.setUI(image: "iconWorkoutSkiing", text: UserDefaults.standard.string(forKey: Constants.SKI) ?? "Ходьба на лыжах")
        default:
            redesingView.workoutView.setUI(image: "iconWorkoutWalking", text: UserDefaults.standard.string(forKey: Constants.WALKING) ?? "Ходьба")
        }
    }
    func startInstractions() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "startTraning")
        if launchedBefore {
            self.coachMarksController.start(in: .window(over: self))
        } else {
            
          //  UserDefaults.standard.set(true, forKey: "startTraning")
        }
    }
}

