//
//  ExpandableTextBoxItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 08.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

class ExpandableTextBoxItem: AbstractTableViewItem {
    var sender: Any?
    var preTitle: String
    var expandableBody: String
    var collapsedAttributedLink: String
    
    var type: TableViewItemType {
        return .expandableTextBox
    }
    
    init(preTitle: String, expandableBody: String, collapsedAttributedLink: String) {
        self.preTitle = preTitle
        self.expandableBody = expandableBody
        self.collapsedAttributedLink = collapsedAttributedLink
    }
}
