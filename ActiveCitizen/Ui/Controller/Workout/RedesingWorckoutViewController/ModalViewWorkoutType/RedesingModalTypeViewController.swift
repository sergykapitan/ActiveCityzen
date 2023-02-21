//
//  RedesingModalTypeViewController.swift
//  ActiveCitizen
//
//  Created by Sergey on 10.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit
import DLRadioButton


class RedesingModalTypeViewController: UIViewController {
    
    let redesingView = RedesingModalTypeViewControllerCode()
    var workoutTypePickerDelegate: WorkoutTypePickerDelegate?
    var pickedActivityType: ActivityType = .WALKING
    
    //MARK: - LifeCicle
    override func loadView() {
        super.loadView()
        view.addSubview(redesingView)
        redesingView.centerX(inView: view)
        redesingView.centerY(inView: view)
        redesingView.anchor(width: 320, height: 480)
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        redesingView.buttonClose.addTarget(self, action: #selector(didTapButtonLaunchWorkout), for: .touchUpInside)
        let otherButtons : [DLRadioButton] = [
                                              redesingView.bicycleManView.workoutLabel,
                                              redesingView.runningManView.workoutLabel,
                                              redesingView.walkingManView.workoutLabel,
                                              redesingView.skiingManView.workoutLabel,
                                              redesingView.winterSkatingManView.workoutLabel,
                                              redesingView.homeRunningManView.workoutLabel]
        
        
        
        redesingView.homeWalkingManView.workoutLabel.otherButtons = otherButtons
        redesingView.homeWalkingManView.workoutLabel.otherButtons[2].isSelected = true
        
        redesingView.homeRunningManView.workoutLabel.addTarget(self, action: #selector(logSelectedButton), for: .touchUpInside)
        redesingView.homeWalkingManView.workoutLabel.addTarget(self, action: #selector(logSelectedButton), for: .touchUpInside)
        redesingView.bicycleManView.workoutLabel.addTarget(self, action: #selector(logSelectedButton), for: .touchUpInside)

        redesingView.runningManView.workoutLabel.addTarget(self, action: #selector(logSelectedButton), for: .touchUpInside)

        redesingView.walkingManView.workoutLabel.addTarget(self, action: #selector(logSelectedButton), for: .touchUpInside)
        redesingView.skiingManView.workoutLabel.addTarget(self, action: #selector(logSelectedButton), for: .touchUpInside)
        redesingView.winterSkatingManView.workoutLabel.addTarget(self, action: #selector(logSelectedButton), for: .touchUpInside)
      
    }

    // MARK: - Navigation
    @objc private func logSelectedButton(radioButton : DLRadioButton) {
       
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
            }
        } else {
            // RadioButton tag is defined as a runtime parameter in WorkoutTypeModalViewController.xib
            if let activityType = ActivityType.init(rawValue: radioButton.tag) {
                pickedActivityType = activityType
                workoutTypePickerDelegate?.onTypePicked(type: pickedActivityType)
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Unable to initialize ActivityType with id: \(radioButton.tag)")
            }
        }
    }

    @objc func didTapButtonLaunchWorkout() {
        workoutTypePickerDelegate?.onTypePicked(type: pickedActivityType)
        self.dismiss(animated: true, completion: nil)
    }
}
