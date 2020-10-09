//
//  SMWebViewController.swift
//  SusilaMobile
//
//  Created by Isuru_Jayathissa on 2/15/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import FirebaseRemoteConfig
import SwiftyJSON
class SMWebViewController: MenuChiledViewController {

    var webViewLink: String = ""
    @IBOutlet weak var sWebView: UIWebView!
    var remoteConfig: RemoteConfig!
    var fromPackage : String = ""
    var backIcon: UIImage!
    @objc
    var fromEpisode : String = ""
    fileprivate let packageViewModel = SMPackageViewModel()

    override func viewDidLoad() {
        
        super.viewDidLoad()
//        let leftBar = UIBarButtonItem(image: UIImage(named: "backIcon"), style: .plain, target: self, action: #selector(SMWebViewController.goBack))
//        self.navigationController?.navigationItem.leftBarButtonItem = leftBar

        if fromEpisode == "true"{
            self.navigationController?.navigationBar.isHidden = false
            self.setNavigationBar()

        getPackageList()
        }
        else{
        
        remoteConfig = (UIApplication.shared.delegate as! AppDelegate).getRemoteConfig()

        if fromPackage == "true"{
//            webViewLink = remoteConfig[licenseAgreementConfigKey].stringValue!

        }
        else{
        webViewLink = remoteConfig[licenseAgreementConfigKey].stringValue!
        }
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        
        sWebView.delegate = self
        if let url = NSURL (string: webViewLink){
            let requestObj = NSURLRequest(url: url as URL);
            sWebView.loadRequest(requestObj as URLRequest);
        }
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: self.backIcon ?? UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(backAction))
        
        
        
    }
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "")
//        self.navigationController?.navigationBar.isTranslucent = true
//        navBar.isTranslucent = true
        navBar.tintColor = UIColor.white
        navBar.backgroundColor = UIColor.black
        navBar.barTintColor = UIColor.black

//        navBar.backgroundColor = UIColor.black
//        navigationController?.navigationBar.barTintColor = UIColor.green

//        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(zone))
//        navItem.rightBarButtonItem = doneItem
        navItem.leftBarButtonItem = UIBarButtonItem(image: self.backIcon ?? UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(backAction))

        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    @objc func backAction(){
        
        /*if fromEpisode == "true"{
            (UIApplication.shared.delegate as! AppDelegate).goToCorrespondingHomeView(isAfterLogin: false)
        } else {
            self.navigationController?.popViewController(animated: true)
            if (self.navigationController?.topViewController is SMPackagePageViewController) {
                self.navigationController?.popViewController(animated: true)
            }
        }*/
        checkSbuStatus()
    }
    
    func checkSbuStatus() {
        SMPackageViewModel().getCurrentPackage { (status, error, userInfo) in
            if status {
                if let package = userInfo?["currentPackage"] as? JSON{
                    let packageId = package[Package.JsonKeys.id].numberValue
                    let remoteConfig = (UIApplication.shared.delegate as! AppDelegate).getRemoteConfig()
                    let isSpecialUser = Preferences.getUserId() == remoteConfig[specialUserIdConfigKey].stringValue!
                    if (packageId == 1 && !isSpecialUser) {
                        mainInstance.subscribeStatus = true
                        self.navigationController?.popViewController(animated: true)
                        if (self.navigationController?.topViewController is SMPackagePageViewController) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        mainInstance.subscribeStatus = false
                        (UIApplication.shared.delegate as! AppDelegate).goToCorrespondingHomeView(isAfterLogin: false)
                    }
                    
                }
            } else {
                if let error = error {
                    print("Error occurred while fetching the current package: \(error)")
                }
            }
        }
    }
    
    func getPackageList() {
        packageViewModel.getPackageList { (status, error, userInfo) in
            
            ProgressView.shared.hide()
            if status {
                if (userInfo?["list"] as? JSON) != nil{
                    //                    self.descriptionLabel.text = package[0]["description"].string ?? ""
                    self.self.getPackageURL()
                }
            } else {
                if let error = error {
                    switch error.code {
                    case ResponseCode.noNetwork.rawValue:
                        Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""), perent: self)
                        
                    default: Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                        
                    }
                }
            }
        }
    }
    func getPackageURL() {
        
        let packageList = packageViewModel.packageList
        if packageList.isEmpty{
            print("asdasdasdsadsadas")
        }else{
            print("xxxxxxx")
            
            let package = packageList[0]
            ProgressView.shared.show(view, mainText: nil, detailText: nil)
            packageViewModel.subscribePackage(packageId: package[Package.JsonKeys.id].int ?? -1, callFinished: { (status, error, userInfo) in
                if status {
                    if let packageSubscribe = userInfo?["packageSubscribe"] as? JSON {
                        self.packageViewModel.getCurrentPackage { (status, error, userInfo) in
                            ProgressView.shared.hide()
                            NSLog("getCurrentPackageCode : \(status)")
                            //NSLog("getCurrentPackageCode : \(error)")
                            //NSLog("getCurrentPackageCode : \(userInfo)")
                            if status {
                                if let package = userInfo?["currentPackage"] as? JSON{
                                    let packageId = package[Package.JsonKeys.id]
                                    
                                    
//
                                    if (packageId == 46 || packageId == 81 || packageId == 101 || packageId == 106) {
                                        
                                        //                                        let alertMessage = NSLocalizedString("PACKAGE_ALREADY_SUBSCRIBED".localized(using: "Localizable"), comment: "")
                                        //                                        self.displayPackageActivationWarningOverlay(alertMessage, packageSubscribe: packageSubscribe)
                                        let packagePageUrl = (UIApplication.shared.delegate as! AppDelegate).getRemoteConfig()[mobilePaymentGatewayUrlConfigKey].stringValue!
                                        
                                        self.webViewLink = packagePageUrl + "?token=\(packageSubscribe["tokenHash"].string ?? "")"
                                        print("1222",self.webViewLink)
                                        
                                    } else {
                                        //                                        let alertMessage = NSLocalizedString("ACTIVATE_THIS_PACKAGE".localized(using: "Localizable"), comment: "")
                                        //                                        self.displayPackageActivationWarningOverlay(alertMessage, packageSubscribe: packageSubscribe)
                                        
                                        let packagePageUrl = (UIApplication.shared.delegate as! AppDelegate).getRemoteConfig()[mobilePaymentGatewayUrlConfigKey].stringValue!
                                        
                                        self.webViewLink = packagePageUrl + "?token=\(packageSubscribe["tokenHash"].string ?? "")"
                                        print("2222",self.webViewLink)
                                        self.sWebView.delegate = self
                                        print("3222",self.webViewLink)
                                        
                                        if let url = NSURL (string: self.webViewLink){
                                            let requestObj = NSURLRequest(url: url as URL);
                                            self.sWebView.loadRequest(requestObj as URLRequest);
                                        }
                                    }
                                }
                            } else {
                                if let error = error {
                                    switch error.code {
                                    case ResponseCode.noNetwork.rawValue:
                                        Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""), perent: self)
                                    default: Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ProgressView.shared.hide()
                    if let error = error {
                        switch error.code {
                        case ResponseCode.noNetwork.rawValue:
                            Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""), perent: self)
                        default: Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                        }
                    }
                }
            })
        }
        
    }
//    func goBack() {
//       let view = self.navigationController?.popViewController(animated: true)
//        print(view ?? "")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SMWebViewController: UIWebViewDelegate {

    func webViewDidFinishLoad(_ webView: UIWebView) {
        ProgressView.shared.hide()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        ProgressView.shared.hide()
    }
}
