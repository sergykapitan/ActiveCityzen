//
//  MultilineSpannedTextTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 08.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class MultilineSpannedTextTableViewCell: AbstractTableViewCell {

    @IBOutlet weak var imageViewTop: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle1: UILabel!
    @IBOutlet weak var labelSubtitle2: UILabel!
    @IBOutlet weak var labelFooter: UILabel!
    @IBOutlet weak var labelBottomCaption: UILabel!
    
    var item: MultilineSpannedTextBoxItem? {
        didSet {
            guard let item = item else { return }
            self.labelTitle.text = item.title
            self.labelSubtitle1.text = item.subtitle1
            self.labelSubtitle2.text = item.subtitle2
            self.labelFooter.text = item.footer
            self.labelBottomCaption.text = item.bottomCaption
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
