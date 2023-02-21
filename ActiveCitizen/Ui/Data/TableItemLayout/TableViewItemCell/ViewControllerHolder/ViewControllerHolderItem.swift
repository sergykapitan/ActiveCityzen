//
//  ViewControllerHolderItem.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class ViewControllerHolderItem: AbstractTableViewItem {
    var sender: Any? = nil
    var childViewController: UIViewController
    var parentViewController: UIViewController
    
    var type: TableViewItemType {
        return .viewControllerHolder
    }
    
    init(parentViewController: UIViewController, childViewController: UIViewController) {
        self.childViewController = childViewController
        self.parentViewController = parentViewController
    }
}
