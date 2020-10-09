//
//  NotificationListModel.swift
//  SusilaMobile
//
//  Created by Rashminda on 06/10/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationListModel: NSObject {
    
    fileprivate let api = ApiClient()
    var messageList: [Message] = [Message]()
    
    func readNotifications(notificationIDArray: Array<Any>, clearNotificationCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.readNotifications(idArray: notificationIDArray, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                clearNotificationCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                clearNotificationCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (clearNotificationCallFinished): \(error.localizedDescription)")
            clearNotificationCallFinished(false, error, nil)
        }
    }
    func clearNotification(notificationID: Int, clearNotificationCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.clearNotification(notificationID: notificationID, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                clearNotificationCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                clearNotificationCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (clearNotificationCallFinished): \(error.localizedDescription)")
            clearNotificationCallFinished(false, error, nil)
        }
    }
    
    func clearAllNotification(clearNotificationCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.clearAllNotification(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                clearNotificationCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                clearNotificationCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (clearNotificationCallFinished): \(error.localizedDescription)")
            clearNotificationCallFinished(false, error, nil)
        }
    }
    
    func getNotificationCount(getNotificationCountCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ count: Int?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d, MMM yyyy"
        
        let startDate = dateFormatter.string(from: Date())
        let endDate = dateFormatter.string(from: Calendar.current.date(byAdding: .month, value: -1, to: Date())!)
        
        self.getNotificationList(startDate: startDate, endDate: endDate, getNotificationListCallFinished: { (status, error, userInfo) in
            if status {
                var count = 0
                if (self.messageList.count > 0){
                    for message in self.messageList {
                        if message.read == false{
                            count = count + 1
                        }
                    }
                }
                getNotificationCountCallFinished(true, nil, count)
            } else {
                getNotificationCountCallFinished(false, error, nil)
            }
        })
    }
    
    func getNotificationList(startDate: String, endDate: String, getNotificationListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getNotificationList(startDate: startDate, endDate: endDate, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                NSLog("getNotificationList : \(String(describing: jsonArray))")
                
                if let jsonList = jsonArray{
                    
                    self.messageList.removeAll()
                    for jsonObject in jsonList{
                        
                        let message = Message(messageId: jsonObject[Message.JsonKeys.messageId].int ?? -1, messageDate: jsonObject[Message.JsonKeys.messageDate].string ?? "", messageType: jsonObject[Message.JsonKeys.messageType].int ?? -1, message: jsonObject[Message.JsonKeys.message].string ?? "", read: jsonObject[Message.JsonKeys.read].bool ?? false,expanded:false,expandedHeight:150.0)
                        
                        self.messageList.append(message)
                        
                    }
                    
                    getNotificationListCallFinished(true, nil, nil)
                    
                }else{
                    getNotificationListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getNotificationListCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (getNotificationListCallFinished): \(error.localizedDescription)")
            getNotificationListCallFinished(false, error, nil)
        }
    }
    
    
}

