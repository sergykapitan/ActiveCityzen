//
//  SmsAuthViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 07.07.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import UIKit

class SendCodeToPhoneNumberController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    private let errorMessage = UILabel()
    
    @IBOutlet weak var sendPhoneNumberButton: UIButton!
    
    private var userPhoneNumber: String = ""
    
    @Inject
    var citizenApi: CitizenAPI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.delegate = self
        setupErrorMessage()
        phoneNumberTextField.addTarget(self, action: #selector(SendCodeToPhoneNumberController.textFieldDidChange(_:)), for: .editingChanged)
        sendPhoneNumberButton.addTarget(self, action: #selector(SendCodeToPhoneNumberController.sendPhoneNumberButtonPressed), for: .touchUpInside)
        sendPhoneNumberButton.isEnabled = phoneNumberTextField.text != nil && phoneNumberTextField.text!.isValidEmail()
        
    }
    
    func setupErrorMessage() {
        errorMessage.translatesAutoresizingMaskIntoConstraints = false
        errorMessage.text = "Номер введен неправильно"
        errorMessage.font = errorMessage.font.withSize(10.0)
        errorMessage.textColor = UIColor(hexString: "#DD324A")
        errorMessage.isHidden = true
        self.view.addSubview(errorMessage)
        
        errorMessage.leadingAnchor.constraint(equalTo: phoneNumberTextField.leadingAnchor, constant: 16.0).isActive = true
        errorMessage.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 4.0).isActive = true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            guard let text = textField.text else { return false }
            sendPhoneNumberButton.isEnabled = true
            let numberStringValue = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = numberStringValue.formattedNumber()
            return false
        } else {
            sendPhoneNumberButton.isEnabled = false
        }
        return true
    }
    
    @objc private func sendPhoneNumberButtonPressed() {
        let enteredPhoneNumber = PhoneNumber(phone: "+\(phoneNumberTextField.text!.digits)")
        self.citizenApi.sendSmsToPhoneNumber(phoneNumber: enteredPhoneNumber).subscribe(onNext: {    result in
            if result.isSend {
                self.userPhoneNumber = enteredPhoneNumber.phone
                self.performSegue(withIdentifier: "fromSendCodeVCtoSmsConfirmationController", sender: nil)
            }
            print(result)
        }, onError: {error in
            self.userPhoneNumber = ""
            print(error)
        })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        sendPhoneNumberButton.isEnabled = textField.text != nil && textField.text!.isValidEmail()
        if UIScreen.main.bounds.height < 670 {
               UIView.animate(withDuration: 0.2, animations: {
                       self.view.bounds.origin.y = 150
                   })
               }
    }
   
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if UIScreen.main.bounds.height < 670 {
        UIView.animate(withDuration: 0.2, animations: {
                self.view.bounds.origin.y = 0
            })
        }
    }
    
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let isPhoneNumberEntered = textField.text != nil && textField.text!.isValidEmail()
        errorMessage.isHidden = isPhoneNumberEntered
        sendPhoneNumberButton.isEnabled = isPhoneNumberEntered
        userPhoneNumber = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "fromSendCodeVCtoSmsConfirmationController":
            let targetController = segue.destination as! SmsConfirmationViewController
            targetController.userPhoneNumber = userPhoneNumber
            
        default:
            print("Segue identifier \"\(String(describing: segue.identifier)) not found")
        }
    }
}
