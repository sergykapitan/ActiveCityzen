//
//  TitleBadgeChipFooter.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 28.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

class TitleBadgeChipFooterItem: AbstractTableViewItem {
    var sender: Any?
    
    var badgeImageLink: String
    var title: String
    var header: String
    var chipText: String
    var footer: String
    
    var type: TableViewItemType {
        return .titleBadgeChipFooter
    }
    
    init(badgeImageLink: String, title: String, header: String, chipText: String, footer: String) {
        self.badgeImageLink = badgeImageLink
        self.title = title
        self.header = header
        self.chipText = chipText
        self.footer = footer
    }
}
