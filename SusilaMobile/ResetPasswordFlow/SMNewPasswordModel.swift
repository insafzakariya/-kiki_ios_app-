//
//  SMNewPasswordModel.swift
//  SusilaMobile
//
//  Created by Admin on 9/17/19.
//  Copyright © 2019 Mr KIROSHAN T. All rights reserved.
//

import SwiftyJSON

class SMNewPasswordModel: NSObject {
    fileprivate let api = ApiClient()
    
    func resetPasswordSend(viwer_id:String, password:String, callFinished: @escaping (_ status: Bool, _ error: NSError?) -> Void) {
        api.resetPasswordSend(viwerId:viwer_id, password:password , success: { (data, code) -> Void in
            
            switch code {
            case 200:
                let jsonData = JSON(data as Any)
                
                
                let userName = jsonData["userName"].string ?? ""
                let mobileNo = jsonData["mobileNo"].string ?? ""
                let viwerId = jsonData["viwerId"].int ?? -1
                let status = jsonData["status"].bool ?? false
                
                mainInstance.userName = userName
                mainInstance.mobileNo = mobileNo
                mainInstance.viwerId = viwerId
                mainInstance.status = status
                
                callFinished(true, nil)
                
                
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                callFinished(false, error)
                
            }
            
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (callFinished): \(error.localizedDescription)")
            callFinished(false, error)
        }
    }
    
    func validate(password: String?, conPassword: String?) -> StatusCode {
        if let passwordString = password, passwordString.isEmpty{
            return .failedValidation(NSLocalizedString("ENTER_VALID_PASSWORD".localized(using: "Localizable"), comment: ""))
        }else if let conPasswordString = conPassword, conPasswordString.isEmpty || conPasswordString != password {
            return .failedValidation(NSLocalizedString("PASSWORD_NOT_MATCH".localized(using: "Localizable"), comment: ""))
        }
        
        return .passedValidation
    }
    
}

