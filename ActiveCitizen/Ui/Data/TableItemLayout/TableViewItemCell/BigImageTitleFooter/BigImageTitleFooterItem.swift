//
//  BigImageTitleFooterItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 18.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation

class BigImageTitleFooterItem: AbstractTableViewItem {
    var title, footer: String
    var imageLink: String?
    var sender: Any?
    
    init(title:String, footer: String, imageLink: String) {
        self.title = title
        self.footer = footer
        self.imageLink = imageLink
    }
    
    var type: TableViewItemType {
        return .bigImageTitleFooter
    }
}
