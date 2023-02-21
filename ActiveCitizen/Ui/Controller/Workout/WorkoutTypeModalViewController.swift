//
//  WorkoutTypeModalViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 22.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import CoreLocation
import DLRadioButton

class WorkoutTypeModalViewController: UIViewController {
    
    @IBOutlet weak var iconDismissController: UIImageView!
    
    weak var workoutTypePickerDelegate: WorkoutTypePickerDelegate?
    @IBOutlet weak var buttonLaunchWorkout: UIButton!
    
    var pickedActivityType: ActivityType = .PENDING
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonLaunchWorkout.alpha = 0.6
        buttonLaunchWorkout.addTarget(self, action: #selector(didTapButtonLaunchWorkout), for: .touchUpInside)

        let recognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissController))
        iconDismissController.isUserInteractionEnabled = true
        iconDismissController.addGestureRecognizer(recognizer)
    }
    
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        buttonLaunchWorkout.isEnabled = true
        buttonLaunchWorkout.alpha = 1.0

        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
            }
        } else {
            // RadioButton tag is defined as a runtime parameter in WorkoutTypeModalViewController.xib
            if let activityType = ActivityType.init(rawValue: radioButton.tag) {
                print(activityType)
                pickedActivityType = activityType
            } else {
                print("Unable to initialize ActivityType with id: \(radioButton.tag)")
            }
        }
    }
    
    @objc func didTapButtonLaunchWorkout() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied: do {
                displayGpsError()
            }
            case .authorizedAlways, .authorizedWhenInUse: do {
                workoutTypePickerDelegate?.onTypePicked(type: pickedActivityType)
                self.dismiss(animated: true, completion: nil)
            }
            @unknown default:
                break
            }
        } else {
            displayGpsError()
        }
    }
    
    private func displayGpsError() {
        let enableGeolocationHintController = ResultModalViewController()
        enableGeolocationHintController.resultTitle = "Не работает GPS"
        enableGeolocationHintController.resultDescription = "В телефоне выключена функция геолокации, поэтому данные о тренировке будут засчитаны не точно"
        enableGeolocationHintController.imageName = "iconLocationMdRes"
        enableGeolocationHintController.modalTransitionStyle = .crossDissolve
        enableGeolocationHintController.modalPresentationStyle = .currentContext
        enableGeolocationHintController.resultBottomButtonTitle = "Перейти в настройки"
        enableGeolocationHintController.view.backgroundColor = .init(white: 1.0, alpha: 0.5)
        enableGeolocationHintController.onDismiss = {
            if let appSettings = URL(string: UIApplication.openSettingsURLString  ) {                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        self.present(enableGeolocationHintController, animated: true, completion: nil)
    }
}


protocol WorkoutTypePickerDelegate : class {
    func onTypePicked(type: ActivityType)
}
