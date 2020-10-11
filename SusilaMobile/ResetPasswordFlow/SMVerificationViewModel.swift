//
//  SMVerificationViewModel.swift
//  SusilaMobile
//
//  Created by Admin on 9/17/19.
//  Copyright © 2019 Kiroshan T. All rights reserved.
//

import SwiftyJSON

class SMVerificationViewModel: NSObject {
    fileprivate let api = ApiClient()
    
    func passwordResetCodeSend(viwer_id:String, otp:String, onComplete: @escaping (_ status: Bool, _ error: NSError?) -> Void) {
        api.passwordResetCodeSend(viwerId:viwer_id, otp:otp , success: { (data, code) -> Void in
            
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
                onComplete(status, nil)
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                Log(message: error.localizedDescription)
                onComplete(false, error)
            }
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (callFinished): \(error.localizedDescription)")
            onComplete(false, error)
        }
    }
    
}

