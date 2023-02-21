//
//  ElementLeftImagePreview.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import Kingfisher

class ElementLeftImagePreviewCell: AbstractTableViewCell {
    
    @IBOutlet weak var imageViewPreview: UIImageView?
    @IBOutlet weak var labelPreTitle: UILabel?
    @IBOutlet weak var labelTitle: UILabel?
    @IBOutlet weak var labelSubTitle: UILabel?
    @IBOutlet weak var labelFooter: UILabel?
    
    var item: ElementLeftImagePreviewItem? {
        didSet {
            guard let item = item else {
                return
            }
            
            let url = URL(string: item.image ?? "")
            self.imageViewPreview?.kf.setImage(with: url)
            self.labelPreTitle?.text = item.preTitle
            self.labelTitle?.text = item.title
            self.labelSubTitle?.text = item.subTitle
            self.labelFooter?.text = item.footer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hexString: "#f5f5f5")
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewPreview?.kf.cancelDownloadTask()
        imageViewPreview?.image = nil
    }
}
