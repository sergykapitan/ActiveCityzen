//
//  ResultModalViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 24.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class ResultModalViewController: UIViewController {

    var imageName: String = ""
    var resultTitle: String = ""
    var resultDescription: String = ""
    var resultBottomButtonTitle: String = "Закрыть"
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonDismiss: UIButton!
    
    var onDismiss: (()-> Void)?
    
    @IBAction func dismissSelf(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        imageView.image = UIImage(named: imageName)
        labelTitle.text = resultTitle
        labelDescription.text = resultDescription
        buttonDismiss.setTitle(resultBottomButtonTitle, for: .normal)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            onDismiss?()
        }
    }
}
