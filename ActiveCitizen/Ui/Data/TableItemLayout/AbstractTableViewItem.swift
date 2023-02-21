//
//  AbstractTableViewItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 27.07.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

protocol AbstractTableViewItem {
    var type: TableViewItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String  { get }
    var sender: Any? { get set }
}

extension AbstractTableViewItem {
    var type: TableViewItemType {
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
