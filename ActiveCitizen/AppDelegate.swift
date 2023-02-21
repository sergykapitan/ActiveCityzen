//
//  AppDelegate.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 03/07/2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

import UIKit
import Realm
import YandexMapKit
import ZendeskCoreSDK
import SupportSDK
import YandexMobileMetrica


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    @Inject private var physicalActivityService: PhysicalActivityService
    
    override init() {
        super.init()
        let appDependencies = Dependencies { Module { MotionProvider() }
            Module { CitizenAPI() }
            Module { PhysicalActivityService() }
            Module { WorkoutDataHandlerFactory() }
            Module { HealthProvider() }
        }
        appDependencies.build()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Determine if the user is authorized
        if UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults) != nil {
            openRootViewController(storyboardName: "Main", withId: "MainTabBarController")
        } else { openRootViewController(storyboardName: "Main", withId: "OnboardingViewController") }
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(1200)
        
        YMKMapKit.setApiKey("a48247ba-826d-469c-8b49-d43041ea402d")
        Zendesk.initialize(appId: "d1874bc7c4b5e434446dbdf381299a6ca32f08e8980e7261",
            clientId: "mobile_sdk_client_01ea349b4b2efd3bb5a4",
            zendeskUrl: "https://novotorica.zendesk.com")
        Support.initialize(withZendesk: Zendesk.instance)
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "12a103bc-6dab-4be8-930c-655224962752")
        if UserDefaults.standard.bool(forKey: Constants.appMetricaKey) {
            configuration?.statisticsSending = true
        } else {
            configuration?.statisticsSending = false
        }
        print("CONFIGURE ======= \(configuration?.statisticsSending)")
        YMMYandexMetrica.activate(with: configuration!)

        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogout), name: .didLogout, object: nil)
        return true 
    }
    
    @objc func onDidLogout() {
        DispatchQueue.main.async {
            self.openRootViewController(storyboardName: "Main", withId: "OnboardingViewController")
        }
    }
    
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void) {
        
        self.physicalActivityService.uploadLatestActivities(){ success in
            if success {
                completionHandler(.newData)} else {
                completionHandler(.noData)
            }
            
        }
    }
    
    //MARK: - YndexMetrica Universal Link
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return YMMYandexMetrica.handleOpen(url)
    }

    private func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return YMMYandexMetrica.handleOpen(url)
    }

    // Delegate for tracking Universal links.
    private func application(_ application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                YMMYandexMetrica.handleOpen(url)
            }
        }
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self)
    }
    
    /** Lets us set the Initial View Controller programmatically.
     - Parameter storyboardName: The name of the storyboard which contains our UIViewController.
     - Parameter viewControllerId: The Storyboard ID of required UIViewController.
     */
    func openRootViewController(storyboardName: String, withId viewControllerId: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewControllerId)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
}
