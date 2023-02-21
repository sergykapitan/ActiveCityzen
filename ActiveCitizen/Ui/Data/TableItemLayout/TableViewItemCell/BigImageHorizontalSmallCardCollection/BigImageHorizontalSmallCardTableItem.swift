//
//  BigImageHorizontalSmallCardCollectionItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 29.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class BigImageHorizontalSmallCardTableItem: AbstractTableViewItem {
   
    var type: TableViewItemType {
        return .bigImageHorizontalSmallCardItem
    }
    var sender: Any? = nil
    
    var imageLink: String?
    var title, subtitle: String
    var chipText: String?
    var carouselItems: [AbstractCollectionViewItem] = []
    
    var carouselTitle: String
    var carouselActionButtonText: String
    var didTapShowMoreClosure: (() -> Void)?

    init(imageLink: String, title: String, subtitle: String, chipText: String,carouselTitle: String, carouselActionButtonText: String) {
        self.imageLink = imageLink
        self.title = title
        self.subtitle = subtitle
        self.chipText = chipText
        self.carouselTitle = carouselTitle
        self.carouselActionButtonText = carouselActionButtonText
    }
    
    init(imageLink: String, title: String, subtitle: String, chipText: String,carouselTitle: String, carouselActionButtonText: String, carouselItems: [AbstractCollectionViewItem]) {
        self.imageLink = imageLink
        self.title = title
        self.subtitle = subtitle
        self.chipText = chipText
        self.carouselTitle = carouselTitle
        self.carouselActionButtonText = carouselActionButtonText
        self.carouselItems = carouselItems
    }
}
