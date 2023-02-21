//
//  SmsConfirmationViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 09.07.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import RxSwift

class SmsConfirmationViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelDescriptionSmsConfirmationViewController: UILabel!
    
    @IBOutlet weak var buttonLoginSmsConfirmationController: UIButton!
    @IBOutlet weak var buttonResendCodeSmsConfirmationViewController: UIButton!
    
    @IBOutlet weak var textFieldSmsCodeSmsConfirmationController: UITextField!
    
    @IBOutlet weak var labelSmsCodeResendCaption: UILabel!
    
    @IBOutlet var labelSmsCodeResendTopToButtonSend: NSLayoutConstraint!
    
    @IBOutlet var labelSmsCodeResendTopToButtonResend: NSLayoutConstraint!
    
    var codeSendingDelay: Int = 60
    
    var userPhoneNumber: String = ""
    
    @Inject var citizenApi: CitizenAPI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldSmsCodeSmsConfirmationController.delegate = self
        self.buttonResendCodeSmsConfirmationViewController.isHidden = true
        self.labelSmsCodeResendCaption.isHidden = false
        
        labelSmsCodeResendTopToButtonSend.isActive = true
        labelSmsCodeResendTopToButtonResend.isActive = false
        
        buttonResendCodeSmsConfirmationViewController.addTarget(self, action: #selector(SmsConfirmationViewController.didPressButtonResendCodeSmsConfirmation), for: .touchUpInside)
        
        var descriptionForLabel = "На номер телефона "
        let attributeStartingIndex = descriptionForLabel.count
        descriptionForLabel += userPhoneNumber.formattedNumber()
        
        let attributeStringLength = descriptionForLabel.count - attributeStartingIndex
        
        descriptionForLabel += " был выслан код. Введи код-подтверждение ниже"
        let attStr = NSMutableAttributedString.init(string: descriptionForLabel)
        
        attStr.addAttribute(.font,
                            value: UIFont.systemFont(ofSize: 14.0, weight: .bold),
                            range: NSRange.init(location: attributeStartingIndex, length: attributeStringLength))
        attStr.addAttribute(NSAttributedString.Key.foregroundColor,
                            value: UIColor(hexString: "#424242"),
                            range: NSRange(location: attributeStartingIndex, length: attributeStringLength))
        buttonLoginSmsConfirmationController.addTarget(self, action: #selector(SmsConfirmationViewController.didPressButtonLoginSmsConfirmation), for: .touchUpInside)
        labelDescriptionSmsConfirmationViewController.attributedText = attStr
        
        delayResendButtonAppearing(delayFor: codeSendingDelay)
    }
    
    @objc private func didPressButtonLoginSmsConfirmation() {
        citizenApi.confirmPhoneNumberViaSms(smsCode: SmsCode(code: self.textFieldSmsCodeSmsConfirmationController.text!, phone: self.userPhoneNumber)).subscribe(onNext: {  result in
            /// Save token to the UserDefaults
            UserDefaults.standard.set(result.token, forKey: Constants.accessTokenKeyUserDefaults)
            self.openMainViewController()
        }, onError: {   error in
            print(error)
        })
    }
    
    private func delayResendButtonAppearing(delayFor seconds: Int) {
        var timerRunCounter = 0
        var secondsDelayInt = Int(seconds)
        self.labelSmsCodeResendCaption.text = "Повторная отправка кода через: \(secondsDelayInt) сек."
        secondsDelayInt -= 1
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {    timer in
            if timerRunCounter == Int(seconds) - 1 {
                self.buttonResendCodeSmsConfirmationViewController.isHidden = false
                self.labelSmsCodeResendCaption.isHidden = true
                self.labelSmsCodeResendTopToButtonSend.isActive = false
                self.labelSmsCodeResendTopToButtonResend.isActive = true
                
                timer.invalidate()
            }
            self.labelSmsCodeResendCaption.text = "Повторная отправка кода через: \(secondsDelayInt - timerRunCounter) сек."
            timerRunCounter += 1
        }
    }
    
    
    
    @objc private func didPressButtonResendCodeSmsConfirmation() {
        self.buttonResendCodeSmsConfirmationViewController.isHidden = true
        self.labelSmsCodeResendCaption.isHidden = false
        self.labelSmsCodeResendTopToButtonResend.isActive = false
        self.labelSmsCodeResendTopToButtonSend.isActive = true
        citizenApi.sendSmsToPhoneNumber(phoneNumber: PhoneNumber(phone: userPhoneNumber))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {   result in
                self.delayResendButtonAppearing(delayFor: 60)
            }, onError: {   error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText), textField == textFieldSmsCodeSmsConfirmationController else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
    
    private func openMainViewController() {
        self.performSegue(withIdentifier: "fromSmsConfirmationToPermissionsVC", sender: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
}
