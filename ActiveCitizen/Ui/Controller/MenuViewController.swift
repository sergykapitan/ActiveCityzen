//
//  MenuViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 29.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import ZendeskCoreSDK
import SupportSDK
import Photos
import YandexMobileMetrica

class MenuViewController: BaseViewController {
    
    @IBOutlet weak var buttonAboutApp: UIButton!
    @IBOutlet weak var buttonAddSmartband: UIButton!
    @IBOutlet weak var buttonDobromarketOrders: UIButton!
    @IBOutlet weak var buttonLogout: UIButton!
    weak var delegate: ButtonDelegate?
    
    @IBAction func didTapButtonFeedback(_ sender: Any) {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = Constants.webViewPwa + "/feedback"
        self.navigationController?.pushViewController(helpWebViewController, animated: true)
   
    }
    
    @IBAction func didTapButtonHelp(_ sender: Any) {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = Constants.webViewPwa + "/faq_ios"
        self.navigationController?.pushViewController(helpWebViewController, animated: true)
        
    }
  
    @IBOutlet weak var labelAppVersion: UILabel!
    
    override func viewDidLoad() {
        
        delegate = MainViewController()
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildVersionNumber: String? = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: " ", style: .plain, target: nil, action: nil)
        
        self.labelAppVersion.text = "Версия приложения: \(appVersion ?? "") (\(buildVersionNumber ?? ""))"
        
        self.buttonAboutApp.addTarget(self, action: #selector(openAboutApp), for: .touchUpInside)
        self.buttonAddSmartband.addTarget(self, action: #selector(connectGarminSmartband), for: .touchUpInside)
        self.buttonLogout.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    @objc func openAboutApp() {
        let webViewController = WebViewController()
        webViewController.url = Constants.webViewPwa + "/about"
        webViewController.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: " ", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @objc func connectGarminSmartband() {
        
        self.present(GarminConnectionViewController(), animated: true, completion: nil)
    }
    
    @objc func logout() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "OnboardingViewController")
        UserDefaults.standard.removeObject(forKey: Constants.accessTokenKeyUserDefaults)
        appDelegate.window!.rootViewController = viewController
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func coachMarkStart(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "launchedBefore")
        _ = self.tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openMenuViewController()
    }
    func openMenuViewController() {
    YMMYandexMetrica.reportEvent("Открытие Меню", onFailure: { (error) in
        print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
