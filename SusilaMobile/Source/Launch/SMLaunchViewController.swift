//
//  SMLaunchViewController.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 2/8/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import SwiftyJSON

class SMLaunchViewController: UIViewController {
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        if screenHeight == 480{
            bgImageView.image = UIImage(named: "BGImage_iPhone4s")
        }
        
        if let accessToken = UserDefaultsManager.getAccessToken(), !accessToken.isEmpty{
            checkKeepMeLogin()
            
        }else{
            Common.logout()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ProgressView.shared.hide()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func goToRegisterInfoView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let registerInfoViewController = storyboard.instantiateViewController(withIdentifier: "SMRegisterInfoViewController") as! SMRegisterInfoViewController
        let navController = UINavigationController(rootViewController: registerInfoViewController)
        navController.navigationBar.isHidden = true
        self.present(navController, animated: true) {
            
        }
        //        self.navigationController?.pushViewController(registerInfoViewController, animated: true)
    }

    func checkKeepMeLogin(){
        let api = ApiClient()
        api.authLoginWithAccessToken(success: { (data, code) -> Void in
            
            
            let jsonData = JSON(data as Any)
            NSLog("authLoginWithAccessToken : \(jsonData)")
            
            switch code {
            case 200:
                
//                let authUser = AuthUser(id: jsonData[AuthUser.JsonKeys.id].int ?? -1 ,
//                                        name: jsonData[AuthUser.JsonKeys.name].string ?? "",
//                                        accessToken: jsonData[AuthUser.JsonKeys.access_token].string ?? "",
//                                        dateOfBirth: jsonData[AuthUser.JsonKeys.date_of_birth].string,
//                                        gender: AuthUser.getGender(text: jsonData[AuthUser.JsonKeys.gender].string ?? "") ,
//                                        language: AuthUser.getLanguage(text: jsonData[AuthUser.JsonKeys.language].string ?? "") ,
//                                        mobileNumber: jsonData[AuthUser.JsonKeys.mobile_number].string)
//                
                
                UserDefaultsManager.setIsActiveUser(jsonData[AuthUser.JsonKeys.verified].bool ?? false)
                UserDefaultsManager.setAccessToken(jsonData[AuthUser.JsonKeys.access_token].string ?? nil)
                UserDefaultsManager.setUsername(jsonData[AuthUser.JsonKeys.name].string ?? "")
                UserDefaultsManager.setGender(jsonData[AuthUser.JsonKeys.gender].string ?? "")
                UserDefaultsManager.setLangauge(jsonData[AuthUser.JsonKeys.language].string ?? "")
                UserDefaultsManager.setMobileNo(jsonData[AuthUser.JsonKeys.mobile_number].string ?? "")
                UserDefaultsManager.setBirthDate(jsonData[AuthUser.JsonKeys.date_of_birth].string ?? "")
                
                UserDefaultsManager.setCountryCode(jsonData[AuthUser.JsonKeys.country].string ?? "")
                
                if UserDefaultsManager.getIsActiveUser(){
                    (UIApplication.shared.delegate as! AppDelegate).gotoHomeView()
                }else{
                    self.goToRegisterInfoView()
                }
                
                
            default:
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription)
                Common.logout()
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (authLoginWithAccessToken): \(error.localizedDescription)")
            
        }
    }
    
    
    
    fileprivate let api = ApiClient()
    func updateFCMToken(deviceId: String, updateFCMTokenCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.updateFCMToken(deviceId: deviceId, success: { (data, code) -> Void in
            switch code {
            case 200:
                updateFCMTokenCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                updateFCMTokenCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            NSLog("Error (updateFCMTokenCallFinished): \(error.localizedDescription)")
            updateFCMTokenCallFinished(false, error, nil)
        }
    }

}
