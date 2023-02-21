//
//  SingleButtonTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 22.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class SingleButtonTableViewCell: AbstractTableViewCell {

    @IBOutlet weak var button: UIButton!
    var item: SingleButtonItem? {
        didSet {
            self.button.setTitle(item?.title, for: .normal)
            self.button.backgroundColor = UIColor(hexString: item?.backgroundColor ??  "#6181F2")
            self.button.setTitleColor(UIColor(hexString: item?.textColor ?? "FFFFFF"), for:.normal )
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor(hexString: "#f5f5f5")
    }
}
