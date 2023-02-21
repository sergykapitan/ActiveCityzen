//
//  NarrowImageTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 25.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class NarrowImageTableViewCell: AbstractTableViewCell {

    var item: NarrowImageItem? {
        didSet {
            guard let item = item else { return }
            guard let url = URL(string: item.imageLink) else { return }
            narrowImageView.getImageByURL(url: url)
          //  narrowImageView.kf.setImage(with: URL(string: item.imageLink))
        }
    }
    @IBOutlet weak var narrowImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
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
        
        gradientLayer.bounds = narrowImageView.bounds.insetBy(dx: -0.5*narrowImageView.bounds.size.width, dy: -0.5*narrowImageView.bounds.size.height)

        gradientLayer.position = narrowImageView.center
        narrowImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
