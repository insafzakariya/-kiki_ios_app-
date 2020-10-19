//
//  SMRegisterViewModel.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/19/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol RegisterDelegate {

    @objc optional func registerCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?)
    
}

class SMRegisterViewModel: NSObject {

    fileprivate let api = ApiClient()
    var delegate: RegisterDelegate?
    
        
    func validate(username: String?, password: String?, conPassword: String?, name: String?) -> StatusCode {
        if let usernameString = username, usernameString.isEmpty{
            return .failedValidation("ENTER_VALID_USERNAME".localizedString)
        }else if let passwordString = password, passwordString.isEmpty{
            return .failedValidation("ENTER_VALID_PASSWORD".localizedString)
        }else if let conPasswordString = conPassword, conPasswordString.isEmpty || conPasswordString != password {
            return .failedValidation("PASSWORD_NOT_MATCH".localizedString)
        }else if let nameString = name, nameString.isEmpty {
            return .failedValidation("ENTER_VALID_NAME".localizedString)
        }
        
        return .passedValidation
    }
    
    func register(user: User, callFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: Any]?) -> Void) {
        
        api.register(user: user, success: { (data, code) -> Void in
            

            /*/
            1) password policy error
            Status Code: 400 Bad Request
            
            {"errorMessage":"Invalid password [Password must contain 6-15 characters and all of the following; One uppercase letter, One lowercase letter, One digit i.e. 0-9, One special character]","errorCode":1003}
            
            2) New user creation
            Status Code: 201 Created
            
            {"gender":null,"verified":false,"mobile_number":null,"date_of_birth":null,"access_token":"a46b7376-4534-463a-bfe7-2a00b28fa84a","username":"test1114","name":"Test","language":null,"id":445}
            3) Already registered user with correct password
            Status Code: 200 OK
            
            {"gender":null,"verified":false,"mobile_number":null,"date_of_birth":null,"access_token":"b7261e3c-e93f-4aa7-9df9-9ca736e287e8","username":"test1114","name":"Test","language":null,"id":445}
            
             4) Already registered user with in correct password
            Status Code: 400 Bad Request
            
            {"errorMessage":"Username already taken.","errorCode":1001}
            
            */
            
            
            let jsonData = JSON(data as Any)
            NSLog("userRegister : \(jsonData)")
            
            switch code {
            case 200:
                let parameters = [
                    "isNewUser":false,
                    "mobile_number" : jsonData[AuthUser.JsonKeys.mobile_number].string ?? ""
                ] as [String : Any]
                UserDefaultsManager.setAccessToken(jsonData[AuthUser.JsonKeys.access_token].string ?? nil)
                UserDefaultsManager.setUsername(jsonData[AuthUser.JsonKeys.name].string ?? "")
                UserDefaultsManager.setGender(jsonData[AuthUser.JsonKeys.gender].string ?? "")
                UserDefaultsManager.setLangauge(jsonData[AuthUser.JsonKeys.language].string ?? "")
                UserDefaultsManager.setMobileNo(jsonData[AuthUser.JsonKeys.mobile_number].string ?? "")
                UserDefaultsManager.setBirthDate(jsonData[AuthUser.JsonKeys.date_of_birth].string ?? "")
                UserDefaultsManager.setCountryCode(jsonData[AuthUser.JsonKeys.country].string ?? "")
                UserDefaultsManager.setUserId(jsonData[AuthUser.JsonKeys.username].string ?? "")
                callFinished(true, nil, parameters as [String : Any]?)
            case 201:
                
                let parameters = [
                    "isNewUser":true,
                    ]
                
                UserDefaultsManager.setAccessToken(jsonData[AuthUser.JsonKeys.access_token].string ?? nil)
                UserDefaultsManager.setUsername(jsonData[AuthUser.JsonKeys.name].string ?? "")
                UserDefaultsManager.setGender(jsonData[AuthUser.JsonKeys.gender].string ?? "")
                UserDefaultsManager.setLangauge(jsonData[AuthUser.JsonKeys.language].string ?? "")
                UserDefaultsManager.setMobileNo(jsonData[AuthUser.JsonKeys.mobile_number].string ?? "")
                UserDefaultsManager.setBirthDate(jsonData[AuthUser.JsonKeys.date_of_birth].string ?? "")
                UserDefaultsManager.setCountryCode(jsonData[AuthUser.JsonKeys.country].string ?? "")
                callFinished(true, nil, parameters as [String : Any]?)
            default:
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                callFinished(false, error, nil)

            }
            
            
            
        }) { (error) -> Void in
            NSLog("Error (Login): \(error.localizedDescription)")
            callFinished(false, error, nil)
        }
    }
    
}
