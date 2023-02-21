//
//  MainScreenItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 27.07.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
 
class MainScreenItem: AbstractTableViewItem {
    var sender: Any?
    var type: TableViewItemType {
        return .welcomingScreenItem
    }
    var preTitle = ""
    var title = ""
    var sectionLeft = ""
    var sectionRight = ""
    var onSectionRightClicked: (()-> Void)?
    var onSectionLeftClickeds: (()-> Void)?
    
    init(stepsCount: String) {
        self.sectionLeft = stepsCount
    }
    
    init(title: String, sectionLeft: String, sectionRight: String) {
        self.title = title
        self.sectionLeft = sectionLeft
        self.sectionRight = sectionRight
    }
}
