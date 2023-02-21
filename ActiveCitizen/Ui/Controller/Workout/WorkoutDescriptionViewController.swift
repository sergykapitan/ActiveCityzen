//
//  WorkoutDescriptionViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 21.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import YandexMobileMetrica
import Instructions

protocol StartTraningDelegate: class {
    func onButtonTapTraning()
}

class WorkoutDescriptionViewController: UIViewController, WorkoutTypePickerDelegate{
 
    
    @IBOutlet weak var allWorkoutButton: UIButton!
    @IBOutlet weak var buttonOpenWorkoutMenu: UIButton!

    weak var delegate: StartTraningDelegate?
    
    let realm = try! Realm()
    lazy var workout: Results<ResultWorkout> = { self.realm.objects(ResultWorkout.self) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonOpenWorkoutMenu.addTarget(self, action: #selector(openRedesingWorkoutViewController), for: .touchUpInside)
        allWorkoutButton.addTarget(self, action: #selector(openAllSaveWorkout), for: .touchUpInside)
    }
    override func viewDidAppear(_ animated: Bool) {
        if workout.isEmpty {
            allWorkoutButton.isHidden = true
        } else {
            allWorkoutButton.isHidden = false
        }
    }
    
    @objc func openWorkoutViewController() {
        let workoutTypePickerController = WorkoutTypeModalViewController()
        workoutTypePickerController.workoutTypePickerDelegate = self
        workoutTypePickerController.modalPresentationStyle = .overCurrentContext
        workoutTypePickerController.modalTransitionStyle = .crossDissolve
        self.present(workoutTypePickerController, animated: true, completion: nil)
    }
    @objc func openRedesingWorkoutViewController() {
        openStartWorkout()
        UserDefaults.standard.set(true, forKey: "startWorkout")
        self.delegate?.onButtonTapTraning()
        let redesingWorkoutTypePickerControler = RedesingWorkoutViewController()
        redesingWorkoutTypePickerControler.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(redesingWorkoutTypePickerControler, animated: true)
    }
    @objc func openAllSaveWorkout() {
        let allWorkout = AllSaveWorkoutViewController()
        navigationController?.pushViewController(allWorkout, animated: true)
       // self.present(workoutTypePickerController, animated: true, completion: nil)
    }
    
    func onTypePicked(type: ActivityType) {
        let workoutViewController = WorkoutViewController()
        workoutViewController.workoutActivityType = type
        workoutViewController.view.bounds = self.view.frame
        workoutViewController.modalPresentationStyle = .formSheet
        self.addChild(workoutViewController)
        
        workoutViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        workoutViewController.view.frame = self.view.bounds
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(workoutViewController.view)
        workoutViewController.didMove(toParent: self)
    }
    func openStartWorkout() {
    YMMYandexMetrica.reportEvent("Переход по кнопке Начать тренировку", onFailure: { (error) in
        print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
