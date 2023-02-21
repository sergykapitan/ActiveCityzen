//
//  OnboardingViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 27.05.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import YandexMobileMetrica

class OnboardingViewController: BaseViewController {
    
    var tutorialPageViewController: TutorialPageViewController?
    
    @IBAction func skipOnboarding(_ sender: Any) {
        self.tutorialPageViewController?.skipTutorial()
    }
    
    @IBAction func nextOnboardingPage(_ sender: Any) {
        self.tutorialPageViewController?.nextTutorialPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hexString: "#F5F5F5")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openOnboardingViewController()
    }
    
    func openOnboardingViewController() {
        YMMYandexMetrica.reportEvent("Открытие онборда") { (error) in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "openTutorialPageViewController": do {
            self.tutorialPageViewController = segue.destination as? TutorialPageViewController
            
        }
            
        default:
            return
        }
    }
    
    
}
