//
//  ColoredFootersItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 11.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import UIKit

struct ColoredFootersItem: AbstractTableViewItem {
    var title, footerLeftText, footerRightText: String?
    var colorFooterLeft, colorFooterRight: UIColor?
    var sender: Any?
    
    var type: TableViewItemType {
        return .coloredFootersItem
    }
    
    init(title:String, footerLeft: String, footerRight: String) {
        self.title = title
        self.footerLeftText = footerLeft
        self.footerRightText = footerRight
    }
    
    init(title: String, footerLeft: String, footerRight: String, colorFooterLeft: UIColor, colorFooterRight: UIColor) {
        self.title = title
        self.footerLeftText = footerLeft
        self.footerRightText = footerRight
        self.colorFooterLeft = colorFooterLeft
        self.colorFooterRight = colorFooterRight
    }
}
