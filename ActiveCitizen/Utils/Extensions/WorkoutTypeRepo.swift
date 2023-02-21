//
//  WorkoutTypeRepo.swift
//  ActiveCitizen
//
//  Created by Sergey on 25.05.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation
import RxSwift

class WorkoutTypeRepo {
    
    @Inject var citizenApi: CitizenAPI
    let disposeBag = DisposeBag()
    static let shared = WorkoutTypeRepo()
    let date = Date()
    static var defaultWorkoutNames: WorkoutType?

   // UserDefaults.standard.set("Ходьба на месте", forKey: Constants)
   
    
    static let defWorkoutName = WorkoutType(list: [List(id: 2, title: "Ходьба на месте", deleted: false), List(id: 3, title: "Бег на месте", deleted: false), List(id: 4, title: "Ходьба", deleted: false), List(id: 5, title: "Пробежка", deleted: false), List(id: 6, title: "Езда на велосипеде", deleted: false), List(id: 7, title: "Катание на роликах", deleted: false), List(id: 8, title: "Катание на роликовых лыжах", deleted: false)], limit: Optional(100), offset: Optional(0), count: Optional(7))

    func getWorkoutTypeName() {
        citizenApi.getWorkoutType().subscribe(onNext: { result in
            WorkoutTypeRepo.defaultWorkoutNames = result
            UserDefaults.standard.set(result.list[0].title, forKey: Constants.WALK_IN_PLACE)
            UserDefaults.standard.set(result.list[1].title, forKey: Constants.RUN_IN_PLACE)
            UserDefaults.standard.set(result.list[2].title, forKey: Constants.WALKING)
            UserDefaults.standard.set(result.list[3].title, forKey: Constants.RUNNING)
            UserDefaults.standard.set(result.list[4].title, forKey: Constants.ON_BICYCLE)
            UserDefaults.standard.set(result.list[5].title, forKey: Constants.SKATES)
            UserDefaults.standard.set(result.list[6].title, forKey: Constants.SKI)
           
        }, onError: { error in
        }).disposed(by: disposeBag)
    }
    func timerMounts() {
        UserDefaults.standard.set("Ходьба на месте", forKey: Constants.WALK_IN_PLACE)
        UserDefaults.standard.set("Бег на месте", forKey: Constants.RUN_IN_PLACE)
        UserDefaults.standard.set("Ходьба", forKey: Constants.WALKING)
        UserDefaults.standard.set("Пробежка", forKey: Constants.RUNNING)
        UserDefaults.standard.set("Езда на велосипеде", forKey: Constants.ON_BICYCLE)
        UserDefaults.standard.set("Катание на роликах", forKey: Constants.SKATES)
        UserDefaults.standard.set("Катание на роликовых лыжах", forKey: Constants.SKI)
        
        let formate = date.getFormattedDate(format: "d")
        if formate == "1" || formate == "15" {
            self.getWorkoutTypeName()
        }
    }
    
}
