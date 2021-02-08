//
//  AppDelegate.swift
//  KiKi
//
//  Created by Isuru Jayathissa on 1/13/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import Firebase
import UserNotifications
import IQKeyboardManager
import GoogleSignIn
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    static var IS_APP_ICON_CHANGED:Bool = false
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var remoteConfig: RemoteConfig!
    static var Home_Request_Count:Int = 0
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        fetchRemoteConfig()
        if let token = Messaging.messaging().fcmToken {
            Log("FCM Token \(token)")
            updateFCMToken(deviceId: token)
        }
        
        /*if UIDevice.current.userInterfaceIdiom == .phone {
         print("running on iPhone")
         } else if UIDevice.current.userInterfaceIdiom == .pad {
         print("running on iPhone")
         }*/
        
        let translateSet = defaults.object(forKey: "LanguageSelect") as? String
        if let accessToken = UserDefaultsManager.getAccessToken(), !accessToken.isEmpty {
            
            let defaults = UserDefaults.standard
            
            if translateSet == "true" {
                defaults.set( "true", forKey: "loadToMainLogin")
            }
            defaults.synchronize()
            if (isMusicMode()) {
                gotoMusicView()
            } else {
                if UserDefaultsManager.getMobileNo() == nil || UserDefaultsManager.getMobileNo() == ""{
                    
                    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                    let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "SMRegisterInfoViewController") as! SMRegisterInfoViewController
                    //                    rootViewController.fromRegisterVwe = "true"
                    navigationController.viewControllers = [rootViewController]
                    self.window?.rootViewController = navigationController
                    
                    
                }
                else{
                    gotoHomeView()
                }
                
            }
        }
        else{
            if translateSet == "true" {
                
                let defaults = UserDefaults.standard
                defaults.set( "true", forKey: "loadToMainLogin")
                defaults.synchronize()
                
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "SMSocialMediaLoginViewController") as UIViewController
                navigationController.viewControllers = [rootViewController]
                self.window?.rootViewController = navigationController
            }
        }
        
        
        // Override point for customization after application launch.
        GBVersionTracking.track()
        if GBVersionTracking.isFirstLaunchEver(){
            //setupAppFirstTimeLoading()
        }else{
            
        }
        
        //google sing in
        GIDSignIn.sharedInstance().clientID = kGoogleClientID
        //        GIDSignIn.sharedInstance().serverClientID = kGoogleClientID
        
        var configureError: NSError?
        //assert(configureError == nil, "Error configuring Google services: \(configureError)")
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        IQKeyboardManager.shared().isEnabled = true
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    
    func fetchRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let remoteConfigSettings = RemoteConfigSettings()
        remoteConfig.configSettings = remoteConfigSettings
        let remoteConfigDefaults: [String: NSObject] = [
            licenseAgreementConfigKey: "https://cdn.kiki.lk/User%20Agreement/" as NSObject,
            contactTelephoneConfigKey: "0703001110" as NSObject,
            contactEmailConfigKey: "customercare@mobilevisions.lk" as NSObject,
            enableSMSVerificationConfigKey: true as NSObject,
            mobilePaymentGatewayUrlConfigKey: "www.google.lk" as NSObject
        ]
        remoteConfig.setDefaults(remoteConfigDefaults)
        fetchConfig()
    }
    
    func fetchConfig() {
        remoteConfig.fetchAndActivate { (status, error) in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData{
                kAPIBaseUrl = self.remoteConfig[baseURL_LIVE].stringValue!
                IAPBaseURL = self.remoteConfig[IAP_LIVE].stringValue!
                let appStoreManager = AppStoreManager(remoteConfig: self.remoteConfig)
                AppStoreManager.IS_ON_REVIEW = appStoreManager.isCurrentlyOnReview()
            }else{
                Log("Error occurred while fetching configs: \(error?.localizedDescription ?? "No error available.")")
            }
        }
        kAPIBaseUrl = self.remoteConfig[baseURL_LIVE].stringValue!
        IAPBaseURL = remoteConfig[IAP_LIVE].stringValue!
        Log("Base URL: \(kAPIBaseUrl)")
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if (UserDefaultsManager.getAccessToken() != nil) {
            checkPackage(false)
        }
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        let fbDidHandle = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url as URL?)
        
        return googleDidHandle || fbDidHandle
    }
    
    // MARK: - Navigation
    
    func gotoLoginView(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "SMSocialMediaLoginViewController") as UIViewController
        navigationController.viewControllers = [rootViewController]
        self.window?.rootViewController = navigationController
        
    }
    
    func gotoRegisterView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "SMLoginViewController")
        self.window!.rootViewController = loginViewController
    }
    
    func checkPackage(_ isAfterLogin: Bool) {
        SMPackageViewModel().getCurrentPackage { (status, error, userInfo) in
            if status {
                if let package = userInfo?["currentPackage"] as? JSON{
                    let packageId = package[Package.JsonKeys.id].numberValue
                    let remoteConfig = (UIApplication.shared.delegate as! AppDelegate).getRemoteConfig()
                    let isSpecialUser = UserDefaultsManager.getUserId() == remoteConfig[specialUserIdConfigKey].stringValue!
                    if (isAfterLogin && self.isMusicMode() && packageId == 1 && !isSpecialUser) {
                        mainInstance.subscribeStatus = true
                        if AppStoreManager.IS_ON_REVIEW{
                            UIHelper.makeNoContentAlert(on: self.window!)
                        }else{
                            UIHelper.makeSubscribeToListenAlert(on: self.window!)
                        }} else {
                            mainInstance.subscribeStatus = false
                        }
                }
            } else {
                if let error = error {
                    print("Error occurred while fetching the current package: \(error)")
                    if (error.code == 1017) {
                        Common.logout()
                    }
                }
            }
        }
    }
    
    func isMusicMode() -> Bool {
        return UserDefaults.standard.bool(forKey: "isMusicOn")
    }
    
    func gotoHomeView(isAfterLogin: Bool = true) {
        UserDefaults.standard.set(false, forKey: "isMusicOn")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeNavController = storyboard.instantiateViewController(withIdentifier: "HomeNavController") as! UINavigationController
        let drawerViewController =  storyboard.instantiateViewController(withIdentifier: "SMMainMenuViewController") as! SMMainMenuViewController
        drawerViewController.homeNavController = homeNavController
        drawerViewController.myHomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeVw") as! HomeTableViewController
        
        homeNavController.viewControllers.removeAll()
        
        homeNavController.setViewControllers([drawerViewController.myHomeViewController], animated: false)
        
        let drawerController: KYDrawerController = KYDrawerController(drawerDirection: KYDrawerController.DrawerDirection.left, drawerWidth: 280)
        drawerController.mainViewController = homeNavController;
        drawerController.drawerViewController = drawerViewController
        
        self.window!.rootViewController = drawerController
        self.window!.makeKeyAndVisible()
    }
    
    func gotoMusicView(isAfterLogin: Bool = true) {
        UserDefaults.standard.set(true, forKey: "isMusicOn")
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let musicDashboardNavController = storyboard.instantiateViewController(withIdentifier: "DashboardNavController") as! UINavigationController
        let dashboardViewController =  storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        musicDashboardNavController.setViewControllers([dashboardViewController], animated: false)
        
        let drawerViewController =  storyboard.instantiateViewController(withIdentifier: "SMMainMenuViewController") as! SMMainMenuViewController
        drawerViewController.homeNavController = musicDashboardNavController
        drawerViewController.myHomeViewController = dashboardViewController
        
        let drawerController: KYDrawerController = KYDrawerController(drawerDirection: KYDrawerController.DrawerDirection.left, drawerWidth: 280)
        drawerController.mainViewController = musicDashboardNavController
        drawerController.drawerViewController = drawerViewController
        
        
        self.window!.rootViewController = drawerController
        self.window!.makeKeyAndVisible()
        checkPackage(isAfterLogin)
    }
    
    func goToCorrespondingHomeView(isAfterLogin: Bool) {
        
        if (isMusicMode()) {
            self.gotoMusicView(isAfterLogin: isAfterLogin)
        } else {
            self.gotoHomeView(isAfterLogin: isAfterLogin)
        }
    }
    
    func getRootViewController() -> KYDrawerController{
        return window?.rootViewController as! KYDrawerController
    }
    
    func loadChannelView() {
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "SMChannelListNavViewController") as! UINavigationController
        elDrawer.mainViewController = navigationController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
    }
    
    func getRemoteConfig() -> RemoteConfig {
        return remoteConfig;
    }
    
    func updateFCMToken(deviceId: String) {
        SMLaunchViewController().updateFCMToken(deviceId: deviceId, updateFCMTokenCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    print("FCM Token Updated")
                })
            }
        })
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([])
        print("Body: ", notification.request.content.body)
        let alert = UIAlertController(title: nil,
                                      message: notification.request.content.body,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK_BUTTON_TITLE".localizedString, style: UIAlertAction.Style.default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        //let targetValue = userInfo["type"] as? String ?? "0"
        
        notifyInstance.status = true
        notifyInstance.title = userInfo["title"] as? String ?? ""
        notifyInstance.body = userInfo["body"] as? String ?? ""
        notifyInstance.image_url = userInfo["image_url"] as? String ?? ""
        notifyInstance.type = userInfo["type"] as? String ?? ""
        notifyInstance.content_type = userInfo["content_type"] as? String ?? ""
        notifyInstance.content_id = userInfo["content_id"] as? String ?? ""
        notifyInstance.date_time = userInfo["date_time"] as? String ?? ""
        
        if notifyInstance.type == "0" {
            gotoHomeView()
            //alert(message: "Video: "+notifyInstance.content_id)
        } else if notifyInstance.type == "1" {
            gotoMusicView()
        }
        completionHandler()
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}

