//
//  ColoredFootersItemCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 11.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import UIKit

class ColoredFootersItemCell: AbstractTableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelFooterLeft: UILabel!
    @IBOutlet weak var labelFooterRight: UILabel!
    
    var item: ColoredFootersItem? {
        didSet {
            guard let item = item else {
                return
            }
            self.labelTitle.text = item.title
            self.labelFooterLeft.text = item.footerLeftText
            self.labelFooterRight.text = item.footerRightText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hexString: "#f5f5f5")
        self.selectionStyle = .none
    }
}
