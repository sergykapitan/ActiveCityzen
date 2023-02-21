//
//  WorkoutBottomViewCode.swift
//  ActiveCitizen
//
//  Created by Sergey on 11.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit

final class WorkoutBottomViewCode: UIView {
    
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
    var workoutPaceChangeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "367BF8")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "000 мин/км"
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
        label.text = "000,00 км"
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
    var buttonPauseWorkout: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "367BF8")
        button.setImage(#imageLiteral(resourceName: "pausenew"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "iconspause"), for: .highlighted)
        return button
    }()
    var buttonStopWorkout: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "FE2231")
        button.setImage(#imageLiteral(resourceName: "stopnew"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "iconstop24"), for: .highlighted)
        return button
    }()
    var buttonProceedWorkout: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "0DB13B")
        button.setImage(#imageLiteral(resourceName: "iconsplay24"), for: .normal)
        return button
    }()
    var circleAnimation: CircularProgressView = {
        let circle = CircularProgressView()
        circle.angle = 0
        circle.startAngle = -90
        circle.progressThickness = 0.2
        circle.trackColor = .clear
        circle.glowMode = .noGlow
        circle.glowAmount = 0
        circle.set(colors: .red)
        return circle
    }()
    var pauseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Пауза"
        return label
    }()
    var stopLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Завершить"
        return label
    }()
    var proccesedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Продолжить"
        return label
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
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        addSubview(cardView)
        cardView.fillSuperview()
        cardView.addSubview(stackHorisontalFirst)
        stackHorisontalFirst.anchor(top: cardView.topAnchor,
                                    left: cardView.leftAnchor,
                                    paddingTop: 10, paddingLeft: 10)
        stackHorisontalFirst.widthEqualToMultiplier(inView: cardView, multiplier: 0.3)
               
        cardView.addSubview(stackHorisontalThird)
        stackHorisontalThird.anchor(top: cardView.topAnchor,
                                    right: cardView.rightAnchor,
                                    paddingTop: 10, paddingRight: 10)
        stackHorisontalThird.widthEqualToMultiplier(inView: cardView, multiplier: 0.3)
        
        
        cardView.addSubview(stackHorisontalSecond)
        stackHorisontalSecond.anchor(top: cardView.topAnchor,
                                    paddingTop: 10)
        stackHorisontalSecond.centerX(inView: cardView)
        stackHorisontalSecond.widthEqualToMultiplier(inView: cardView, multiplier: 0.3)

        cardView.addSubview(buttonPauseWorkout)
        cardView.addSubview(pauseLabel)
        buttonPauseWorkout.centerX(inView: cardView)
        buttonPauseWorkout.anchor(bottom: cardView.bottomAnchor,
                                  paddingBottom: 52,
                                  width: 64, height: 64)
        pauseLabel.centerX(inView: buttonPauseWorkout)
        pauseLabel.anchor(top: buttonPauseWorkout.bottomAnchor,
                          left: buttonPauseWorkout.leftAnchor,
                          right: buttonPauseWorkout.rightAnchor,
                          paddingTop: 8, paddingLeft: 0, paddingRight: 0)
        
       
        cardView.addSubview(circleAnimation)
        cardView.addSubview(stopLabel)
        circleAnimation.anchor( width: 74, height: 74)
                
        circleAnimation.addSubview(buttonStopWorkout)
        buttonStopWorkout.anchor( left: cardView.leftAnchor,
                                         bottom: cardView.bottomAnchor,
                                         paddingLeft: 32, paddingBottom: 52,
                                         width: 64, height: 64)
        stopLabel.centerX(inView: buttonStopWorkout)
        stopLabel.anchor(top: buttonStopWorkout.bottomAnchor,
                         paddingTop: 8)
        
        circleAnimation.centerY(inView: buttonStopWorkout)
        circleAnimation.centerX(inView: buttonStopWorkout)
        cardView.addSubview(buttonProceedWorkout)
        cardView.addSubview(proccesedLabel)
        buttonProceedWorkout.anchor( right: cardView.rightAnchor,
                                  bottom: cardView.bottomAnchor,
                                  paddingRight:32, paddingBottom: 52,
                                  width: 64, height: 64)
        proccesedLabel.centerX(inView: buttonProceedWorkout)
        proccesedLabel.anchor(top: buttonProceedWorkout.bottomAnchor,
                              paddingTop: 8)
    }
    
}
