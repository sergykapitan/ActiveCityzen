//
//  GarminConnectionViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 23.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import WebKit

class GarminConnectionViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navigationBar: UINavigationBar!

    
    
    override func viewWillLayoutSubviews() {
        createNavBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.configuration.preferences.javaScriptEnabled = true

        let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)!
        var link = ""
        #if DEBUG
        link = "https://dev.acitivzen.ru/devices/?token=\(token)"
        #else
        //New Way
        link = Constants.webViewPwa + "/trackers/?token=\(token)"
        //Old Way
       // link = "https://devices.acitizen.ru/?token=\(token)"
        #endif
        guard let url = URL(string: link ?? "") else { return }
        let request = URLRequest(url: url)
        webView.load(request)

    }
    private func createNavBar() {
        
        let closeController = UIBarButtonItem(image: #imageLiteral(resourceName: "iconCrossGray"), style: .plain, target: self, action: #selector(dissmissController))
        navigationItem.leftBarButtonItem = closeController
        navigationItem.title = webView.title
        navigationBar.setItems([navigationItem], animated: false)
        
    }
    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation!) {
        self.navigationItem.title = webView.title
    
        
    }
    @objc func dissmissController() {
        self.dismiss(animated: true, completion: nil)
    }

}
