//
//  SMPackageViewModel.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 2/17/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import SwiftyJSON

@objc protocol PackageDelegate {
    
    @objc optional func packageCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?)
    
}



class SMPackageViewModel: NSObject {

    fileprivate let api = ApiClient()
    
    var delegate: PackageDelegate?
    var packageList: [JSON] = [JSON]()
    
    func validate(promoCode: String) {
        api.validatePromoCode(promoCode: promoCode, success: { (data, code) -> Void in
            
            
            let jsonData = JSON(data as Any)
            NSLog("userLogin : \(jsonData)")
            
            switch code {
            case 200:
                self.delegate?.packageCallFinished!(true, error: nil, userInfo: data as! [String : AnyObject]?)
                

            default:
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                self.delegate?.packageCallFinished!(false, error: error, userInfo: nil)
                
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (Login): \(error.localizedDescription)")
            self.delegate?.packageCallFinished!(false, error: error, userInfo: nil)
        }
    }
    
    func getCurrentPackage(callFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: Any]?) -> Void){
        
        api.getCurrentPackage(success: { (data, code) in
            let jsonData = JSON(data as Any)
            NSLog("getCurrentPackage : \(jsonData)")
            
            
            switch code {
            case 200:
                
                let parameters = [
                    "currentPackage":jsonData,
                    ] as [String : Any]
                callFinished(true, nil, parameters as [String : Any]?)
                
            default:
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                callFinished(false, error, nil)
            }
        }) { (error) in
            NSLog("Error (getCurrentPackage): \(error.localizedDescription)")
            callFinished(false, error, nil)
        }
    }
    
    func getPackageList(callFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: Any]?) -> Void){
        
        api.getPackageList(success: { (data, code) in
            let jsonData = JSON(data as Any)
            NSLog("getPackageList : \(jsonData)")
            
            switch code {
            case 200:
                self.packageList.removeAll()
                if let jsonArray = jsonData.array{
                    self.packageList = jsonArray
                }
                
                let parameters = [
                    "list":jsonData,
                    ] as [String : Any]
                callFinished(true, nil, parameters as [String : Any]?)
            
            default:
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                callFinished(false, error, nil)
                
            }
        }) { (error) in
            NSLog("Error (getPackageList): \(error.localizedDescription)")
            callFinished(false, error, nil)
        }
    }
    
    func subscribePackage(packageId:Int, callFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: Any]?) -> Void){
        
        api.subscribePackage(packageId: packageId, success: { (data, code) in
            let jsonData = JSON(data as Any)
            NSLog("subscribePackage : \(jsonData)")
            
            switch code {
            case 200:
                
                
                let parameters = [
                    "packageSubscribe":jsonData,
                    ] as [String : Any]
                callFinished(true, nil, parameters as [String : Any]?)
                
            default:
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                callFinished(false, error, nil)
                
            }
        }) { (error) in
            NSLog("Error (subscribePackage): \(error.localizedDescription)")
            callFinished(false, error, nil)
        }
    }
    
}
