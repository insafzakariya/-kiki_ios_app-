//
//  SMResetViewModel.swift
//  SusilaMobile
//
//  Created by Admin on 9/16/19.
//  Copyright © 2019 Mr KIROSHAN T. All rights reserved.
//

import SwiftyJSON

class SMResetViewModel: NSObject {
    fileprivate let api = ApiClient()
    
    func passwordResetCodeRequest( genre:String, onComplete: @escaping (_ status: Bool, _ error: NSError?) -> Void) {
        api.passwordResetCodeRequest(number:genre, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                let jsonData = JSON(data as Any)
                let userName = jsonData["userName"].string ?? ""
                let mobileNo = jsonData["mobileNo"].string ?? ""
                let viwerId = jsonData["viwerId"].int ?? -1
                let status = jsonData["status"].bool ?? false
                
                if status {
                    onComplete(true, nil)
                } else {
                    onComplete(false, nil)
                }
                
                mainInstance.userName = userName
                mainInstance.mobileNo = mobileNo
                mainInstance.viwerId = viwerId
                mainInstance.status = status
                
                print("Tester", mainInstance.userName)
                print("Tester", mainInstance.mobileNo)
                print("Tester", mainInstance.viwerId)
                print("Tester", mainInstance.status)
                
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                Log(message: error.localizedDescription)
//                onComplete(false, error)
                
            }
        }) { (error) -> Void in
            //            Common.logout()
            Log(message: error.localizedDescription)
//            onComplete(false, error)
        }
    }
    
}
