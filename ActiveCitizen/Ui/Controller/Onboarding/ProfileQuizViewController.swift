//
//  ProfileQuizViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 21.07.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import DLRadioButton
import YandexMobileMetrica

class ProfileQuizViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var radioButtonFemaleProfileQuiz: DLRadioButton!
    @IBOutlet weak var radioButtonMaleProfileQuiz: DLRadioButton!
    
    
    @IBOutlet weak var textFieldAgeProfieQuiz: UITextField!
    @IBOutlet weak var textFieldHeightProfieQuiz: UITextField!
    @IBOutlet weak var textFieldWeightProfieQuiz: UITextField!
    
    @IBOutlet weak var buttonDidFillRequiredFieldsProfileQuiz: UIButton!
    
    @Inject var citizenApi: CitizenAPI
    
    var gender: Bool? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.textFieldAgeProfieQuiz.delegate = self
        self.textFieldAgeProfieQuiz.addTarget(self, action: #selector(didChangeTextFieldValue), for: .editingChanged)
        
        self.textFieldHeightProfieQuiz.delegate = self
        self.textFieldHeightProfieQuiz.addTarget(self, action: #selector(didChangeTextFieldValue), for: .editingChanged)
        
        self.textFieldWeightProfieQuiz.delegate = self
        self.textFieldWeightProfieQuiz.addTarget(self, action: #selector(didChangeTextFieldValue), for: .editingChanged)
        
        self.buttonDidFillRequiredFieldsProfileQuiz.addTarget(self, action: #selector(submitEnteredQuizInformation), for: .touchUpInside)
        
        self.radioButtonFemaleProfileQuiz.addTarget(self, action: #selector(didUpdateGenderRadioButton), for: .touchUpInside)
        self.radioButtonMaleProfileQuiz.addTarget(self, action: #selector(didUpdateGenderRadioButton), for: .touchUpInside)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openProfileQuizViewController()
    }
    
    @objc func submitEnteredQuizInformation() {
        let phoneModel = UIDevice.modelName
        citizenApi.updateProfile(profile: Profile(birthDate: "\(textFieldAgeProfieQuiz.text!)-01-01", height: Int(self.textFieldHeightProfieQuiz.text!)!, sex: gender!, weight: Int(self.textFieldWeightProfieQuiz.text!)!, vendor: "Apple", model: phoneModel, os: "iOS \(UIDevice.current.systemVersion)")).subscribe(onNext: { result in
            UserDefaults.standard.set(true, forKey: Constants.hasUserEnteredQuizData)
            self.performSegue(withIdentifier: "fromProfileQuizToMainTabBarC", sender: nil)
        }, onError: {error in
            print(error)
            }).disposed(by: disposeBag)
    }
    
    @objc func didUpdateGenderRadioButton() {
        self.gender = self.radioButtonMaleProfileQuiz.isSelected
        checkShouldEnableSubmitButton()
    }
    
    @objc func didChangeTextFieldValue(sender: UITextField) {
        checkShouldEnableSubmitButton()
    }
    private func checkShouldEnableSubmitButton() {
        buttonDidFillRequiredFieldsProfileQuiz.isEnabled = textFieldAgeProfieQuiz.text != "" && textFieldHeightProfieQuiz.text != ""  && textFieldWeightProfieQuiz.text != "" && Int(textFieldAgeProfieQuiz.text ?? "0")! > 1900 && gender != nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
        if newText == "" {
            return true
        }
        var textFieldCeiling = 0
        switch textField {
        case textFieldAgeProfieQuiz:
            textFieldCeiling = Calendar.current.component(.year, from: Date())
            break
        case textFieldHeightProfieQuiz:
            textFieldCeiling = 230
            break
        case textFieldWeightProfieQuiz:
            textFieldCeiling = 400
            break
        default:
            print("Unknown text field")
        }
        if let num = Int(newText), num >= 0 && num <= textFieldCeiling {
            return true
        } else {
            return false
        }
    }
    
    func openProfileQuizViewController() {
    YMMYandexMetrica.reportEvent("Открытие экрана Пол,возраст,вес", onFailure: { (error) in
        print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
