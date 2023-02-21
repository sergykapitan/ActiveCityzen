//
//  ResultWorkoutCode.swift
//  ActiveCitizen
//
//  Created by Sergey on 17.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit

final class ResultWorkoutCode: UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    var stackVerticalFirst: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    var stackHorisontalFirst: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    var stackHorisontalSecond: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    var stackHorisontalThird: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var typeActivityLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    var workoutPaceChangeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "367BF8")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "0 мин/км"
        return label
    }()
    var workoutPaceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Темп"
        return label
    }()
  
    var workoutDistanceChangeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "367BF8")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = ""
        return label
    }()
    var workoutDistanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Расстояние"
        return label
    }()
    var workoutBottomTimerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "367BF8")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "00:00:00"
        return label
    }()
    var workoutBottomTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Время"
        return label
    }()
    var buttonSaveWorkout: UIButton = {
        let button = UIButton()
        button.cornerRadius = 4
        button.backgroundColor = UIColor(hexString: "367BF8")
        button.setTitle("Сохранить Тренировку", for: .normal)
        return button
    }()
    var navigationBar : UINavigationBar = {
        let bar = UINavigationBar()
        bar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)]
        return bar
    }()
   
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        stackHorisontalFirst = UIStackView(arrangedSubviews: [workoutBottomTimerLabel,workoutBottomTimeLabel])
        stackHorisontalFirst.axis = .vertical
        stackHorisontalSecond = UIStackView(arrangedSubviews: [workoutDistanceChangeLabel,workoutDistanceLabel])
        stackHorisontalSecond.axis = .vertical
        stackHorisontalThird = UIStackView(arrangedSubviews: [workoutPaceChangeLabel,workoutPaceLabel])
        stackHorisontalThird.axis = .vertical
      //  stackVerticalFirst = UIStackView(arrangedSubviews: [stackHorisontalSecond,stackHorisontalFirst,stackHorisontalThird])
       // stackVerticalFirst.distribution = .fillEqually
       // stackVerticalFirst.axis = .horizontal
      //  stackVerticalFirst.spacing = 15
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        addSubview(cardView)
        cardView.fillSuperview()
        cardView.addSubview(typeActivityLabel)
        typeActivityLabel.anchor(top: cardView.topAnchor,
                                 left: cardView.leftAnchor,
                                 right: cardView.rightAnchor,
                                 paddingTop: 10, paddingLeft: 5, paddingRight: 5,
                                 height: 30)
        cardView.addSubview(stackHorisontalFirst)
        
        stackHorisontalFirst.anchor(top: typeActivityLabel.bottomAnchor,
                                    left: cardView.leftAnchor,
                                    paddingTop: 10, paddingLeft: 10)
        stackHorisontalFirst.widthEqualToMultiplier(inView: cardView, multiplier: 0.3)
               
        cardView.addSubview(stackHorisontalThird)
        stackHorisontalThird.anchor(top: typeActivityLabel.bottomAnchor,
                                    right: cardView.rightAnchor,
                                    paddingTop: 10, paddingRight: 10)
        stackHorisontalThird.widthEqualToMultiplier(inView: cardView, multiplier: 0.3)
       
        cardView.addSubview(stackHorisontalSecond)
        stackHorisontalSecond.anchor(top: typeActivityLabel.bottomAnchor,
                                    paddingTop: 10)
        stackHorisontalSecond.centerX(inView: cardView)
        stackHorisontalSecond.widthEqualToMultiplier(inView: cardView, multiplier: 0.3)
        
        
 
        
        
//        cardView.addSubview(stackVerticalFirst)
//        stackVerticalFirst.anchor(top: typeActivityLabel.bottomAnchor,
//                           left: cardView.leftAnchor,
//                           right: cardView.rightAnchor,
//                           paddingTop: 10, paddingLeft: 16, paddingRight: 16
//                           )
        cardView.addSubview(buttonSaveWorkout)
        buttonSaveWorkout.anchor(top: typeActivityLabel.bottomAnchor,
                                 left: cardView.leftAnchor,
                                 right: cardView.rightAnchor,
                                 paddingTop: 82, paddingLeft: 16, paddingRight: 16,
                                 height: 36)
    }
    
}
