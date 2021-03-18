//
//  AppStoreManager.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 10/14/20.
//

import Foundation
import FirebaseRemoteConfig

enum AppStoreManagerConfigKeys:String{
    case IS_ON_REVIEW = "APPLE_VERSION_REVIEW"
    case VERSION = "APPLE_VERSION"
}

class AppStoreManager{
    
    public static var IS_ON_REVIEW:Bool = false
    private var remoteConfig:RemoteConfig
    
     init(remoteConfig:RemoteConfig) {
        self.remoteConfig = remoteConfig
    }
    
    func isCurrentlyOnReview() -> Bool{
        if let currentAppVersion = getCurrentAppVersion(),
           let remoteAppVersion = getReviewVersion(){
            if currentAppVersion == remoteAppVersion{
                return isOnReview()
            }
        }
        return false
    }
    
    
    private func getReviewVersion() -> String?{
        if let version = remoteConfig[AppStoreManagerConfigKeys.VERSION.rawValue].stringValue{
            Log("App version specified in remote config: \(version)")
            return version
        }
        return nil
    }
    
    private func getCurrentAppVersion() -> String?{
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            Log("Current app version: \(appVersion)")
            return appVersion
        }
        return nil
    }
    
    private func isOnReview() -> Bool{
        let val = remoteConfig[AppStoreManagerConfigKeys.IS_ON_REVIEW.rawValue].boolValue
        Log("is App on review: \(val)")
        return val
    }
}

@objc class OBJCAppStoreManager:NSObject{
    
    @objc class func isOnReview() -> Bool{
        return AppStoreManager.IS_ON_REVIEW
    }
}
