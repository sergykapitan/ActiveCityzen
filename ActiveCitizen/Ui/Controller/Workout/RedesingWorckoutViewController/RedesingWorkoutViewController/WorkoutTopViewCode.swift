//
//  WorkoutTopViewCode.swift
//  ActiveCitizen
//
//  Created by Sergey on 11.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit

final class WorkoutTopViewCode: UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    private var stackVerticalFirst: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
      //  stack.distribution = .fillProportionally
        return stack
    }()
    var workoutTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Тренировка"
        return label
    }()
    var workoutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Бег"
        return label
    }()
    var workoutTimerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.text = "00:00:00"
        return label
    }()
    var workoutTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Время"
        return label
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        stackVerticalFirst = UIStackView(arrangedSubviews: [workoutTitleLabel,workoutLabel,workoutTimerLabel,workoutTimeLabel])
        stackVerticalFirst.distribution = .fillEqually
        stackVerticalFirst.axis = .vertical
        stackVerticalFirst.spacing = 15
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        addSubview(cardView)
        cardView.fillSuperview()
        cardView.addSubview(stackVerticalFirst)
        stackVerticalFirst.anchor(top: cardView.topAnchor,
                           left: cardView.leftAnchor,
                           right: cardView.rightAnchor,
                           bottom: cardView.bottomAnchor,
                           paddingTop: 10, paddingLeft: 16, paddingRight: 16,paddingBottom: 10
                           )
    }
    
}
