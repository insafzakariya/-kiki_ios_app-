//
//  SMNewPassword.swift
//  SusilaMobile
//
//  Created by Admin on 9/12/19.
//  Copyright © 2019 Isuru Jayathissa. All rights reserved.
//

import UIKit

class SMNewPasswordController: BaseViewController {
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var cPasswordText: UITextField!
    
    fileprivate let resetViewModel = SMNewPasswordModel()
    
    override func viewDidLoad() {
        passwordText.setLeftPaddingPoints(10)
        cPasswordText.setLeftPaddingPoints(10)
        passwordText.addShadow()
        cPasswordText.addShadow()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verificationViewController = storyboard.instantiateViewController(withIdentifier: "SMVerificationViewController") as! SMVerificationViewController
        self.navigationController?.pushViewController(verificationViewController, animated: true)
        
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        let cPass = cPasswordText.text
        
        let range = cPass!.rangeOfCharacter(from: NSCharacterSet.letters)
        
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = cPass!.rangeOfCharacter(from: decimalCharacters)
        
        let count = cPass!.count
        
        if decimalRange != nil && range != nil && count>=6 && count<=15{
            smsCodeVerify(viwerId: String(mainInstance.viwerId), password: cPass!)
        } else {
            alert(message: "Invalid password [Should contain at least one letter, one digit i.e. 0-9, and length between 6-15 characters]")
        }
        
    }
    
    func gotoSuccessView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resetSuccessController = storyboard.instantiateViewController(withIdentifier: "SMResetSuccessController") as! SMResetSuccessController
        self.navigationController?.pushViewController(resetSuccessController, animated: true)
    }
    
    private func keyboardDismiss(){
        passwordText.resignFirstResponder()
        cPasswordText.resignFirstResponder()
    }
    
    fileprivate func smsCodeVerify(viwerId: String, password: String) {
        
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
       
        if validateRegisterForm() {
            keyboardDismiss()
            
            self.resetViewModel.resetPasswordSend(viwer_id:viwerId, password:password, callFinished: { (status, error) in
                
                print("user: ", viwerId, "passsword: ", password)
                if status {
                    self.gotoSuccessView()
                    
                } else {
                    ProgressView.shared.hide()
                    if let error = error {
                        switch error.code {
                        case ResponseCode.noNetwork.rawValue:
                            Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""), perent: self)
                            //                case 1001, 1003, 1031:
                            //                    Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE", comment: ""), alertMessage: error.localizedDescription, perent: self)
                            
                        default: Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                            
                        }
                    }
                }
            })
            
        } else{
            ProgressView.shared.hide()
        }
        
        /*if let smsCodeString = passwordText.text, !smsCodeString.isEmpty {
            cPasswordText.resignFirstResponder()
            
            let pass = passwordText.text
            let cPass = cPasswordText.text
            
            if pass=="" && cPass=="" {
                ProgressView.shared.hide()
                alert(message: "All fields are required!")
            } else if pass != cPass {
                ProgressView.shared.hide()
                alert(message: "Confirm password not match!")
            }  else {
                
                self.resetViewModel.resetPasswordSend(viwer_id:viwerId, password:password, callFinished: { (status, error) in
                    
                    print("user: ", viwerId, "passsword: ", password)
                    if status {
                        self.gotoSuccessView()
                        
                    } else {
                        ProgressView.shared.hide()
                    }
                })
            }
        } else{
            ProgressView.shared.hide()
        }*/
    }
    
    fileprivate func validateRegisterForm() -> Bool {
        let validateResult = resetViewModel.validate(password: passwordText.text, conPassword: cPasswordText.text)
        if validateResult != StatusCode.passedValidation {
            let message = validateResult.getFailedMessage()
            
            let alert = UIAlertController(title: NSLocalizedString("LOGIN_ERROR_ALERT_TITLE".localized(using: "Localizable"), comment: ""), message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action) -> Void in
                ProgressView.shared.hide()
            }))
            showDetailViewController(alert, sender: nil)
            
            return false
        }
        
        return true
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

