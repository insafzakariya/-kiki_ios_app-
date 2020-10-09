//
//  ViewController.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/13/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import Crashlytics
import Firebase

class SMLoginViewController: BaseViewController {

    @IBOutlet fileprivate var usernameTextField: UITextField!
    @IBOutlet fileprivate var passwordTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginLable: UILabel!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordResetBtn: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    
    fileprivate let loginViewModel = SMLoginViewModel()
    fileprivate let registerViewModel = SMRegisterViewModel()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setText()
        usernameTextField.setLeftPaddingPoints(10)
        passwordTextField.setLeftPaddingPoints(10)
        passwordResetBtn.setTitle("ForgetPassword".localized(using: "Localizable"), for: .normal)
        lblUsername.text = "username".localized(using: "Localizable")
        lblPassword.text = "password".localized(using: "Localizable")
//        usernameTextField.setTitle(NSLocalizedString("GOBACK", comment: ""), for: .normal)
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        loginViewModel.delegate = self
        loginViewModel.requestMobileCode()
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
        
        //setCurrentUserName()
//        Crashlytics.sharedInstance().crash()
        
        usernameTextField.addShadow()
        passwordTextField.addShadow()
    }
    @objc func setText(){

        loginLable.text = "Login".localized(using: "Localizable")
        usernameTextField.placeholder = "usernamePlaceHolder".localized(using: "Localizable")
        passwordTextField.placeholder = "passwordPlaceHolder".localized(using: "Localizable")
        loginBtn.setTitle("LoginBtn".localized(using: "Localizable"), for: UIControl.State.normal)
        createAccountBtn.setTitle("CreateAccount".localized(using: "Localizable"), for: UIControl.State.normal)
        
        let color = colorWithHexString(hex: "#999999")
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder ?? "", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : color]))
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder ?? "", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : color]))
    }

    
    func keyboardDismiss(){
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
//    func setCurrentUserName(){
//        if let lastUsername = Preferences.getLastLogoutUsername(){
//            if !lastUsername.isEmpty{
//                self.usernameTextField.text = lastUsername
//            }
//        }
//        
//    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func validateLoginForm() -> Bool {
        let validateResult = loginViewModel.validate(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
        if validateResult != StatusCode.passedValidation {
            let message = validateResult.getFailedMessage()
            
            //            if iOS8 {
            let alert = UIAlertController(title: NSLocalizedString("LOGIN_ERROR_ALERT_TITLE".localized(using: "Localizable"), comment: ""), message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action) -> Void in
                ProgressView.shared.hide()
            }))
            showDetailViewController(alert, sender: nil)

            return false
        }
        
        return true
    }
    
    @IBAction func tappedLoginButton(_ sender: AnyObject) {
        //goToHomeView() // to test uncomment this
        login()
        //Crashlytics.sharedInstance().crash()
    }
    
    @IBAction func passwordResetPressed(_ sender: Any) {
        print("Reset")
        goToResetView()
    }
    
    
    fileprivate func login() {
        
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        
        if validateLoginForm() {
            passwordTextField.resignFirstResponder()
            let trimmedUserName = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

            loginViewModel.login(username: trimmedUserName ?? "", password: passwordTextField.text ?? "")

        }else{
            ProgressView.shared.hide()
        }
    }
    
    // MARK: - Navigation
    fileprivate func goToHomeView() {
        if let token = Messaging.messaging().fcmToken {
            updateFCMToken(deviceId: token)
        }
        if(UserDefaults.standard.object(forKey: "isMusicOn") != nil){
            let isOn = UserDefaults.standard.bool(forKey: "isMusicOn");
            if(isOn){
                (UIApplication.shared.delegate as! AppDelegate).gotoMusicView()
            }
            else{
                (UIApplication.shared.delegate as! AppDelegate).gotoHomeView()
            }
        }
        else {
            (UIApplication.shared.delegate as! AppDelegate).gotoHomeView()
        }
        
    }
    
    func updateFCMToken(deviceId: String) {
        SMLaunchViewController().updateFCMToken(deviceId: deviceId, updateFCMTokenCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    print("FCM Token Updated")
                })
            }
        })
    }

    func connectionTimeoutMessage(){
        let alertTitle = NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: "")
        let alertMessage = NSLocalizedString("CONNECTION_TIME_OUT".localized(using: "Localizable"), comment: "")
        
        let alert = UIAlertController(title: alertTitle, message:alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action) -> Void in
            self.login()
        }))
        showDetailViewController(alert, sender: nil)
    }
    
    
    func goToRegisterInfoView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let registerInfoViewController = storyboard.instantiateViewController(withIdentifier: "SMRegisterInfoViewController") as! SMRegisterInfoViewController
        let navController = UINavigationController(rootViewController: registerInfoViewController)
        navController.navigationBar.isHidden = true
        self.present(navController, animated: true) { 
            
        }
//        self.navigationController?.pushViewController(registerInfoViewController, animated: true)
    }
    
    func goToResetView() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let resetViewController = storyboard.instantiateViewController(withIdentifier: "SMResetViewController") as! SMResetViewController
        resetViewController.fromLoginView = "true"
        self.navigationController?.pushViewController(resetViewController, animated: true)
        
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

// MARK: - LoginDelegate
extension SMLoginViewController: LoginDelegate {
    func loginCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?) {
        ProgressView.shared.hide()
        if status {
            if Preferences.getIsActiveUser(){
                if Preferences.getMobileNo() == nil || Preferences.getMobileNo() == ""{
//                    self.goToRegisterInfoView()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let registerInfoViewController = storyboard.instantiateViewController(withIdentifier: "SMRegisterInfoViewController") as! SMRegisterInfoViewController
                    registerInfoViewController.fromRegisterVwe = "true"
                    self.navigationController?.pushViewController(registerInfoViewController, animated: true)
                }
                else{
                    goToHomeView()
                }
            }else{
                self.goToRegisterInfoView()
            }
            
        } else {
            if let error = error {
                switch error.code {
                case ResponseCode.noNetwork.rawValue:
                    Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""))
                case ResponseCode.userCredentialsNotCorrect.rawValue:
                    Common.showAlert(alertTitle: NSLocalizedString("LOGIN_ERROR_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: "LOGIN_ERROR_IN_FIELDS".localized(using: "Localizable"))

                case ResponseCode.connectionTimeout.rawValue:
                    connectionTimeoutMessage()
                default: Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: "LOGIN_SEVERRETURN_FIELD_ERROR_ALERT_MESSAGE".localized(using: "Localizable"), perent: self)
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SMLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            if validateLoginForm() {
                login()
            }
        default:()
            
        }
        
        return false
    }
    
}

extension UITextField {
    func underlined(){
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 4
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width:1.0, height:5.0)
        self.layer.shadowOpacity = 0.33
    }
}
extension UIButton {
    func underlined(){
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
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
