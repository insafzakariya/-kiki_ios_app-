//
//  SMPackagePageViewModel.swift
//  SusilaMobile
//
//  Created by Meuru Muthuthanthri on 4/8/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import UIKit
import SwiftyJSON

class SMPackagePageViewController: MenuChiledViewController {
    
    fileprivate let packageViewModel = SMPackageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Subscription"
        packageViewModel.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "home"), style: .plain, target: self, action: #selector(backAction))
    }
    
    @objc func backAction(){
        //self.navigationController?.popViewController(animated: true)
        (UIApplication.shared.delegate as! AppDelegate).goToCorrespondingHomeView(isAfterLogin: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPackageList()
    }
    
    func goToPaymentsPage() {
        let packageList = packageViewModel.packageList
        if packageList.isEmpty{
            backAction()
        }else{
            let package = packageList[0]
            ProgressView.shared.show(view, mainText: nil, detailText: nil)
            packageViewModel.subscribePackage(packageId: package[Package.JsonKeys.id].int ?? -1, callFinished: { (status, error, userInfo) in
                if status {
                    if let packageSubscribe = userInfo?["packageSubscribe"] as? JSON {
                        self.packageViewModel.getCurrentPackage { (status, error, userInfo) in
                            ProgressView.shared.hide()
                            if status {
                                self.loadPackagePage(packageSubscribe: packageSubscribe)
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
    
    func loadPackagePage(packageSubscribe: JSON) {
        let packagePageUrl = (UIApplication.shared.delegate as! AppDelegate).getRemoteConfig()[mobilePaymentGatewayUrlConfigKey].stringValue!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webController = storyboard.instantiateViewController(withIdentifier: "SMWebViewController") as! SMWebViewController
        webController.webViewLink = packagePageUrl + "?token=\(packageSubscribe["tokenHash"].string ?? "")"
        webController.fromPackage = "true"
        webController.backIcon = UIImage(named: "home")
        self.navigationController?.pushViewController(webController, animated: true)
    }
    
    func getPackageList() {
        packageViewModel.getPackageList { (status, error, userInfo) in
            
            ProgressView.shared.hide()
            if status {
                self.goToPaymentsPage()
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
}

// MARK: - LoginDelegate
extension SMPackagePageViewController: PackageDelegate {
    func packageCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?) {
        ProgressView.shared.hide()
        if status {
            let jsonData = JSON(userInfo as Any)
            
            let packageName = jsonData["name"].string ?? ""
            let message = packageName + NSLocalizedString("PACKAGE_ADDED_SUCCESSFULLY".localized(using: "Localizable"), comment: "")
            
            Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: message)
        } else {
            if let error = error {
                switch error.code {
                case ResponseCode.noNetwork.rawValue:
                    Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""))
                default: Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                    
                }
            }
        }
    }
    
    
}
