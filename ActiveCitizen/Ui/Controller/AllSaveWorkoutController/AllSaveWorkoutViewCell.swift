//
//  AllSaveWorkoutViewCell.swift
//  ActiveCitizen
//
//  Created by Sergey on 17.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation
import UIKit

class AllSaveWorkoutViewCell: UITableViewCell {

static let reuseID = "AllSaveWorkoutViewCell"

    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var imageTypeActivity: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor(red: 0.212, green: 0.482, blue: 0.973, alpha: 0.24)
        image.layer.cornerRadius = 4
        return image
    }()
    var typeActivityLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "367BF8")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    var dataLabel: UILabel =  {
        let label = UILabel()
        label.textColor = UIColor(hexString: "9E9E9E")
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    var bottomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "2E3A48")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "0 мин/км"
        return label
    }()

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initialize()
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

override func awakeFromNib() {
    super.awakeFromNib()
    self.initialize()
}

func initialize() {
    initUI()
    
}
override func prepareForReuse() {
       super.prepareForReuse()    
      self.imageTypeActivity.image = nil
      self.typeActivityLabel.text = nil
      self.dataLabel.text = nil
      self.bottomLabel.text = nil
   }
    private func initUI() {
        addSubview(cardView)
        cardView.fillSuperview()
        cardView.addSubview(imageTypeActivity)
        imageTypeActivity.anchor(top: cardView.topAnchor,
                                 left: cardView.leftAnchor,
                                 paddingTop: 8, paddingLeft: 12, width: 20, height: 20)
        cardView.addSubview(typeActivityLabel)
        typeActivityLabel.anchor(left: imageTypeActivity.rightAnchor,
                                 paddingLeft: 4, height: 20)
        typeActivityLabel.centerY(inView: imageTypeActivity)
        cardView.addSubview(dataLabel)
        dataLabel.anchor(left: cardView.leftAnchor,
                        paddingLeft: 12, height: 20)
        dataLabel.centerY(inView: cardView)
        cardView.addSubview(bottomLabel)
        bottomLabel.anchor( left: cardView.leftAnchor,
                            bottom: cardView.bottomAnchor,
                            paddingLeft: 12, paddingBottom: 4,height: 20)
    }
}
