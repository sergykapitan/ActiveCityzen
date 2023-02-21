//
//  ViewChangeWorkoutType.swift
//  ActiveCitizen
//
//  Created by Sergey on 10.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit

final class ViewChangeWorkoutType: UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    var imageWorkout: UIImageView = {
        let image = UIImageView()
        return image
    }()
    var workoutLabel: UILabel = {
        let label = UILabel()
       // label.font = UIFont.familyNames
        label.textColor = UIColor(red: 0.1129, green: 0.129, blue: 0.129, alpha: 1)
        return label
    }()
    let changeWorkoutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0.51, green: 0.537, blue: 0.569, alpha: 1), for: .normal)
        button.setTitle("Изменить", for: .normal)
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
        cardView.addSubview(imageWorkout)
        imageWorkout.centerY(inView: cardView)
        imageWorkout.anchor(left: cardView.leftAnchor,
                            paddingLeft: 4)
        cardView.addSubview(workoutLabel)
        workoutLabel.centerY(inView: cardView)
        workoutLabel.anchor(left: imageWorkout.rightAnchor,
                             paddingLeft: 4 )
        cardView.addSubview(changeWorkoutButton)
        changeWorkoutButton.centerY(inView: cardView)
        changeWorkoutButton.anchor(right: cardView.rightAnchor,
                                   paddingRight: 10)
        
    }
    func setUI(image: String, text: String) {
        imageWorkout.image = UIImage(named: image)
        workoutLabel.text = text
        
    }
}
