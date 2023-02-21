//
//  StartTraining.swift
//  ActiveCitizen
//
//  Created by Sergey on 29.03.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation
import UIKit

final class StartTraining: UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 4
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Добро Пожаловать"
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hexString: "9E9E9E")
        label.numberOfLines = 0
        label.text = "Наше приложение поможет тебе быть всегда в отличной форме."
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "#6181F2")
        button.setTitle("Начать", for: .normal)
        button.cornerRadius = 4
        return button
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
        cardView.addSubview(titleLabel)
        titleLabel.anchor(top: cardView.topAnchor,
                          left: cardView.leftAnchor,
                          right: cardView.rightAnchor,
                          paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        cardView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor,
                                left: cardView.leftAnchor,
                                right: cardView.rightAnchor,
                                paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        cardView.addSubview(startButton)
        startButton.centerX(inView: cardView)
        startButton.anchor( bottom: cardView.bottomAnchor,paddingBottom: 16, width: 83, height: 36)
        


    }
  
}
