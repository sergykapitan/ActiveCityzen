//
//  SingleShortButtonImageItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 23.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

class SingleShortButtonImageItem: AbstractTableViewItem {
    var sender: Any?
    var buttonTitle: String
    var imageViewName: String
    var backgroundColor: String
    var titleTextButton: String
    var type: TableViewItemType {
        return .singleShortButtonImageItem
    }
    init(title: String, imageViewName: String,backgroundColor: String,titleTextButton: String) {
        self.buttonTitle = title
        self.imageViewName = imageViewName
        self.backgroundColor = backgroundColor
        self.titleTextButton = titleTextButton
    }
}
