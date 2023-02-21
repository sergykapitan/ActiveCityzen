//
//  StartTrainingUserViewController.swift
//  ActiveCitizen
//
//  Created by Sergey on 29.03.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonDelegate: class {
    func onButtonTap()
}
class StartTrainingUserViewController: UIViewController {
    
    let startTranning = StartTrainingUserViewControllerCode()
    weak var delegate: ButtonDelegate?
    
    //MARK: - LifeCicle
    override func loadView() {
        super.loadView()
        view = startTranning
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // tabBarController?.tabBar.isUserInteractionEnabled = false
        //    .userInteractionEnabled
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     //   tabBarController?.tabBar.isHidden = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        view.backgroundColor =  UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 0.64)
        actionButton()
       
    }
    // MARK: - Metods
    func actionButton() {
       // UserDefaults.standard.set(false, forKey: "startWorkout")
        startTranning.descriptionView.startButton.addTarget(self, action: #selector(dissmisView), for: .touchUpInside)
        
    }
    //MARK: - Selectors
    @objc func dissmisView() {
        self.dismiss(animated: true) {
            self.delegate?.onButtonTap()
        }
    }
    
    
    
}
