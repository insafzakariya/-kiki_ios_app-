//
//  SMHomeViewModel.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/30/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol HomeDelegate {
    /**
     Executes when the login API call retrieves the result.
     
     - parameter status: true if successfully logged in. false if not.
     - parameter error:  Login error.
     */
    @objc optional func fetchProgramsCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?)
    
    /**
     Executes when trailers are fetched from the API
    **/
    @objc optional func fetchTrailersCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?)
}


class SMHomeViewModel: BaseEpisodeModel {

    fileprivate let api = ApiClient()
    
    var delegate: HomeDelegate?
    
    var programList: [Program] = [Program]()
    var trailerList: [Program] = [Program]()
    
    var newCategroyProg = Dictionary<String, Any>()
//    var userHostList = NSMutableArray()

    func dateFormatterForProgramListAPI(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, MMM yyyy"
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
    }
    
    func getSubscribe(programID: Int, getSubscribeCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getSubscribe(programID: programID, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                NSLog("getSubscribe : \(String(describing: jsonArray))")
                
                getSubscribeCallFinished(true, nil, nil)

                
            default:
                let jsonData = JSON(data as Any)
                if let errorCode = jsonData[ErrorJsonKeys.errorCode].int, errorCode == SMErrorCode.DuplicateAction.rawValue{
                    let error = Common.getErrorFromJson(description: "You have subscribed to the program.", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                    getSubscribeCallFinished(false, error, nil)
                }else{
                    let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                    getSubscribeCallFinished(false, error, nil)
                }
                
                
                
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (getSubscribe): \(error.localizedDescription)")
            getSubscribeCallFinished(false, error, nil)
        }
    }
    
    func getUnSubscribe(programID: Int, getSubscribeCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getUnSubscribe(programID: programID, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                NSLog("getUnSubscribe : \(String(describing: jsonArray))")
                
                getSubscribeCallFinished(true, nil, nil)
                
                
            default:
                let jsonData = JSON(data as Any)
                if let errorCode = jsonData[ErrorJsonKeys.errorCode].int, errorCode == SMErrorCode.DuplicateAction.rawValue{
                    let error = Common.getErrorFromJson(description: "You have unsubscribed to the program.", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                    getSubscribeCallFinished(false, error, nil)
                }else{
                    let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                    getSubscribeCallFinished(false, error, nil)
                }
                
                
                
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (getUnSubscribe): \(error.localizedDescription)")
            getSubscribeCallFinished(false, error, nil)
        }
    }
    
    func likeProgram(programId: Int, likeProgramCallFinished: @escaping (_ status: Bool, _ error: NSError?) -> Void) {
        api.likeProgram(programId: programId, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                likeProgramCallFinished(true, nil)
            default:
                let jsonData = JSON(data as Any)
                
                if let errorCode = jsonData[ErrorJsonKeys.errorCode].int, errorCode == SMErrorCode.DuplicateAction.rawValue{
                    let error = Common.getErrorFromJson(description: "You have already liked this video.", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                    likeProgramCallFinished(false, error)
                }else{
                    let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                    likeProgramCallFinished(false, error)
                }
            }
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (likeProgram): \(error.localizedDescription)")
            likeProgramCallFinished(false, error)
        }
    }
    
    func likeProgram_v2(contentType: Int, contentId: Int, actionType: Int, likeProgramCallFinished: @escaping (_ status: Bool, _ error: NSError?) -> Void) {
        api.likeProgram_v2(contentType: contentType, contentId: contentId, actionType: actionType, success: { (data, code) -> Void in
            
            if code == 200 {
                likeProgramCallFinished(true, nil)
                
            } else {
                likeProgramCallFinished(false, nil)
            }
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (likeProgram): \(error.localizedDescription)")
            likeProgramCallFinished(false, error)
        }
    }
    
    func trailer(programId: Int, trailerProgramCallFinished: @escaping (_ status: Bool, _ error: NSError?) -> Void) {
        api.trailer(programId: programId, success: { (data, code) -> Void in
           
            if code == 200 {
                
                let jsonData = JSON(data as Any)
                
                if let like = jsonData[0]["isliked"].bool {
                    print(like)
                    mainInstance.like=like
                }
                if let list = jsonData[0]["subscribed"].bool {
                    print(list)
                    mainInstance.list=list
                }
                trailerProgramCallFinished(true, nil)
            }
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (likeProgram): \(error.localizedDescription)")
            trailerProgramCallFinished(false, error)
        }
    }

    
}
