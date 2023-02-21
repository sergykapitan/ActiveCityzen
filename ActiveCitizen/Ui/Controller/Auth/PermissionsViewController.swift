//
//  PermissionsViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.07.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import HealthKit
import CoreLocation
import CoreMotion
import YandexMobileMetrica
import AppTrackingTransparency
import AdSupport


class PermissionsViewController: BaseViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let healthStore = HKHealthStore()
    let motionActivityManager = CMMotionActivityManager()
    
    @IBAction func didTouchButtonNextPermissionsController(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: Constants.hasUserEnteredQuizData) {
            self.performSegue(withIdentifier: "fromPermissionsToMainVC", sender: nil)
        } else {
            self.performSegue(withIdentifier: "fromPermissionsToProfileQuizVC", sender: nil)
        }
    }
    
    @IBOutlet var permissionsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPermission()
        locationManager.delegate = self
        let permissionViewGeolocation = PermissionView.instanceFromNib() as! PermissionView
        permissionViewGeolocation.setTitle(titleString: "Геолокация")
        permissionViewGeolocation.setDescription(descriptionString: "Разреши доступ к геопозиции и получай баллы за ходьбу")
        permissionViewGeolocation.setPermissionImage(image: R.image.iconGeolocationSymbol()!)
        
        let permissionViewSensors = PermissionView.instanceFromNib() as! PermissionView
        permissionViewSensors.setTitle(titleString: "Движение")
        permissionViewSensors.setDescription(descriptionString: "Доступ к этой информации необходим для определения характера активности")
        permissionViewSensors.setPermissionImage(image: R.image.iconRunningMan()!)
        
        let permissionViewAppleHealth = PermissionView.instanceFromNib() as! PermissionView
        permissionViewAppleHealth.setTitle(titleString: "Apple Health")
        permissionViewAppleHealth.setDescription(descriptionString: "Доступ к этой информации позволит нашему приложению получить данные о физической активности")
        permissionViewAppleHealth.setPermissionImage(image: R.image.iconAppleHealth()!)
        
        self.permissionsStackView.addArrangedSubview(permissionViewGeolocation)
        self.permissionsStackView.addArrangedSubview(permissionViewSensors)
        self.permissionsStackView.addArrangedSubview(permissionViewAppleHealth)
        
        permissionViewGeolocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(requestLocationPermission(sender:))))
        
        permissionViewAppleHealth.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(requestHealthKitPermission(sender:))))
        
        permissionViewSensors.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(requestMotionAndFitnessPermission(sender:))))
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openPermissionsViewController()

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
            (self.permissionsStackView.subviews[0] as! PermissionView).isCheckMarkHidden = false
        }
    }
    
    @objc func requestMotionAndFitnessPermission(sender: UITapGestureRecognizer) {
        motionActivityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { activity in
            print("Dummy query to prompt permission from user")
            (self.permissionsStackView.subviews[1] as! PermissionView).isCheckMarkHidden = false
            self.motionActivityManager.stopActivityUpdates()
        })
        
    }
    
    @objc func requestHealthKitPermission(sender: UITapGestureRecognizer) {
        let hkTypes = Set([HKObjectType.workoutType(),
                           HKObjectType.quantityType(forIdentifier: .stepCount)!,
                           HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                           HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])
        
        healthStore.requestAuthorization(toShare: hkTypes, read: hkTypes) { (success, error) in
            if !success {
                print(error)
            } else {
                DispatchQueue.main.async {
                    (self.permissionsStackView.subviews[2] as! PermissionView).isCheckMarkHidden = false
            }
        }
        }}
    
    @objc func requestLocationPermission(sender: UITapGestureRecognizer) {
        let locStatus = CLLocationManager.authorizationStatus()
        switch locStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            return
        case .denied, .restricted:
            let alert = UIAlertController(title: "Геолокация отключена", message: "Пожалуйста,  включите геолокацию в настройках", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    func openPermissionsViewController() {
    YMMYandexMetrica.reportEvent("Открытие экрана Настрой работу приложения", onFailure: { (error) in
        print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    //NEWLY ADDED PERMISSIONS FOR iOS 14
    func requestPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    
                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
}
