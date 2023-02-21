//
//  DobrorubleOauthViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 17.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import WebKit

class DobrorubleOauthViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func retryLoadingWebPage(_ sender: Any) {
        if webView.isHidden {
            webView.isHidden = false
        }
        loadOAuthPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
        webView.configuration.preferences.javaScriptEnabled = true
        loadOAuthPage()
    }
    
    private func loadOAuthPage() {
        var oAuthLink = ""
        #if DEBUG
        oAuthLink = "https://nnolen-staging.dev.ladcloud.ru/oauth?client_id=836aef52-6247-4867-9368-e915745e6948&response_type=code&scope=druble.read&redirect_uri=https://dev.acitivzen.ru/dev/api/v1/dobroAuthCallback"
        #else
        oAuthLink = "https://nn-card.ru/oauth?client_id=a2859647-1452-4aee-805b-aed27fd8c891&response_type=code&scope=druble.read&redirect_uri=https://auth.acitizen.ru/api/v1/dobroAuthCallback"
        #endif
        
        let urlRequest = URLRequest.init(url: URL(string: oAuthLink)!, cachePolicy:  .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        self.webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .other {
            if navigationAction.request.url != nil &&
                (navigationAction.request.url!.path == "/dev/api/v1/dobroAuthCallback" ||  navigationAction.request.url!.path == "/api/v1/dobroAuthCallback"){
                let requestUrl = navigationAction.request.url!.absoluteString
                let accessToken = requestUrl.getQueryStringParameter(parameterName: "token")
                if accessToken != nil {
                    UserDefaults.standard.set(accessToken, forKey: Constants.accessTokenKeyUserDefaults)
                    self.performSegue(withIdentifier: "fromDobrorubleOauthToPermissionsVC", sender: nil)
                }
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        decisionHandler(.allow)
        return
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webView.isHidden = true
    }
}

