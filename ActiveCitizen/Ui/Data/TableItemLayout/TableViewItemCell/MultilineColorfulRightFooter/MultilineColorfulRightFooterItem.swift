//
//  MultilineColorfulRightFooter.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 09.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

class MultilineColorfulRightFooterItem: AbstractTableViewItem {
    var sender: Any?
    var preTitle: String
    var title: String
    var subTitle: String
    var colorfulFooterText: String
    var transparency = 1.0
   
    var type: TableViewItemType {
        return .multilineColorfulRightFooter
    }
    
    init(preTitle:String, title:String, subTitle: String, colorfulFooterText: String) {
        self.preTitle = preTitle
        self.title = title
        self.subTitle = subTitle
        self.colorfulFooterText = colorfulFooterText
    }
    
    func setTransparency(transparency: Double) {
        self.transparency = transparency
    }
}
