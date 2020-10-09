//
//  SMLoginViewModel.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/17/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import Foundation
import SwiftyJSON

@objc protocol LoginDelegate {
    /**
     Executes when the login API call retrieves the result.
     
     - parameter status: true if successfully logged in. false if not.
     - parameter error:  Login error.
     */
    @objc optional func loginCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?)
    
}


class SMLoginViewModel: NSObject {

    fileprivate let api = ApiClient()
    
    var delegate: LoginDelegate?
    
    
    /**
     Validates user input in the login view.
     
     - parameter username: username
     - parameter password:   Passowrd
     
     - returns: Validation result. Passed if successful. Failed if not with the error message.
     */
    func validate(username: String, password: String) -> StatusCode {
        if username.isEmpty || password.isEmpty {
            return .failedValidation(NSLocalizedString("LOGIN_EMPTY_FIELD_ERROR_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""))
        }
        
        return .passedValidation
    }
    
    
    func login(username: String, password: String) {
        api.loginWithUsername(username: username, password: password, authMethod: AuthMethod.CUSTOM, success: { (data, code) -> Void in
            
            let jsonData = JSON(data as Any)
            NSLog("userLogin : \(jsonData)")
            
            switch code {
            case 200:
                
                //            if jsonData[AuthUser.JsonKeys.verified].bool ?? false{
                
//                let authUser = AuthUser(id: jsonData[AuthUser.JsonKeys.id].int ?? -1 ,
//                                        name: jsonData[AuthUser.JsonKeys.name].string ?? "",
//                                        accessToken: jsonData[AuthUser.JsonKeys.access_token].string ?? "",
//                                        dateOfBirth: jsonData[AuthUser.JsonKeys.date_of_birth].string,
//                                        gender: AuthUser.getGender(text: jsonData[AuthUser.JsonKeys.gender].string ?? "") ,
//                                        language: AuthUser.getLanguage(text: jsonData[AuthUser.JsonKeys.language].string ?? "") ,
//                                        mobileNumber: jsonData[AuthUser.JsonKeys.mobile_number].string)
                
                //Preferences.setUser(authUser)
                
//                let encodedData = NSKeyedArchiver.archivedData(withRootObject: authUser)
//                UserDefaults.standard.set(encodedData, forKey: "AuthUser")
//                
//                // retrieving a value for a key
//                if let data = UserDefaults.standard.data(forKey: "AuthUser"),
//                    let myPeopleList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [AuthUser] {
//                    myPeopleList.forEach({print( $0.name, $0.id)})  // Joe 10
//                } else {
//                    print("There is an issue")
//                }
                Preferences.setIsActiveUser(jsonData[AuthUser.JsonKeys.verified].bool ?? false)
                Preferences.setAccessToken(jsonData[AuthUser.JsonKeys.access_token].string ?? nil)
                Preferences.setUsername(jsonData[AuthUser.JsonKeys.name].string ?? "")
                Preferences.setGender(jsonData[AuthUser.JsonKeys.gender].string ?? "")
                Preferences.setLangauge(jsonData[AuthUser.JsonKeys.language].string ?? "")
                Preferences.setMobileNo(jsonData[AuthUser.JsonKeys.mobile_number].string ?? "")
                Preferences.setBirthDate(jsonData[AuthUser.JsonKeys.date_of_birth].string ?? "")
                Preferences.setCountryCode(jsonData[AuthUser.JsonKeys.country].string ?? "")
                Preferences.setUserId(jsonData[AuthUser.JsonKeys.id].stringValue)
                self.delegate?.loginCallFinished!(true, error: nil, userInfo: nil)
                //            }else{
                //                Common.logout()
                //                self.delegate?.loginCallFinished!(false, error: ErrorHandler.WrongUserCredentials, userInfo: nil)
                //            }
            default:
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                self.delegate?.loginCallFinished!(false, error: error, userInfo: nil)
            
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (Login): \(error.localizedDescription)")
            self.delegate?.loginCallFinished!(false, error: error, userInfo: nil)
        }
    }
    func requestMobileCode() {
        //        print(gender.rawValue)
        //        print(AuthUser.getGenderServerCode(gender: gender))
        api.requestPhoneCode(success: { (data, code) -> Void in
            
            let jsonData = JSON(data as Any)
            NSLog("requestMobileCode : \(jsonData)")
            
            switch code {
            case 200, 201:
                if (jsonData[AuthUser.JsonKeys.mobno].string) != "" || (jsonData[AuthUser.JsonKeys.mobno].string) != nil{
                    Preferences.setWhitList(true)
                    Preferences.setMobeCode(jsonData[AuthUser.JsonKeys.mobno].string ?? "")
                }
                else{
                    Preferences.setWhitList(false)
//                    (jsonData[AuthUser.JsonKeys.mobno].string ?? "")

                }
                
            default:
                break
            }
            
            
            
        }) { (error) -> Void in
            //            NSLog("Error (updateUserDetails): \(error.localizedDescription)")
            //            self.delegate?.registerInfoCallFinished!(false, error: error, userInfo: nil)
        }
    }
}
