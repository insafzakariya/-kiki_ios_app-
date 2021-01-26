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
        case APP_ICON = "apple_app_image"
    }
    
    private var remoteConfig:RemoteConfig
    private var appIconName:String?
    
    init(remoteConfig:RemoteConfig) {
        self.remoteConfig = remoteConfig
        self.appIconName = remoteConfig[AppIconManagerConfigKeys.APP_ICON.rawValue].stringValue
    }
    
    func setAppIcon(){
        if #available(iOS 10.3, *) {
            guard UIApplication.shared.supportsAlternateIcons else {
                return
            }
            
            if let name = self.appIconName{
                let storedAppName = UserDefaultsManager.getAppIconName() ?? ""
                if name != storedAppName{
                    UIApplication.shared.setAlternateIconName(name) { (error) in
                        if let e = error{
                            Log(e.localizedDescription)
                            UIApplication.shared.setAlternateIconName(nil)
                        }else{
                            Log("App icon Changed Successfully")
                            UserDefaultsManager.setAppIconName(for: name)
                        }
                    }
                }
            }else{
                Log("Error fetching name from remote config")
            }
        }else{
            Log("setAlternateIconName not supported")
        }
    }
    
    
    //    private func setApplicationIconName(_ iconName: String) {
    //        if #available(iOS 10.3, *) {
    //            if UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) && UIApplication.shared.supportsAlternateIcons {
    //                typealias setAlternateIconName = @convention(c) (NSObject, Selector, NSString, @escaping (NSError) -> ()) -> ()
    //                let selectorString = "_setAlternateIconName:completionHandler:"
    //                let selector = NSSelectorFromString(selectorString)
    //                let imp = UIApplication.shared.method(for: selector)
    //                let method = unsafeBitCast(imp, to: setAlternateIconName.self)
    //                method(UIApplication.shared, selector, iconName as NSString, { _ in })
    //            }
    //        } else {
    //            // Fallback on earlier versions
    //        }
    //    }
}
