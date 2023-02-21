//
//  TextBoxTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 18.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class TextBoxTableViewCell: AbstractTableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTextBody: UILabel!
    
    var item: TextBoxItem? {
        didSet {
            guard let item = item else { return }
            self.labelTitle?.text = item.title
            self.labelTextBody.text = item.body
            self.labelTextBody.sizeToFit()
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor(hexString: "#f5f5f5")
    }
}
