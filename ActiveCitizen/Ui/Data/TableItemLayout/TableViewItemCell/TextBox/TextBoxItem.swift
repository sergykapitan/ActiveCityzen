//
//  TextBoxItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 18.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation

struct TextBoxItem: AbstractTableViewItem {
    var sender: Any?
    
    var type: TableViewItemType {
        return .textBoxItem
    }
    
    var title, body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}
