//
//  SingleShortButtonTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 23.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class SingleShortButtonTableViewCell: AbstractTableViewCell {

    var item: SingleShortButtonImageItem? {
        didSet {
            guard let item = item else { return }
            self.labelButton.setTitle(item.buttonTitle, for: .normal)
            self.labelImageView.image = UIImage(named: item.imageViewName)
            
            self.viewLabelButton.backgroundColor = UIColor(hexString: item.backgroundColor)
            self.labelButton.setTitleColor(UIColor(hexString: item.titleTextButton), for: .normal)
        }
    }
    
    @IBOutlet weak var labelButton: UIButton!
    @IBOutlet weak var labelImageView: UIImageView!
        
    @IBOutlet weak var viewLabelButton: UIView!
    
        override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(executeSenderFunction))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func executeSenderFunction() {
        guard let item = item else { return }
        ((item.sender as? ()-> Void)!)()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
