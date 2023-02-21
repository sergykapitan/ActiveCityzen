
//
//  ViewControllerHolderTableCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class ViewControllerHolderTableCell: AbstractTableViewCell {
    
    var item: ViewControllerHolderItem? {
        didSet {
            guard let item = item else { return }
            
            self.layoutIfNeeded()
            
            item.parentViewController.addChild(item.childViewController)
            self.contentView.addSubview(item.childViewController.view)
            self.addSubview(item.childViewController.view)
            
            item.childViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            item.childViewController.view.leadingAnchor.constraint(equalTo:  item.childViewController.view.superview!.leadingAnchor, constant: 0.0).isActive = true
            item.childViewController.view.trailingAnchor.constraint(equalTo:  item.childViewController.view.superview!.trailingAnchor, constant: 0.0).isActive = true
            item.childViewController.view.topAnchor.constraint(equalTo:  item.childViewController.view.superview!.topAnchor, constant: 0.0).isActive = true
            item.childViewController.view.bottomAnchor.constraint(equalTo:  item.childViewController.view.superview!.bottomAnchor, constant: 0.0).isActive = true
            
            item.childViewController.didMove(toParent: item.parentViewController)
            item.childViewController.view.layoutIfNeeded()

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
