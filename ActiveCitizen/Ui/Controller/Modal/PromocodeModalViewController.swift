//
//  PromocodeModalViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 20.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class PromocodeModalViewController: UIViewController {
    
    var promocode: String? = nil
    
    @IBOutlet weak var labelPromocode: UILabel?
    @IBOutlet weak var buttonCloseViewController: UIButton?
    
    @IBOutlet weak var viewControllerBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerBackground.clipsToBounds = true
        self.viewControllerBackground.layer.cornerRadius = 8
        self.viewControllerBackground.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        self.labelPromocode?.text = promocode
        self.buttonCloseViewController?.addTarget(self, action: #selector(tapButtonClosed), for: .touchUpInside)
    }
    
    @objc func tapButtonClosed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = view.frame.size
    }
}
