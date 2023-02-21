//
//  SingleButtonItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 22.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//
import UIKit

struct SingleButtonItem: AbstractTableViewItem {
    var sender: Any?
    var type: TableViewItemType {
        return .singleButton
    }
    var title: String
    var backgroundColor: String?
    var textColor: String?
    
    init(title: String) {
        self.title = title
    }

    init(title: String, backgroundColor: String, textColor: String) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
}
