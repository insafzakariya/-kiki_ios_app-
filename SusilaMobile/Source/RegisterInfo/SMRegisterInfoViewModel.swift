//
//  SMRegisterInfoViewModel.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/19/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import SwiftyJSON

@objc protocol RegisterInfoDelegate {
    
    @objc optional func registerInfoCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?)
    
}


class SMRegisterInfoViewModel: NSObject {

    
    fileprivate let api = ApiClient()
    var delegate: RegisterInfoDelegate?
    
    func validateRegisterInfo(gender: String?, birthdate:String?, language:String?, country:String?, mobile: String?, regionCode: String?) -> StatusCode {
        
        if birthdate == nil {
            return .failedValidation("ENTER_VALID_BIRTHDATE".localizedString)
        }else if gender == nil {
            return .failedValidation("ENTER_VALID_GENDER".localizedString)
        }else if language == nil {
            return .failedValidation("ENTER_VALID_LANGUAGE".localizedString)
        }
        else if country == nil {
            return .failedValidation("ENTER_VALID_COUNTRY".localizedString)
        } else if mobile == nil || !Common.mobileNovalidate(phoneNumber: mobile!, regionCode: regionCode!) {
            if (ValidationManager.isSriLankanPhoneNumber(mobile)) {
                return .failedValidation("ENTER_VALID_MOBILENO".localizedString)
            } else {
                return .failedValidation("ENTER_VALID_MOBILENO".localizedString)
            }
        }
        
        return .passedValidation
    }

    func validate(mobileNO: String?, regionCode: String?) -> StatusCode {
        if let mobileNOString = mobileNO, mobileNOString.isEmpty || !Common.mobileNovalidate(phoneNumber: mobileNOString, regionCode: regionCode!){
            return .failedValidation("ENTER_VALID_MOBILENO".localizedString)
        }

        return .passedValidation
    }
    
    func updateUserDetails(mobileNo: String, country:String, birthdate: String, gender: Gender, language: Language) {
        api.updateUserDetails(mobileNo: mobileNo,country: country, birthdate: birthdate, gender: AuthUser.getGenderServerCode(gender: gender), language: AuthUser.getLanguageServerCode(language: language), success: { (data, code) -> Void in
            
            let jsonData = JSON(data as Any)
            NSLog("updateUserDetails : \(jsonData)")
            
            switch code {
            case 200, 201:
//                let authUser = AuthUser(id: jsonData[AuthUser.JsonKeys.id].int ?? -1 ,
//                                        name: jsonData[AuthUser.JsonKeys.name].string ?? "",
//                                        accessToken: jsonData[AuthUser.JsonKeys.access_token].string ?? "",
//                                        dateOfBirth: jsonData[AuthUser.JsonKeys.date_of_birth].string,
//                                        gender: AuthUser.getGender(text: jsonData[AuthUser.JsonKeys.gender].string ?? "") ,
//                                        language: AuthUser.getLanguage(text: jsonData[AuthUser.JsonKeys.language].string ?? "") ,
//                                        mobileNumber: jsonData[AuthUser.JsonKeys.mobile_number].string)
                
                //Preferences.setUser(authUser)
                //Preferences.setAccessToken(jsonData[AuthUser.JsonKeys.access_token].string ?? nil)
                UserDefaultsManager.setGender(jsonData[AuthUser.JsonKeys.gender].string ?? "")
                UserDefaultsManager.setLangauge(jsonData[AuthUser.JsonKeys.language].string ?? "")
                UserDefaultsManager.setMobileNo(jsonData[AuthUser.JsonKeys.mobile_number].string ?? "")
                UserDefaultsManager.setBirthDate(jsonData[AuthUser.JsonKeys.date_of_birth].string ?? "")
                
                if AuthUser.getLanguageServerCode(language: language) == "SI" {
                  Localize.setCurrentLanguage("si-LK")
                    
                }
                else if AuthUser.getLanguageServerCode(language: language) == "TA"{
                   Localize.setCurrentLanguage("ta-LK")
                }
                else{
                    Localize.setCurrentLanguage("en")
                    
                }
                
                self.delegate?.registerInfoCallFinished!(true, error: nil, userInfo: nil)
                
            default:
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                self.delegate?.registerInfoCallFinished!(false, error: error, userInfo: nil)
//            default:
//                NSLog("Error registerWithUsername 1")
//                Common.getUnknowError()
//                self.delegate?.registerInfoCallFinished!(false, error: nil, userInfo: nil)
            }
            
            
            
        }) { (error) -> Void in
            NSLog("Error (updateUserDetails): \(error.localizedDescription)")
            self.delegate?.registerInfoCallFinished!(false, error: error, userInfo: nil)
        }
    }
    
}
