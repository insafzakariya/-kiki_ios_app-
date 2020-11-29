//
//  AppIconManager.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2020-11-29.
//

import Foundation
import Firebase

//TODO: Set info on plist

class AppIconManager{
    
    enum AppIconManagerConfigKeys:String{
        case APP_ICON = "APP_ICON"
    }
    
    private var remoteConfig:RemoteConfig
    private var appIconName:String?
    
    init(remoteConfig:RemoteConfig) {
        self.remoteConfig = remoteConfig
        self.appIconName = remoteConfig[AppIconManagerConfigKeys.APP_ICON.rawValue].stringValue
    }
    
    func setAppIcon(){
        if #available(iOS 10.3, *) {
            if let name = self.appIconName{
                UIApplication.shared.setAlternateIconName(name) { (error) in
                    if let e = error{
                        Log(e.localizedDescription)
//                        UIApplication.shared.setAlternateIconName(nil)
                    }else{
                        Log("App icon Changed Successfully")
                    }
                }
            }else{
                Log("Error fetching name from remote config")
            }
        }else{
            Log("setAlternateIconName not supported")
        }
    }
}
