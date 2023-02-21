//
//  TitlePromocodeDescriptionViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 05.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class TitlePromocodeDescriptionViewController: UIViewController {

    public var header = ""
    public var promocodeHeader = ""
    public var promocode = ""
    public var promocodeFooter = ""
    public var buttonText = ""
    public var buttonOnClick: (()-> Void)? = nil
    
    @IBOutlet weak var imageViewCross: UIImageView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var labelPromocodeHeader: UILabel!
    @IBOutlet weak var labelPromocode: UILabel!
    @IBOutlet weak var labelPromocodeFooter: UILabel!
    @IBOutlet weak var buttonBottom: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelHeader.text = header
        self.labelPromocodeHeader.text = promocodeHeader
        self.labelPromocode.text = promocode
        self.labelPromocodeFooter.text = promocodeFooter
        self.buttonBottom.setTitle(buttonText, for: .normal)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapButtonClosed))
        gestureRecognizer.numberOfTapsRequired = 1
        self.imageViewCross.isUserInteractionEnabled = true
        self.imageViewCross.addGestureRecognizer(gestureRecognizer)
        self.buttonBottom.addTarget(self, action: #selector(tapButtonBottom), for: .touchUpInside)
    }
    
    @objc func tapButtonBottom() {
        buttonOnClick?()
    }
    
    @objc func tapButtonClosed() {
        self.dismiss(animated: true, completion: nil)
    }
}
