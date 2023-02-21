//
//  BigImageTitleFooterTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 18.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import Kingfisher

class BigImageTitleFooterTableViewCell: AbstractTableViewCell {
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelFooter: UILabel!
    
    var item: BigImageTitleFooterItem? {
        didSet {
            imageViewBackground.kf.setImage(with: URL(string: item?.imageLink ?? ""))
            labelTitle.text = item?.title
            labelFooter.text = item?.footer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        addGradientToImageView()
    }
    
    func addGradientToImageView() {
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 0.24).cgColor,
        UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 0).cgColor,
        UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1).cgColor]
        
        gradientLayer.locations = [0, 0.34, 1]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        
        gradientLayer.bounds = imageViewBackground.bounds.insetBy(dx: -0.5*imageViewBackground.bounds.size.width, dy: -0.5*imageViewBackground.bounds.size.height)

        gradientLayer.position = imageViewBackground.center
             imageViewBackground.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewBackground.image = nil
    }
}
