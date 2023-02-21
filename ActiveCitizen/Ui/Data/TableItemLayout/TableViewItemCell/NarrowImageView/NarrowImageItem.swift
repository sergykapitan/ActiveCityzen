//
//  NarrowImageItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 25.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

class NarrowImageItem: AbstractTableViewItem {
    var sender: Any?
    
    var type: TableViewItemType {
        return .narrowImageItem
    }
    
    var imageLink: String
    init(imageLink: String) {
        self.imageLink = imageLink
    }
}
