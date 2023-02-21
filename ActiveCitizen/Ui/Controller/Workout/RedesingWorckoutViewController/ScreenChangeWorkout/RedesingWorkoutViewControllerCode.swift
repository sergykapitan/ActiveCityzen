//
//  RedesingWorkoutViewControllerCode.swift
//  ActiveCitizen
//
//  Created by Sergey on 10.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit

final class RedesingWorkoutViewControllerCode: UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)//UIColor(hexString: "#F5F5F5")
        view.clipsToBounds = true
        return view
    }()
    var workoutChangeView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    var workoutView: ViewChangeWorkoutType = {
        let view = ViewChangeWorkoutType()
        view.cornerRadius = 4
        view.backgroundColor = UIColor(red: 0.212, green: 0.482, blue: 0.973, alpha: 0.08)
        view.tag = 8
        return view
    }()
    
    var workoutDescriptionLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.18, green: 0.227, blue: 0.282, alpha: 0.8)
        label.tag = 6
        label.attributedText =
            NSMutableAttributedString()
                .normal("Во время тренировки приложение фиксирует\n")
                .bold("расстояние,время и темп \n\n")
                .normal("Не закрывай приложение, иначе данные будут не точными")
        label.textAlignment = .center
        return label
    }()
    
    let butttonStartWorkout: UIButton = {
       let button  = UIButton()
        button.cornerRadius = 4
        let myString = "Начать"
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.systemBlue
        button.setTitle(myString, for: .normal)
       return button
   }()
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        addSubview(cardView)
        cardView.fillSuperview()

        cardView.addSubview(workoutView)
        workoutView.anchor(top: cardView.topAnchor,
                                 left: cardView.leftAnchor,
                                 right: cardView.rightAnchor,
                                 paddingTop: 184, paddingLeft: 16,
                                 paddingRight: 16, height: 48)
        cardView.addSubview(workoutDescriptionLabel)
        workoutDescriptionLabel.anchor(top: workoutView.bottomAnchor,
                                       left: cardView.leftAnchor,
                                       right: cardView.rightAnchor,
                                       paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        cardView.addSubview(butttonStartWorkout)
        butttonStartWorkout.anchor(top: workoutView.bottomAnchor,
                                   left: cardView.leftAnchor,
                                   right: cardView.rightAnchor,
                                   paddingTop: 116, paddingLeft: 16, paddingRight: 16,
                                   height: 36)
        
    }
}

