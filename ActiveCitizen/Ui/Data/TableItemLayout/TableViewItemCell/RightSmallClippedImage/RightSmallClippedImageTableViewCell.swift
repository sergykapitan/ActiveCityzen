//
//  RightSmallClippedImageTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 02.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class RightSmallClippedImageTableViewCell: AbstractTableViewCell {
    
    @IBOutlet weak var imageViewRight: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelChip: UILabel!
    
    @IBOutlet weak var labelFooter: UILabel!
    var onItemClicked: (()-> Void)?
    
    var item: RightSmallClippedImageItem? {
        didSet {
            guard let item = item else { return }
            self.imageViewRight.kf.setImage(with: URL.init(string: item.imageLink ?? ""))
            self.labelTitle.text = item.title
            self.labelSubtitle.text = item.subtitle
            self.labelChip.text = item.chipText
            self.onItemClicked = item.onItemClicked
            self.labelFooter.text = item.footer ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor(hexString: "#f5f5f5")
        
        imageViewRight.clipsToBounds = true
        imageViewRight.layer.cornerRadius = 8
        imageViewRight.layer.maskedCorners = [.layerMaxXMinYCorner]

        let frontImage = UIImage(named: "iconImageCropForeground") // The image in the foreground
        let frontImageView = UIImageView(image: frontImage) // Create the view holding the image
        frontImageView.frame = CGRect(x: 0, y: 0, width: 72, height: 72)
        
        self.imageViewRight.addSubview(frontImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)}
    
    @objc func didTapCell(_ sender: UITapGestureRecognizer? = nil) {
        onItemClicked?()
    }
}
