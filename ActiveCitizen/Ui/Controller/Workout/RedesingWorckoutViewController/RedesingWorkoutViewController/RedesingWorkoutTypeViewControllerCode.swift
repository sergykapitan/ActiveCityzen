//
//  RedesingWorkoutTypeViewControllerCode.swift
//  ActiveCitizen
//
//  Created by Sergey on 11.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit

final class RedesingWorkoutTypeViewControllerCode: UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let topView: WorkoutTopViewCode = {
        let view = WorkoutTopViewCode()
        view.backgroundColor = UIColor(hexString: "367BF8")
        return view
    }()
    let bottomView: WorkoutBottomViewCode = {
        let view = WorkoutBottomViewCode()
        view.backgroundColor = .white
        return view
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
        cardView.heightAnchor.constraint(equalTo: cardView.superview!.heightAnchor).isActive = true
        cardView.widthAnchor.constraint(equalTo: cardView.superview!.widthAnchor).isActive = true
        cardView.centerXAnchor.constraint(equalTo: cardView.superview!.centerXAnchor).isActive = true
        cardView.centerYAnchor.constraint(equalTo: cardView.superview!.centerYAnchor).isActive = true
        cardView.addSubview(topView)
        topView.heightEqualToMultiplier(inView: cardView, multiplier: 0.45)
        topView.anchor(top: cardView.topAnchor,
                       left: cardView.leftAnchor,
                       right: cardView.rightAnchor,
                       paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        cardView.addSubview(bottomView)
        bottomView.anchor(top: topView.bottomAnchor,
                          left: cardView.leftAnchor,
                          right: cardView.rightAnchor,
                          bottom: cardView.bottomAnchor,
                          paddingTop: 10, paddingLeft: 10,
                          paddingRight: 10, paddingBottom: 10)
       
    }
    
}
