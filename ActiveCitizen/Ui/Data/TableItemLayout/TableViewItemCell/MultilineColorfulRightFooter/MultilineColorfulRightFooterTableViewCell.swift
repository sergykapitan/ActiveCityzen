//
//  MultilineColorfulRightFooterTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 09.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class MultilineColorfulRightFooterTableViewCell: AbstractTableViewCell {

    var item: MultilineColorfulRightFooterItem? {
        didSet {
            guard let item = item else { return }
            self.labelPreTitle.text = item.preTitle
            self.labelTitle.text = item.title
            self.labelSubtitle.text = item.subTitle
            self.labelColorfulFooter.text = item.colorfulFooterText
            self.contentView.alpha = CGFloat(item.transparency)
        }
    }
    
    @IBOutlet weak var labelPreTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelColorfulFooter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
