//
//  ElementLeftImagePreviewItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class ElementLeftImagePreviewItem: AbstractTableViewItem {
    var image: String?
    var preTitle, title, subTitle, footer: String?
    var sender: Any?

    var type: TableViewItemType {
        return .imageLeftPreviewItem
    }
    
    required init(title: String, subTitle: String) {
        self.title = title
        self.subTitle = subTitle
    }
    
    init(image: String, preTitle: String, title: String, subTitle: String, footer: String) {
        self.image = image
        self.preTitle = preTitle
        self.title = title
        self.subTitle = subTitle
        self.footer = footer
    }
}
