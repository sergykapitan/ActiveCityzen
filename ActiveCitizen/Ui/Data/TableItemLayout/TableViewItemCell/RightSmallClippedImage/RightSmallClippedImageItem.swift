//
//  RightSmallClippedImageItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 02.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

class RightSmallClippedImageItem: AbstractTableViewItem {
    var sender: Any?
    
    var type: TableViewItemType {
        return .rightSmallClippedImage
    }
    var imageLink: String?
    var title, subtitle: String
    var chipText: String?
    
    var footer: String?
    var onItemClicked: (()-> Void)?

    init(imageLink: String, title: String, subtitle: String, chipText: String) {
        self.imageLink = imageLink
        self.title = title
        self.subtitle = subtitle
        self.chipText = chipText
    }
    
    init(imageLink: String, title: String, subtitle: String, chipText: String, footer: String) {
        self.imageLink = imageLink
        self.title = title
        self.subtitle = subtitle
        self.chipText = chipText
        self.footer = footer
    }
}
