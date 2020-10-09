//
//  SMRegisterViewController.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/19/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import Firebase

class SMRegisterViewController: BaseViewController {

//    @IBOutlet weak var textFieldHightChangre: NSLayoutConstraint!
    @IBOutlet fileprivate var usernameTextField: UITextField!
    @IBOutlet fileprivate var passwordTextField: UITextField!
    @IBOutlet fileprivate var confirmPasswordTextField: UITextField!
    @IBOutlet fileprivate var nameTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet fileprivate var regiterButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var registerLable: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblCPassword: UILabel!
    
    fileprivate let registerViewModel = SMRegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setText()

//        registerViewModel.delegate = self
        usernameTextField.setLeftPaddingPoints(10)
        passwordTextField.setLeftPaddingPoints(10)
        confirmPasswordTextField.setLeftPaddingPoints(10)
        if #available(iOS 9.0, *) {
            if usernameTextField.responds(to: #selector(getter: UIResponder.inputAssistantItem)){
                
                let inputAssistantItem = usernameTextField.inputAssistantItem
                inputAssistantItem.leadingBarButtonGroups = [];
                inputAssistantItem.trailingBarButtonGroups = [];
                
                let passwordAssistantItem = passwordTextField.inputAssistantItem
                passwordAssistantItem.leadingBarButtonGroups = [];
                passwordAssistantItem.trailingBarButtonGroups = [];
                
            }
        } else {
            // Fallback on earlier versions
        }
        
        usernameTextField.addShadow()
        passwordTextField.addShadow()
        confirmPasswordTextField.addShadow()
    }
    
    @objc func setText(){
        registerLable.text = "RegisterNow".localized(using: "Localizable")
        lblUsername.text = "username".localized(using: "Localizable")
        lblPassword.text = "password".localized(using: "Localizable")
        lblCPassword.text = "ConfirmPassword".localized(using: "Localizable")
        usernameTextField.placeholder = "usernamePlaceHolder".localized(using: "Localizable")
        passwordTextField.placeholder = "passwordPlaceHolder".localized(using: "Localizable")
        confirmPasswordTextField.placeholder = "TypeYourPasswordAgain".localized(using: "Localizable")

        regiterButton.setTitle("RegisterBtn".localized(using: "Localizable"), for: UIControl.State.normal)
        loginBtn.setTitle("loginWithEmail".localized(using: "Localizable"), for: UIControl.State.normal)
        
        let color = colorWithHexString(hex: "#999999")
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder ?? "", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : color]))
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder ?? "", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : color]))
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: confirmPasswordTextField.placeholder ?? "", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : color]))

        
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func keyboardDismiss(){
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
//        nameTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func validateRegisterForm() -> Bool {
        let validateResult = registerViewModel.validate(username: usernameTextField.text, password: passwordTextField.text, conPassword: confirmPasswordTextField.text, name: usernameTextField.text)
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
    

    
    @IBAction func tappedRegisterButton(_ sender: AnyObject) {
        register()
    }
    
    fileprivate func register() {
        
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        
        if validateRegisterForm() {
            keyboardDismiss()
//            let trimmedUserName = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let user = User(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", name: usernameTextField.text ?? "", provider: .CUSTOM, gender: nil, language: nil, accessToken: nil, socialAccessToken: nil, socialAccessTokenSecret: nil, mobileNumber: nil, whitelisted: nil, country: nil, device_id: Messaging.messaging().fcmToken!)
            
            registerViewModel.register(user: user, callFinished: { (status, error, userInfo) in
                
                ProgressView.shared.hide()
                if status {
                    self.goToRegisterInfoView()
                } else {
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
            
        }else{
            ProgressView.shared.hide()
        }
    }
    
    // MARK: - Navigation
    fileprivate func goToRegisterInfoView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let registerInfoViewController = storyboard.instantiateViewController(withIdentifier: "SMRegisterInfoViewController") as! SMRegisterInfoViewController
        registerInfoViewController.fromRegisterVwe = "true"
        self.navigationController?.pushViewController(registerInfoViewController, animated: true)
    }
    
    func connectionTimeoutMessage(){
        let alertTitle = NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: "")
        let alertMessage = NSLocalizedString("CONNECTION_TIME_OUT".localized(using: "Localizable"), comment: "")
        
        let alert = UIAlertController(title: alertTitle, message:alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action) -> Void in
            self.register()
        }))
        showDetailViewController(alert, sender: nil)
    }
}

// MARK: - LoginDelegate
extension SMRegisterViewController: RegisterDelegate {
    func registerCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?) {
        ProgressView.shared.hide()
        if status {
            goToRegisterInfoView()
        } else {
            if let error = error {
                print(error.localizedDescription)

                switch error.code {
                case ResponseCode.noNetwork.rawValue:
                    Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""), perent: self)
                    
                case ResponseCode.userAlreadyRegistered.rawValue:
                    Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                    
                case ResponseCode.inValidCredentials.rawValue:
                    Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                case 1001, 1003, 1031:
                    Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                    
                default: Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                    
                }
            }
        }
    }
}

 //MARK: - UITextFieldDelegate
extension SMRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            if validateRegisterForm() {
                register()
            }
        default:()
            
        }
        
        return false
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
