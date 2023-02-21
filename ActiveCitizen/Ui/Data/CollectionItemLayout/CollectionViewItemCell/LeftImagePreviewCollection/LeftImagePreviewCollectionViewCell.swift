//
//  LeftImagePreviewCollectionViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 26.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class LeftImagePreviewCollectionViewCell: AbstractCollectionViewCell {

    @IBOutlet weak var imageViewPreviewLeft: UIImageView!
    @IBOutlet weak var labelPreTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelFooter: UILabel!
    
    var item: ElementLeftImagePreviewCollectionItem? {
          didSet {
              guard let item = item else {
                  return
              }
              
              let url = URL(string: item.image ?? "")
              self.imageViewPreviewLeft?.kf.setImage(with: url)
              self.labelPreTitle?.text = item.preTitle
              self.labelTitle?.text = item.title
              self.labelSubtitle?.text = item.subTitle
              self.labelFooter?.text = item.footer
          }
      }
}
