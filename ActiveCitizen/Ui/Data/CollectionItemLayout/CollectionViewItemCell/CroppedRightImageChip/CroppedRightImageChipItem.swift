//
//  CroppedRightImageChipItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 03.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

class CroppedRightImageChipItem: AbstractCollectionViewItem {
    var sender: Any?

    var title, imageLink, chipText: String
    var footer: String?
    
    var onItemClicked: (()-> Void)?
    
    init(title: String, imageLink: String, chipText: String) {
        self.title = title
        self.imageLink = imageLink
        self.chipText = chipText
    }
    
    init(title: String, imageLink: String, chipText: String, footer: String) {
        self.title = title
        self.imageLink = imageLink
        self.chipText = chipText
        self.footer = footer
    }
    
    var type: CollectionViewItemType {
        return .croppedRightImageChip
    }
}
