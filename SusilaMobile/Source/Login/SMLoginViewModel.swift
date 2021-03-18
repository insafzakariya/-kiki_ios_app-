//
//  SMLoginViewModel.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/17/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import Foundation
import SwiftyJSON

class SMLoginViewModel: NSObject {
    
    fileprivate let api = ApiClient()
    
    
    override init() {
        super.init()
        if kAPIBaseUrl == ""{
            
        }
    }
    
    /**
     Validates user input in the login view.
     
     - parameter username: username
     - parameter password:   Passowrd
     
     - returns: Validation result. Passed if successful. Failed if not with the error message.
     */
    func validate(username: String, password: String) -> StatusCode {
        if username.isEmpty || password.isEmpty {
            return .failedValidation("LOGIN_EMPTY_FIELD_ERROR_ALERT_MESSAGE".localizedString)
        }
        
        return .passedValidation
    }
    
    
    func login(username: String, password: String,onCompleted:@escaping (_ isSucess:Bool,_ error:Error?)->()) {
        api.loginWithUsername(username: username, password: password, authMethod: AuthMethod.CUSTOM, success: { (data, code) -> Void in
            let jsonData = JSON(data as Any)
            Log("userLogin : \(jsonData)")
            Log("HTTP Status Code: \(code)")
            switch code {
            case 200:
                UserDefaultsManager.setIsActiveUser(jsonData[AuthUser.JsonKeys.verified].bool ?? false)
                UserDefaultsManager.setAccessToken(jsonData[AuthUser.JsonKeys.access_token].string ?? nil)
                UserDefaultsManager.setUsername(jsonData[AuthUser.JsonKeys.name].string ?? "")
                UserDefaultsManager.setGender(jsonData[AuthUser.JsonKeys.gender].string ?? "")
                UserDefaultsManager.setLangauge(jsonData[AuthUser.JsonKeys.language].string ?? "")
                UserDefaultsManager.setMobileNo(jsonData[AuthUser.JsonKeys.mobile_number].string ?? "")
                UserDefaultsManager.setBirthDate(jsonData[AuthUser.JsonKeys.date_of_birth].string ?? "")
                UserDefaultsManager.setCountryCode(jsonData[AuthUser.JsonKeys.country].string ?? "")
                UserDefaultsManager.setUserId(jsonData[AuthUser.JsonKeys.id].stringValue)
                onCompleted(true,nil)
            default:
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                Log(error.localizedDescription)
                onCompleted(false,error)
            }
        }) { (error) -> Void in
            Common.logout()
            Log("Error (Login): \(error.localizedDescription)")
            onCompleted(false,error)
        }
    }
    func requestMobileCode() {
        //        print(gender.rawValue)
        //        print(AuthUser.getGenderServerCode(gender: gender))
        api.requestPhoneCode(success: { (data, code) -> Void in
            
            let jsonData = JSON(data as Any)
            Log("requestMobileCode : \(jsonData)")
            
            switch code {
            case 200, 201:
                if (jsonData[AuthUser.JsonKeys.mobno].string) != "" || (jsonData[AuthUser.JsonKeys.mobno].string) != nil{
                    UserDefaultsManager.setWhitList(true)
                    UserDefaultsManager.setMobeCode(jsonData[AuthUser.JsonKeys.mobno].string ?? "")
                }
                else{
                    UserDefaultsManager.setWhitList(false)
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
