//
//  UnderlinedSegmentedControlTableItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 31.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
struct UnderlinedSegmentedControlTableItem: AbstractTableViewItem {
    var sender: Any?
    var type : TableViewItemType {
        return .underlinedSegmentedControlTableItem
    }
    var controls: [SingleSegmentControl]
    init(controls: [SingleSegmentControl]) {
        self.controls = controls
    }
}
