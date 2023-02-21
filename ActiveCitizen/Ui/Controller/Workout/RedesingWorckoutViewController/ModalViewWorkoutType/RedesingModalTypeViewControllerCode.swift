//
//  RedesingModalTypeViewControllerCode.swift
//  ActiveCitizen
//
//  Created by Sergey on 10.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit
import DLRadioButton

final class RedesingModalTypeViewControllerCode: UIView {
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#F5F5F5")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    let typeSport: UILabel = {
        let label = UILabel()
        label.text = "Вид Спорта"
        return label
    }()
    let buttonClose: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "iconCrossGray"), for: .normal)
        return button
    }()
    private var stackHFirst: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    let walkingManView: RedesingModalTypeView = {
        let view = RedesingModalTypeView()
        view.imageWorkout.image = UIImage(named: "iconWorkoutWalking")
       // view.workoutLabel.setTitle("Ходьба", for: .normal)
        view.workoutLabel.setTitle(UserDefaults.standard.string(forKey: Constants.WALKING), for: .normal)
        view.workoutLabel.iconSelected = UIImage(named: "iconCheckmarkGray")!
        view.anchor(height: 48)
        view.workoutLabel.contentHorizontalAlignment = .left
        view.workoutLabel.iconColor = .clear
        view.workoutLabel.isIconOnRight = true
        view.workoutLabel.tag = 1
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.cornerRadius = 4
        return view
    }()
    let runningManView: RedesingModalTypeView = {
        let view = RedesingModalTypeView()
        view.imageWorkout.image = UIImage(named: "iconRunningMan")
        view.workoutLabel.setTitle(UserDefaults.standard.string(forKey: Constants.RUNNING), for: .normal)
        view.workoutLabel.iconSelected = UIImage(named: "iconCheckmarkGray")!
        view.workoutLabel.contentHorizontalAlignment = .left
        view.workoutLabel.iconColor = .clear
        view.workoutLabel.isIconOnRight = true
        view.anchor(height: 48)
        view.workoutLabel.tag = 2
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.cornerRadius = 4
        return view
    }()
    let bicycleManView: RedesingModalTypeView = {
        let view = RedesingModalTypeView()
        view.imageWorkout.image = UIImage(named: "iconBicycleDriver")
        view.workoutLabel.setTitle(UserDefaults.standard.string(forKey: Constants.ON_BICYCLE), for: .normal)
        view.workoutLabel.iconSelected = UIImage(named: "iconCheckmarkGray")!
        view.workoutLabel.contentHorizontalAlignment = .left
        view.workoutLabel.iconColor = .clear
        view.workoutLabel.isIconOnRight = true
        view.anchor(height: 48)
        view.workoutLabel.tag = 3
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.cornerRadius = 4
        return view
    }()
    let winterSkatingManView: RedesingModalTypeView = {
        let view = RedesingModalTypeView()
        view.imageWorkout.image = UIImage(named: "iconWorkoutWinterSkating")
        view.workoutLabel.setTitle(UserDefaults.standard.string(forKey: Constants.SKATES), for: .normal)
        view.workoutLabel.iconSelected = UIImage(named: "iconCheckmarkGray")!
        view.workoutLabel.contentHorizontalAlignment = .left
        view.workoutLabel.iconColor = .clear
        view.workoutLabel.isIconOnRight = true
        view.anchor(height: 48)
        view.workoutLabel.tag = 9
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.cornerRadius = 4
        return view
    }()
    let skiingManView: RedesingModalTypeView = {
        let view = RedesingModalTypeView()
        view.imageWorkout.image = UIImage(named: "iconWorkoutSkiing")
        view.workoutLabel.setTitle(UserDefaults.standard.string(forKey: Constants.SKI), for: .normal)
        view.workoutLabel.iconSelected = UIImage(named: "iconCheckmarkGray")!
        view.workoutLabel.contentHorizontalAlignment = .left
        view.workoutLabel.iconColor = .clear
        view.workoutLabel.isIconOnRight = true
        view.anchor(height: 48)
        view.workoutLabel.tag = 10
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.cornerRadius = 4
        return view
    }()
    let homeWalkingManView: RedesingModalTypeView = {
        let view = RedesingModalTypeView()
        view.imageWorkout.image = UIImage(named: "iconWorkoutHomeWalking")
        view.workoutLabel.setTitle(UserDefaults.standard.string(forKey: Constants.WALK_IN_PLACE), for: .normal)
        view.workoutLabel.iconSelected = UIImage(named: "iconCheckmarkGray")!
        view.workoutLabel.contentHorizontalAlignment = .left
        view.workoutLabel.iconColor = .clear
        view.workoutLabel.isIconOnRight = true
        view.anchor(height: 48)
        view.workoutLabel.tag = 11
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.cornerRadius = 4
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 10))
        label.textColor = UIColor(hexString: "9E9E9E")
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .left
        label.text = "домашняя тренировка"
        view.workoutLabel.addSubview(label)
        label.anchor(left: view.workoutLabel.leftAnchor,
                     bottom: view.bottomAnchor,
                     paddingLeft: 0,paddingBottom: 4)
        return view
    }()
    let homeRunningManView: RedesingModalTypeView = {
        let view = RedesingModalTypeView()
        view.imageWorkout.image = UIImage(named: "iconWorkoutHomeRunning")
        view.workoutLabel.setTitle(UserDefaults.standard.string(forKey: Constants.RUN_IN_PLACE), for: .normal)
        view.workoutLabel.iconSelected = UIImage(named: "iconCheckmarkGray")!
        view.workoutLabel.contentHorizontalAlignment = .left
        view.workoutLabel.iconColor = .clear
        view.workoutLabel.isIconOnRight = true
        view.anchor(height: 48)
        view.workoutLabel.tag = 12
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.cornerRadius = 4
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 10))
        label.textColor = UIColor(hexString: "9E9E9E")
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .left
        label.text = "домашняя тренировка"
        view.workoutLabel.addSubview(label)
        label.anchor(left: view.workoutLabel.leftAnchor,
                     bottom: view.bottomAnchor,
                     paddingLeft: 0,paddingBottom: 4)
        return view
    }()
    
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        stackHFirst = UIStackView(arrangedSubviews: [walkingManView,runningManView,bicycleManView,winterSkatingManView,skiingManView,homeWalkingManView,homeRunningManView])
        stackHFirst.axis = .vertical
        stackHFirst.spacing = 10
        initUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        addSubview(cardView)
        cardView.fillSuperview()
        cardView.addSubview(typeSport)
        typeSport.anchor(top: cardView.topAnchor,
                         left: cardView.leftAnchor,
                         paddingTop: 18, paddingLeft: 16,
                         height: 20)
        cardView.addSubview(buttonClose)
        buttonClose.anchor(top: cardView.topAnchor,
                           right: cardView.rightAnchor,
                           paddingTop: 18,paddingRight: 20, width: 21, height: 21)
        cardView.addSubview(stackHFirst)
        stackHFirst.anchor(top: typeSport.bottomAnchor,
                           left: cardView.leftAnchor,
                           right: cardView.rightAnchor,
                           paddingTop: 20, paddingLeft: 16, paddingRight: 16
                           )
        
        
        
    }
}
