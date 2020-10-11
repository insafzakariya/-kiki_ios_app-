//
//  Common.swift
//
//  Created by Isuru Jayathissa
//  Copyright © 2016 Isuru Jayathissa. All rights reserved.
//

import Reachability
import FBSDKLoginKit
import PhoneNumberKit

class Common: NSObject {

    /**
     Checks for network connection availability.
     
     - returns: true if connection available. false if not.
     */
    class func isNetworkAvailable() -> Bool {
        return Reachability.forInternetConnection().isReachable()
    }
    
    class func showAlert(alertTitle:String, alertMessage:String, perent: UIViewController? = nil){
        
//        var perent = perent
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        if let perent = perent{
                perent.showDetailViewController(alert, sender: nil)
        }else{
            let getPerent = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
            getPerent.showDetailViewController(alert, sender: nil)
        }
        
    }
    
    class func getUnknowError(){
        Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("ERROR_UNKNOW".localized(using: "Localizable"), comment: ""))
    }
    
//    class func createAccessToken(accessToken:String) -> String{
//        return StringKeys.BEARER + " " + accessToken
//    }
    
    class func mobileNovalidate(phoneNumber: String, regionCode: String) -> Bool {
        var results = true
        if (ValidationManager.isSriLankanPhoneNumber(phoneNumber)) {
            let PHONE_REGEX = "^(\\+\\d{2})[7][0-9]{8}"
            //"^\\d{3}\\d{3}\\d{4}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            results =  phoneTest.evaluate(with: phoneNumber)
        }
        do {
            let num = try PhoneNumberKit().parse(phoneNumber, withRegion: regionCode, ignoreType: true)
            print("Validated the mobile number: " + num.numberString)
            return results
        } catch {
            return false
        }
    }
    
    class func logout(){
        Preferences.setUser(nil)
        Preferences.setAccessToken(nil)
        
        let loginManager = LoginManager()
        loginManager.logOut() // this is an instance function
        
        //FBSDKAccessToken.setCurrent(nil)
        AccessToken.current = nil
        Profile.current = nil
        LoginManager().logOut()
        
//        let deletepermission = FBSDKGraphRequest(graphPath: "me/permissions/", parameters: nil, httpMethod: "DELETE")
//        deletepermission?.start(completionHandler: {(connection,result,error)-> Void in
//            print("the delete permission is \(String(describing: result))")
//
//        })
//        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//        fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
        

//        var drawerController: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController()
//        drawerController.
        NotificationCenter.default.post(name: Notification.Name("LogoutNotification"), object: nil)
        (UIApplication.shared.delegate as! AppDelegate).gotoLoginView()
    }
    
    class func documentDirectoryPath()->String{
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        //        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
    }

    class func loadImageFile(imagePathFromDoc:String) -> UIImage?{
        let readPath = Common.documentDirectoryPath().stringByAppendingPathComponent(imagePathFromDoc)
        
        let fileMngr = FileManager.default
        if (fileMngr.fileExists(atPath: readPath))
        {
            return UIImage(contentsOfFile: readPath)
        }else{
            return nil
        }
        
    }
    
    static func getImageFromWebPath(imageView: UIImageView?, url:String){
        imageView?.image = UIImage(named: "videoDefaultIcon")
        let localPath = "\(url)"
        if let image = Common.loadImageFile(imagePathFromDoc: localPath){
            imageView?.image = image
        }else{
            let serverPath = url //(kAPIBaseUrl + "Resources/MemberImages/" + "\(member.memberId).jpg")
            let url = URL(string: serverPath)
            let request: NSURLRequest = NSURLRequest(url: url!)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                print("Response: \(String(describing: response))")
                
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data!)
                    // Store the image in to our cache
                    
                    DispatchQueue.main.async(execute: {
                        //                        let savePath = Common.documentDirectoryPath().stringByAppendingPathComponent(localPath)
                        //                        try? data?.write(to: URL(string: savePath)!)
                        
                        if let image = image{
                            imageView?.image = image
                        }else{
                            imageView?.image = UIImage(named: "videoDefaultIcon")
                        }
                        
                        //}
                    })
                }
                else {
                    //print("Error: \(error?.localizedDescription)")
                }
                
            })
            
            task.resume()
            
            
        }
    }
    
    static func callNumber(phoneNumber: String) -> Bool {
        
        var editedPhoneNumber = ""
        if phoneNumber != "" {
            
            for i in phoneNumber {
                
                switch (i){
                case "0","1","2","3","4","5","6","7","8","9" : editedPhoneNumber = editedPhoneNumber + String(i)
                default : print("Removed invalid character.")
                }
            }
            
            //            let phone = "tel://" + editedPhoneNumber
            //            let url = NSURL(string: phone)
            //            if let url = url {
            //                UIApplication.sharedApplication().openURL(url)
            //            } else {
            //                print("There was an error")
            //            }
            
            if let phoneCallURL:NSURL = NSURL(string: "tel://\(editedPhoneNumber)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL as URL)) {
                    application.openURL(phoneCallURL as URL);
                }else{
                    return false
                }
            }else{
                return false
            }
            
        } else {
            return false
        }
        
        return true
    }
    
    
    static func getErrorFromJson(description: String, errorType: String, errorCode: Int) -> NSError{
        let userInfo = [
            NSLocalizedDescriptionKey: description,
            NSLocalizedFailureReasonErrorKey: errorType
        ]
        return NSError(domain: ErrorDomain, code: errorCode, userInfo: userInfo)
    }

    @objc
    class func getNSURLFromString(urlString: String) -> NSURL?{
        let rawString = urlString.removingPercentEncoding ?? ""
        return NSURL(string: rawString)
    }
    
    
    
    class func shwoPopupTableView(listItem: [PopoverTableCellModel], sender: UIButton, objectTag: Int, viewController: UIViewController){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popupViewController = storyboard.instantiateViewController(withIdentifier: "PopoverViewController") as? PopoverViewController
        
        let cellHeight: CGFloat = 40
        var height: CGFloat = cellHeight * 6
        switch listItem.count{
        case 1:
            height = cellHeight
        case 2:
            height = cellHeight * 2
        case 3:
            height = cellHeight * 3
        case 4:
            height = cellHeight * 4
        case 5:
            height = cellHeight * 5
        case 6:
            height = cellHeight * 6
        default :()
            
        }
        
        if let popupViewController = popupViewController
        {
            
            popupViewController.preferredContentSize = CGSize(width: 150,height: height)
            popupViewController.tableList = listItem
            popupViewController.modalPresentationStyle = .popover
            popupViewController.delegate = (viewController as! PopoverTableViewDelegate)
            popupViewController.tabelCelltextAlignment = NSTextAlignment.center
            popupViewController.objectTag = objectTag
            
            let popoverController = popupViewController.popoverPresentationController
            popoverController!.permittedArrowDirections = .up
            popoverController!.delegate = viewController as? UIPopoverPresentationControllerDelegate
            popoverController!.sourceView = sender
            popoverController!.sourceRect = sender.bounds //CGRectMake(100,100,0,0)
            popoverController?.backgroundColor = UIColor.white // ThemeManager.ThemeColors.LighterGrayColor
            
            viewController.showDetailViewController(popupViewController, sender: nil)
            popupViewController.titleViewHeight.constant = 0
            //        self.presentViewController(popoverController, animated: true, completion: nil)
        }
        
        
    }
    
    
    @objc
    class func shareVideoViaUIActivitity(urlString: URL?, viewController: UIViewController){
        
        
        // text to share
//        let text = "This is some text that I want to share."
        
        guard let _urlToShare = urlString else {
            return
        }
        
        // set up activity view controller
        
        let activityViewController = UIActivityViewController(activityItems: [_urlToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, .postToTwitter, .message, .mail, .copyToPasteboard, .saveToCameraRoll]
        
        // present the view controller
        viewController.present(activityViewController, animated: true, completion: nil)
        
        
        
        //        guard let url = url else {
        //                return
        //        }
        //
        //        let activityViewController = UIActivityViewController(
        //            activityItems: ["Check out this beer I liked using Beer Tracker.", url],
        //            applicationActivities: nil)
        //        if let popoverPresentationController = activityViewController.popoverPresentationController {
        //            popoverPresentationController.barButtonItem = sender
        //        }
        //        viewController.present(activityViewController, animated: true, completion: nil)
        
        
        
    }
}

