//
//  HorizontalLeftImageCollectionItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 24.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation

struct HorizontalLeftImageCollectionItem: AbstractTableViewItem {
    var sender: Any?
    var type: TableViewItemType {
        return .horizontalLeftImageCollection
    }
    var title: String
    var leftImageCollectionElements: Array<ElementLeftImagePreviewCollectionItem>
    var didTapShowAllClosure: (()-> Void)?
    
    init(title: String, leftImageCollectionElements: Array<ElementLeftImagePreviewCollectionItem>) {
        self.title = title
        self.leftImageCollectionElements = leftImageCollectionElements
    }
}
