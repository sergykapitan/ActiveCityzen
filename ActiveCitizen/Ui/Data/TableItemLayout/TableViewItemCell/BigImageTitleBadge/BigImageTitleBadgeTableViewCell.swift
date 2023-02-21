//
//  BigImageTitleBadgeTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 24.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import Kingfisher

class BigImageTitleBadgeTableViewCell: AbstractTableViewCell {
   
    var item: BadgeImageTitleItem? {
        didSet {
            guard let item = item else { return }
            guard let url = URL(string: item.imageViewHeaderLink) else { return }
            imageViewHeader.getImageByURL(url: url)
          //  imageViewHeader.kf.setImage(with: URL(string: item.imageViewHeaderLink))
            imageViewBadge.kf.setImage(with: URL(string: item.imageViewBadgeLink))
            labelPreTitle.text = item.preTitle
            labelTitle.text = item.title
            labelTitle.sizeToFit()
            labelChip.text = item.chipText
            labelFooter.text = item.footer
        }
    }
    
    @IBOutlet weak var imageViewHeader: UIImageView!
    @IBOutlet weak var imageViewBadge: UIImageView!
    @IBOutlet weak var labelPreTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelChip: UILabel!
    @IBOutlet weak var labelFooter: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor(hexString: "#00000000")
        imageViewBadge.layer.cornerRadius = 4
        imageViewBadge.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
    }
}
