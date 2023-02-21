//
//  BadgeImageTitleItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 24.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

class BadgeImageTitleItem: AbstractTableViewItem {
    var type: TableViewItemType {
        return .badgeImageTitle
    }
    
    var sender: Any? = nil
    var imageViewHeaderLink: String
    var imageViewBadgeLink: String
    var preTitle: String
    var title: String
    var chipText: String
    var footer: String
    
    init(imageViewHeaderLink: String, imageViewBadgeLink: String,preTitle: String,title: String, chipText: String, footer: String) {
        self.imageViewHeaderLink = imageViewHeaderLink
        self.imageViewBadgeLink = imageViewBadgeLink
        self.preTitle = preTitle
        self.title = title
        self.chipText = chipText
        self.footer = footer
    }
}
