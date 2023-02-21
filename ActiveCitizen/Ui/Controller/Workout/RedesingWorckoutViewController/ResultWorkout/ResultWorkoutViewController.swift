//
//  ResultWorkoutViewController.swift
//  ActiveCitizen
//
//  Created by Sergey on 17.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import YandexMobileMetrica

class ResultWorkoutViewController: UIViewController {

    let resultView = ResultWorkoutCode()
    var activityType: ActivityType?
    private let workoutDao = RealmDao<ResultWorkout>()
    
    
    //MARK: - LifeCicle
    override func loadView() {
        super.loadView()
        view = resultView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        createNavBar()
        actionSaveButton()
        view.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    // MARK: - Metods
    func setUI(typeActivity: String,time: String ,distance: String, pace: String) {
        if typeActivity == "Бег на месте" || typeActivity == "Ходьба на месте"{
            
            resultView.stackHorisontalFirst.widthEqualToMultiplier(inView: resultView.cardView , multiplier: 0.5)
            resultView.stackHorisontalThird.widthEqualToMultiplier(inView: resultView.cardView , multiplier: 0.5)
            
            resultView.typeActivityLabel.text = typeActivity
            resultView.workoutBottomTimerLabel.text = time
            
            resultView.workoutDistanceLabel.isHidden = true
            resultView.workoutDistanceChangeLabel.isHidden = true
            
            resultView.workoutPaceChangeLabel.text = pace
            resultView.workoutPaceLabel.text = "Шаги"
        } else {
        resultView.typeActivityLabel.text = typeActivity
        resultView.workoutBottomTimerLabel.text = time
        resultView.workoutDistanceChangeLabel.text = distance
        resultView.workoutPaceChangeLabel.text = pace
        }
    }
    private func createNavBar() {        
        navigationItem.title = "Результаты тренировки"
        let closeController = UIBarButtonItem(image: nil, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = closeController
    }
    private func actionSaveButton() {
        resultView.buttonSaveWorkout.addTarget(self, action: #selector(saveWorkout), for: .touchUpInside)
       
    }
   
    // MARK: - Selectors
  
    @objc func saveWorkout() {
        openSaveWorkout()
        let type = activityType
        var str = ""
        let newResult = ResultWorkout()
        newResult.time = resultView.workoutBottomTimerLabel.text ?? "0 мин"
        newResult.distance = resultView.workoutDistanceChangeLabel.text ?? "0 км"
        newResult.pace = resultView.workoutPaceChangeLabel.text ?? "0 мин/км"
        newResult.typeWorkout = resultView.typeActivityLabel.text ?? "не опозннаная Тренировка"
        newResult.imageName = str.setImageForTypeActivity(type: type ?? .UNKNOWN)
        workoutDao.save(newResult)
        self.navigationController?.popToRootViewController(animated: true)
    }
    func openSaveWorkout() {
    YMMYandexMetrica.reportEvent("Переход по кнопке Сохранить тренировку", onFailure: { (error) in
        print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

