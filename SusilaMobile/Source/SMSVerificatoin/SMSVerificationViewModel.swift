//
//  SMSVerificationViewModel.swift
//  SusilaMobile
//  Created by Isuru Jayathissa on 2/7/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import Alamofire
import SwiftyJSON

@objc protocol SMSVerificationDelegate {
    @objc optional func smsVerificationCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?)
}
class SMSVerificationViewModel: NSObject {
    //    fileprivate let api = ApiClient()
    var delegate: SMSVerificationDelegate?
    func smsCodeVerify(smsCode: String) {
        self.smsCodeVerify(smsCode: smsCode, success: { (data, code) -> Void in
            
            let jsonData = JSON(data as Any)
            NSLog("updateUserDetails : \(jsonData)")
            
            switch code {
            case 200:
                self.delegate?.smsVerificationCallFinished!(true, error: nil, userInfo: nil)
            default:
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                self.delegate?.smsVerificationCallFinished!(false, error: error, userInfo: nil)
                
            }
            
            
            
        }) { (error) -> Void in
            NSLog("Error (updateUserDetails): \(error.localizedDescription)")
            self.delegate?.smsVerificationCallFinished!(false, error: error, userInfo: nil)
        }
    }
    
    
    internal func smsCodeVerify(smsCode: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + ApiClient.SubUrl.SMSVerify)
        
        let headers: HTTPHeaders = [
            ApiClient.StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            ApiClient.StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters = [
            
            ApiClient.StringKeys.SMSCode:smsCode
            
        ] as [String : Any]
        
        request(url!, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    
    fileprivate func request(_ url: URL, method: HTTPMethod, parameters: [String: Any]?, headers: HTTPHeaders, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        func callAPIrequest(){
            
            Alamofire.request(url.absoluteString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (dataResponse:DataResponse<Any>) in
                
                if let response = dataResponse.response {
                    let validateResult = HttpValidator.validate(response.statusCode)
                    print("validateResult ---- : \(validateResult)")
                    
                    switch validateResult.code{
                    case 200:
                        success(nil, validateResult.code)
                    case 401:
                        Common.logout()
                    default:
                        
                        switch dataResponse.result {
                        case .success( let data):
                            
                            let currentData = JSON(data)
                            print("Data ---- : \(currentData)")
                            success(data as AnyObject?, validateResult.code)
                        case .failure(let error):
                            failure(ErrorHandler.ConnectionTimeout)
                            
                            NSLog("API Failure: \(error)")
                            
                        }
                    }
                    
                }
                
                
            }
        }
        
        callAPIrequest()
        
    }
    
    
}
