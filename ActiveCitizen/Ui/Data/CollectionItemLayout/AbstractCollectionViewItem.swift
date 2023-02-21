//
//  AbstractCollectionViewItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 26.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

protocol AbstractCollectionViewItem {
    var type: CollectionViewItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String  { get }
    var sender: Any? { get set }
}

extension AbstractCollectionViewItem {
    var type: CollectionViewItemType {
        return .empty
    }
    
    var sectionTitle: String {
        return "Default Section Title"
    }
    var rowCount: Int {
        return 1
    }
    var sender: Any? {
        return nil
    }
}
