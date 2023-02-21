//
//  AlertViewController.swift
//  ActiveCitizen
//
//  Created by Sergey on 29.01.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit
class AlertViewController: UIViewController {
    
    
    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.cornerRadius = 6
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
 
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        if Connectivity.isConnectedToInternet {
            alertView.isHidden = true
            navigationController?.popViewController(animated: true)
            } else {
              print("No Internet")               
            }
      }
}

