//
//  TutorialViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 26.05.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: BaseViewController {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    
    var tutorialTitle: String = ""
    var tutorialDescription: String = ""
    var tutorialImage: UIImage? = nil
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.init(hexString: "#F5F5F5")

        self.labelTitle.text = tutorialTitle
        self.labelDescription.text = tutorialDescription
        self.imageView.image = tutorialImage
        
        print("tutorial view controller view did load")
        print(tutorialTitle)
    }
}
