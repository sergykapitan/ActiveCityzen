//
//  AbstractTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 11.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import UIKit

class AbstractTableViewCell: UITableViewCell {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
