//
//  AllSaveWorkoutViewController.swift
//  ActiveCitizen
//
//  Created by Sergey on 17.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class AllSaveWorkoutViewController: UIViewController {
    
    var workoutActivityType: ActivityType?
    let allWorkoutView = AllSaveWorkoutCode()
    let realm = try! Realm()
    lazy var categories: Results<ResultWorkout> = { self.realm.objects(ResultWorkout.self) }()
 
    //MARK: - LifeCicle
    override func loadView() {
        super.loadView()
        view = allWorkoutView        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        allWorkoutView.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
      //  self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        navigationItem.title = "Все Тренировки"    
        makeTableView()
        view.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
    }
    private func makeTableView() {
        allWorkoutView.tableView.dataSource = self
        allWorkoutView.tableView.delegate = self
        allWorkoutView.tableView.register(AllSaveWorkoutViewCell.self, forCellReuseIdentifier: AllSaveWorkoutViewCell.reuseID)
    }
  
}
