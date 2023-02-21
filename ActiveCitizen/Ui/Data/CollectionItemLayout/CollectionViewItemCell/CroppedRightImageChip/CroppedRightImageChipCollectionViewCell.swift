//
//  CroppedRightImageChipCollectionViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 03.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class CroppedRightImageChipCollectionViewCell: AbstractCollectionViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelChip: UILabel!
    @IBOutlet weak var labelFooter: UILabel!
    var onItemClicked: (()-> Void)?
    
    var item: CroppedRightImageChipItem? {
        didSet {
            if let item = item {
                self.imageView.kf.setImage(with: URL(string: item.imageLink))
                self.labelTitle.text = item.title
                self.labelChip.text = item.chipText
                self.onItemClicked = item.onItemClicked
                
                if let footer = item.footer {
                    self.labelFooter.text = footer
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner]
        
        let frontImage = UIImage(named: "iconImageCropForeground") // The image in the foreground
        let frontImageView = UIImageView(image: frontImage) // Create the view holding the image
        frontImageView.frame = CGRect(x: 0, y: 0, width: 72, height: 72)
        imageView.addSubview(frontImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    @objc func didTapCell(_ sender: UITapGestureRecognizer? = nil) {
        onItemClicked?()
    }
    
    override func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
    
}
