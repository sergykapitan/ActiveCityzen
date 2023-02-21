//
//  AbstractCollectionViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 26.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import UIKit

class AbstractCollectionViewCell: UICollectionViewCell {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
         NSLayoutConstraint.activate([
             contentView.leftAnchor.constraint(equalTo: leftAnchor),
             contentView.rightAnchor.constraint(equalTo: rightAnchor),
             contentView.topAnchor.constraint(equalTo: topAnchor),
             contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
         ])
     }
}
