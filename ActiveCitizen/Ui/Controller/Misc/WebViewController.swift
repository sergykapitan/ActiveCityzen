//
//  WebViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 29.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate  {
    
    @IBOutlet weak var webKitView: WKWebView!
    @IBOutlet weak var webviewErrorViewContainer: UIView!
    
    var url: String? = nil
    var checkInternet = true
    private var keyValueObservations: [NSKeyValueObservation] = []
    var urlTitles: String = ""
    
    @IBAction func retryLoadingWebPage(_ sender: Any) {
        if webKitView.isHidden {
            webKitView.isHidden = false
        }
        
        if let webPageUrl = URL(string: url ?? "") {
            print("webPageUrl = \(webPageUrl)")
            loadPage(url: webPageUrl)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        webKitView.navigationDelegate = self
        webKitView.uiDelegate = self
        webKitView.configuration.preferences.javaScriptEnabled = true
        webKitView.allowsBackForwardNavigationGestures = true
        
        if let webPageUrl = URL(string: url ?? "") {
            loadPage(url: webPageUrl)
        }
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backButton"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        keyValueObservations.append(webKitView.observe(\.url, options: [.new]) { [weak self] _, change in
            guard let url = change.newValue else { return }
                let strUrl = "\(String(describing: url))"
                let separators = CharacterSet(charactersIn: "/,?,&")
                let items = strUrl.components(separatedBy: separators)
            if items.count > 4 && items[3] == "district_rating_details"{
                self?.navigationItem.title = self?.returnTitle(item: items[4])
            }
   
        })
        keyValueObservations.append(webKitView.observe(\.title, options: [.new]) { [weak self] _, change in
            guard let urlTitle = change.newValue else { return }
 
                self?.navigationItem.title = urlTitle
            
        })
    }
    @objc func back() {
        if(webKitView.canGoBack) {
            let urlDistrict = URL(string: Constants.urlDistrictConstant)
            if webKitView.url == urlDistrict {
                self.navigationController?.popViewController(animated:true)
            }
            webKitView.goBack()
            } else {
                self.navigationController?.popViewController(animated:true)
            }
        }
    
    private func loadPage(url: URL) {
        let urlRequest = URLRequest.init(url: url, cachePolicy:  .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        webKitView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            webKitView.isHidden = checkInternet
    
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("err")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false      
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
   //MARK: - NavigationWKWebView
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (@escaping (WKNavigationActionPolicy) -> Void)) {
        switch navigationAction.navigationType {
        case .other:
            let str = "\(navigationAction.request)"
            let items = str.components(separatedBy: "/")
            if items.first == "acitizen:" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let dobromarketOrderVC = storyboard.instantiateViewController(withIdentifier: "DMOrder") as! DobromarketOrderViewController
                guard let order = items.last?.toInt() else { return }
                dobromarketOrderVC.orderId = order
                checkInternet = false
                navigationController?.pushViewController(dobromarketOrderVC , animated: true)
                      
            }
        default:
            break
        }
        decisionHandler(.allow)
    }
    private func returnTitle (item: String) -> String {
        var title = ""
        if item == "activity=activityRate"{
            title = "Активный"
        }
        if item == "activity=runRate"{
            title = "Бегущий"
        }
        if item == "activity=homeRate"{
            title = "Домашний"
        }
        if item == "activity=cycleRate"{
            title = "Велосипедный"
        }
        if item == "activity=morningRate"{
            title = "Жаворонки"
        }
        return title
    }
}
