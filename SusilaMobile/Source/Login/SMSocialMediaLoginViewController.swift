//
//  SMInitialLoginViewController.swift
//  SusilaMobile
//
//  Created by Meuru Muthuthanthri on 6/2/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import Foundation
import GoogleSignIn
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

class SMSocialMediaLoginViewController: BaseViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginPageNavigationButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var fbGmLable: UILabel!
    @IBOutlet weak var loginEmailBtn: UIButton!
    @IBOutlet weak var orLable: UILabel!
    @IBOutlet weak var createAccntBtn: UIButton!
    @IBOutlet weak var backButton: UIButton!

    fileprivate let registerViewModel = SMRegisterViewModel()
    
    override func viewDidLoad() {
        self.setText()

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        let translateSet = defaults.object(forKey: "loadToMainLogin") as? String
        if translateSet == "true" {
            backButton.isHidden = true
        }
    }
    
    @objc func setText() {
        fbButton.setTitle("fbLogin".localized(using: "Localizable"), for: UIControl.State.normal)
        googleBtn.setTitle("GLogin".localized(using: "Localizable"), for: UIControl.State.normal)
        fbGmLable.text = "dontHaveAccount".localized(using: "Localizable")
        loginEmailBtn.setTitle("loginWithEmail".localized(using: "Localizable"), for: UIControl.State.normal)
        createAccntBtn.setTitle("CreateAccount".localized(using: "Localizable"), for: UIControl.State.normal)
        orLable.text = "or".localized(using: "Localizable")

    }
    // Remove the LCLLanguageChangeNotification on viewWillDisappear
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
//        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.title = "Hello"
        
        _ = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle): NSUnderlineStyle.single.rawValue,
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.white,
            ] as [String : Any]
      //  let buttonTitleStr = NSMutableAttributedString(string: "I don't have Facebook or Gmail", attributes:attrs)
    //    loginPageNavigationButton.setAttributedTitle(buttonTitleStr, for: .normal)
      
    }
    
    
    @IBAction func tappedFacebookButton(_ sender: Any) {
        func getUserInfo(accessTokenString: String) {
            print("Trying to login FB. \(accessTokenString)")
            let user = User(username: "", password: "", name: "", provider: .FACEBOOK, gender: nil, language: nil, accessToken: nil, socialAccessToken: accessTokenString, socialAccessTokenSecret: nil, mobileNumber: nil, whitelisted: nil, country: nil, device_id: Messaging.messaging().fcmToken!)
            self.callSocialRegistrationAPI(user: user)
        }
        
        if let fbAccess = AccessToken.current {
            getUserInfo(accessTokenString: fbAccess.tokenString)
        } else {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["public_profile"], from: self) { (loginResult, error) in
                if error != nil {
                    print("Login to facebook failed. Error: \(String(describing: error))")
                } else {
                    if let fbAccess = AccessToken.current {
                        getUserInfo(accessTokenString: fbAccess.tokenString)
                    }else{
                        print("FBSDKAccessToken.current fails")
                    }
                }
            }
        }
        
    }
    
    @IBAction func tappedGoogleButton(_ sender: Any) {
        ProgressView.shared.show(self.view, mainText: "", detailText: "")
        GIDSignIn.sharedInstance().signIn()
    }
    
//    @IBAction func gotoLogin(_ sender: Any) {
//        (UIApplication.shared.delegate as! AppDelegate).gotoLoginView()
//
//    }

    func callSocialRegistrationAPI(user: User){
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        registerViewModel.register(user: user, callFinished: { (status, error, userInfo) in
            ProgressView.shared.hide()
            if let userInfo = userInfo, userInfo["isNewUser"] as! Bool{
                self.goToRegisterInfoView()
            }else{
                if status {
                    if let userInfo = userInfo {
                        if let moNumber = (userInfo["mobile_number"] as? String), moNumber  == ""{
                            self.goToRegisterInfoView()
                        } else {
                            if let token = Messaging.messaging().fcmToken {
                                self.updateFCMToken(deviceId: token)
                            }
                            self.goToHomeView()
                        }
                    } else {
                        if let token = Messaging.messaging().fcmToken {
                            self.updateFCMToken(deviceId: token)
                        }
                        self.goToHomeView()
                    }
                } else {
                    self.giveFailMessage(error: error)
                }
            }
        })
    }

    func goToRegisterInfoView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerInfoViewController = storyboard.instantiateViewController(withIdentifier: "SMRegisterInfoViewController") as! SMRegisterInfoViewController
        let navController = UINavigationController(rootViewController: registerInfoViewController)
        navController.navigationBar.isHidden = true
        self.present(navController, animated: true) {
        }
    }
    
    fileprivate func goToHomeView() {
        (UIApplication.shared.delegate as! AppDelegate).gotoHomeView()
    }
    
    func giveFailMessage(error: NSError?){
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
    
    func updateFCMToken(deviceId: String) {
        SMLaunchViewController().updateFCMToken(deviceId: deviceId, updateFCMTokenCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    print("FCM Token Updated")
                })
            }
        })
    }
}

//Google
extension SMSocialMediaLoginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            ProgressView.shared.hide()
            let user = User(username: "", password: "", name: "", provider: .GOOGLE, gender: nil, language: nil, accessToken: nil, socialAccessToken: user.authentication.idToken, socialAccessTokenSecret: nil, mobileNumber: nil, whitelisted: nil, country: nil, device_id: Messaging.messaging().fcmToken!)
            
            self.callSocialRegistrationAPI(user: user)
        } else {
            ProgressView.shared.hide()
            print("\(error.localizedDescription)")
        }
    }
    
    private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        ProgressView.shared.hide()
    }
}
