//
//  MultilineSpannedTextBoxItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 08.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

class MultilineSpannedTextBoxItem: AbstractTableViewItem {
    var sender: Any?
    
    var title: String
    var subtitle1: String
    var subtitle2: String
    var footer: String
    var bottomCaption: String
    
    var type: TableViewItemType {
        return .multilineSpannedTextBox
    }
    
    init(title: String, subtitle1: String, subtitle2: String, footer: String, bottomCaption: String) {
        self.title = title
        self.subtitle1 = subtitle1
        self.subtitle2 = subtitle2
        self.footer = footer
        self.bottomCaption = bottomCaption
    }
}
