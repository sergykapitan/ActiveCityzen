//
//  TitleBadgeChipFooterTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 28.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class TitleBadgeChipFooterTableViewCell: AbstractTableViewCell {
    
    @IBOutlet weak var imageViewBadge: UIImageView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelChip: UILabel!
    @IBOutlet weak var labelFooter: UILabel!
    
    
    var item: TitleBadgeChipFooterItem? {
        didSet {
            guard let item = item else { return }
            self.imageViewBadge.kf.setImage(with: URL(string: item.badgeImageLink))
            self.labelHeader.text = item.header
            self.labelTitle.text = item.title
            self.labelChip.text = item.chipText
            self.labelFooter.text = item.footer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
