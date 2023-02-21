//
//  RedesingModalTypeView.swift
//  ActiveCitizen
//
//  Created by Sergey on 10.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit
import DLRadioButton

final class RedesingModalTypeView: UIView {
    
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
    var workoutLabel: DLRadioButton = {
        let label = DLRadioButton()
        label.setTitleColor(UIColor(red: 0.1129, green: 0.129, blue: 0.129, alpha: 1), for: .normal)
        label.titleLabel?.numberOfLines = 0
        return label
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
                            paddingLeft: 4,width: 30,height: 30)
        cardView.addSubview(workoutLabel)
        workoutLabel.centerY(inView: cardView)
        workoutLabel.anchor(top: cardView.topAnchor,
                            left: imageWorkout.rightAnchor,
                            right: cardView.rightAnchor,
                            bottom: cardView.bottomAnchor,
                            paddingTop: 0, paddingLeft: 4, paddingRight: 0, paddingBottom: 0)
                            
       
    }
}
