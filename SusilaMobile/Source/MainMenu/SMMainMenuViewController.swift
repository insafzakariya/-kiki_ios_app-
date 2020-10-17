//
//  SMMainMenuViewController.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/26/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import FirebaseRemoteConfig

class SMMainMenuViewController: UIViewController {
    
    @IBOutlet weak var heightPackageConstrain: NSLayoutConstraint!
    @IBOutlet weak var btnPackage: UIButton!
    @IBOutlet weak var topPackageContrain: NSLayoutConstraint!
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberNickName: UILabel!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var logoutChildModeContraint: NSLayoutConstraint!
    @IBOutlet weak var logoutContactSupportConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnChildMode: UIButton!
    @IBOutlet var menuView: UIView!
    // @IBOutlet weak var btnGuide: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnContactSupport: UIButton!
    @IBOutlet weak var btLogOut: UIButton!
    
    weak var homeNavController : UINavigationController!
    var remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()
    var myHomeViewController : UIViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkReviewStatus()
        memberName.text = "Welcome \(UserDefaultsManager.getUsername() ?? "")"
        btnChildMode.setTitle(NSLocalizedString("CHILD_MODE".localized(using: "Localizable"), comment: ""), for: .normal)
    }
    
    
    private func checkReviewStatus(){
        getRemoteConfig {
            
            if AppStoreManager.IS_ON_REVIEW{
                //                self.heightPackageConstrain.constant = 0.0;
                //                self.topPackageContrain.constant = 0.0;
                self.btnPackage.isHidden = true
            }
        }
    }
    
    private func getRemoteConfig(onSuccess:@escaping ()->()){
        var expirationDuration = 3600
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                self.remoteConfig.activateFetched()
                onSuccess()
            } else {
                Log("Error occurred while fetching configs: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (UserDefaults.standard.bool(forKey: "isMusicOn")) {
            logoutChildModeContraint.priority = UILayoutPriority(rawValue: 1)
            logoutContactSupportConstraint.priority = UILayoutPriority(rawValue: 100)
            btnChildMode.isHidden = true
            menuView.backgroundColor = Constants.videoAppBackColor
            memberName.textColor = UIColor.white
            // btnn n nGuide.titleLabel?.textColor = UIColor.black
            btnPackage.titleLabel?.textColor = UIColor.white
            btnSettings.titleLabel?.textColor = UIColor.white
            btnContactSupport.titleLabel?.textColor = UIColor.white
            btLogOut.titleLabel?.textColor = UIColor.white
        } else {
            logoutChildModeContraint.priority = UILayoutPriority(rawValue: 100)
            logoutContactSupportConstraint.priority = UILayoutPriority(rawValue: 1)
            btnChildMode.isHidden = false
            menuView.backgroundColor = UIColor.black
            memberName.textColor = UIColor.white
            // btnGuide.titleLabel?.textColor = UIColor.white
            btnPackage.titleLabel?.textColor = UIColor.white
            btnSettings.titleLabel?.textColor = UIColor.white
            btnContactSupport.titleLabel?.textColor = UIColor.white
            btLogOut.titleLabel?.textColor = UIColor.white
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func tappedSettingButton(_ sender: Any) {
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        let controller = storyboard?.instantiateViewController(withIdentifier: "settingVw") as! SettingViewController
        
        homeNavController.viewControllers.removeAll()
        homeNavController.setViewControllers([self.myHomeViewController, controller], animated: false)
        elDrawer.mainViewController = homeNavController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        
    }
    @IBAction func tappedLicenseAgreementButton(_ sender: Any) {
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        let controller = storyboard?.instantiateViewController(withIdentifier: "SMWebViewController") as! SMWebViewController
        controller.webViewLink = remoteConfig[licenseAgreementConfigKey].stringValue!
        
        homeNavController.viewControllers.removeAll()
        homeNavController.setViewControllers([self.myHomeViewController, controller], animated: false)
        elDrawer.mainViewController = homeNavController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
    }
    
    @IBAction func tappedChannelsButton(_ sender: Any) {
        
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        
        homeNavController.viewControllers.removeAll()
        homeNavController.setViewControllers([self.myHomeViewController], animated: false)
        elDrawer.mainViewController = homeNavController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        
    }
    
    
    @IBAction func tappedFBPageButton(_ sender: Any) {
        
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "SMWebViewController") as! SMWebViewController
        controller.webViewLink = kFBlink
        
        homeNavController.viewControllers.removeAll()
        homeNavController.setViewControllers([self.myHomeViewController, controller], animated: false)
        elDrawer.mainViewController = homeNavController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        
    }
    
    
    @IBAction func tappedPackageButton(_ sender: Any) {
        self.navigateToPackagePage()
    }
    
    func navigateToPackagePage() {
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "SMPackagePageViewController") as! SMPackagePageViewController
        
        homeNavController.viewControllers.removeAll()
        homeNavController.setViewControllers([self.myHomeViewController, controller], animated: false)
        elDrawer.mainViewController = homeNavController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
    }
    
    @IBAction func tappedNotificationButton(_ sender: Any) {
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "SMNotificationViewController") as! SMNotificationViewController
        
        homeNavController.viewControllers.removeAll()
        homeNavController.setViewControllers([self.myHomeViewController, controller], animated: false)
        elDrawer.mainViewController = homeNavController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
    }
    
    @IBAction func tappedCantactusButton(_ sender: Any) {
        
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "SMContactUsViewController") as! SMContactUsViewController
        homeNavController.viewControllers.removeAll()
        homeNavController.setViewControllers([self.myHomeViewController, controller], animated: false)
        //        controller.phoneNumberString = remoteConfig[contactTelephoneConfigKey].stringValue!
        //        controller.emailAddressString = remoteConfig[contactEmailConfigKey].stringValue!
        elDrawer.mainViewController = homeNavController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        
    }
    
    @IBAction func tappedSettingsButton(_ sender: Any) {
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "SMSettingsPageViewController") as! SMSettingsPageViewController
        
        homeNavController.viewControllers.removeAll()
        homeNavController.setViewControllers([self.myHomeViewController, controller], animated: false)
        elDrawer.mainViewController = homeNavController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
    }
    
    @IBAction func tappedProfileButton(_ sender: Any) {
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "SMProfileViewController") as! SMProfileViewController
        
        homeNavController.viewControllers.removeAll()
        homeNavController.setViewControllers([self.myHomeViewController, controller], animated: false)
        elDrawer.mainViewController = homeNavController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
    }
    
    
    @IBAction func tappedLogoutButton(_ sender: AnyObject) {
        
        
        let alertTitle = NSLocalizedString("LOGOUT_CONFIRM_ALERT_TITLE".localized(using: "Localizable"), comment: "")
        let alertMessage = NSLocalizedString("LOGOUT_CONFIRM_ALERT_MESSAGE".localized(using: "Localizable"), comment: "")
        
        let alert = UIAlertController(title: alertTitle, message:alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action) -> Void in            
            self.homeNavController.removeFromParent()
            
            Common.logout()
            
        }))
        showDetailViewController(alert, sender: nil)
        
    }
}
