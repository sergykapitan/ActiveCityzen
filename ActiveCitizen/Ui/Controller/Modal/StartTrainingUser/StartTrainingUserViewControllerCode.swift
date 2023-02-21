//
//  StartTrainingUserViewControllerCode.swift
//  ActiveCitizen
//
//  Created by Sergey on 29.03.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation
import UIKit

final class StartTrainingUserViewControllerCode: UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let descriptionView: StartTraining = {
        let view = StartTraining()
        view.cornerRadius = 4
        return view
    }()
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        addSubview(cardView)
        cardView.fillSuperview()
//        cardView.bottomAnchor.constraint(equalTo: cardView.superview!.bottomAnchor).isActive = true
//        cardView.topAnchor.constraint(equalTo: cardView.superview!.topAnchor).isActive = true
//        cardView.leadingAnchor.constraint(equalTo: cardView.superview!.leadingAnchor).isActive = true
//        cardView.trailingAnchor.constraint(equalTo: cardView.superview!.trailingAnchor).isActive = true
        
        
        
      //  cardView.heightAnchor.constraint(equalTo: cardView.superview!.heightAnchor).isActive = true
      //  cardView.widthAnchor.constraint(equalTo: cardView.superview!.widthAnchor).isActive = true
      //  cardView.centerXAnchor.constraint(equalTo: cardView.superview!.centerXAnchor).isActive = true
      //  cardView.centerYAnchor.constraint(equalTo: cardView.superview!.centerYAnchor).isActive = true
       
        cardView.addSubview(descriptionView)
        descriptionView.centerX(inView: cardView)
        descriptionView.centerY(inView: cardView)
        descriptionView.anchor(width: 231, height: 180)
    }

    
}
