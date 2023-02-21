//
//  PermissionView.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.07.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import UIKit

class PermissionView: UIView {
    
    @IBOutlet weak var permissionImageView: UIImageView!
    @IBOutlet weak var permissionTitle: UILabel!
    @IBOutlet weak var permissionDescription: UILabel!
    @IBOutlet weak var switchIndicator: UISwitch!
    
    var isCheckMarkHidden = true {
        didSet {
            self.switchIndicator?.setOn(!isCheckMarkHidden, animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.switchIndicator.isUserInteractionEnabled = false
    }
    
    func setTitle(titleString: String) {
        permissionTitle.text = titleString
    }
    
    func setDescription(descriptionString: String) {
        permissionDescription.text = descriptionString
    }
    
    func setPermissionImage(image: UIImage) {
        permissionImageView.image = image
    }
  
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PermissionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
