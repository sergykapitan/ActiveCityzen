//
//  ExpandableTextBoxTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 08.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import ExpandableLabel

class ExpandableTextBoxTableViewCell: AbstractTableViewCell,  ExpandableLabelDelegate {
   
    func willExpandLabel(_ label: ExpandableLabel) {
        UIView.animate(withDuration: 0.5, animations: {
            (self.superview as! UITableView).reloadData()
        })
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        UIView.animate(withDuration: 0.5, animations: {
            (self.superview as! UITableView).reloadData()
        })
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
    
    }
    

    @IBOutlet weak var labelPreTitle: UILabel!
    @IBOutlet weak var labelExpandableBody: ExpandableLabel!
    
    var item: ExpandableTextBoxItem? {
        didSet {
            guard let item = item else { return }
            labelPreTitle.text = item.preTitle
            labelExpandableBody.delegate = self
            labelExpandableBody.text = item.expandableBody
            labelExpandableBody.ellipsis = NSAttributedString(string: "...")
            let font = UIFont.boldSystemFont(ofSize: 14.0)
            labelExpandableBody.collapsedAttributedLink = NSAttributedString(string: item.collapsedAttributedLink, attributes: [.font : font])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelExpandableBody.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
