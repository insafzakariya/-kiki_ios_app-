//
//  UIHelper.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 10/11/20.
//

import Foundation


class UIHelper:NSObject{
    
    static private func makeViewController(storyBoardName:String, viewControllerName:String) -> UIViewController {
        return UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerName)
    }
    
    static func makeViewController<T:UIViewController>(in storyboard:UIConstant.StoryBoard = .Main,viewControllerName:UIConstant.StoryBoardID) -> T{
        return makeViewController(storyBoardName: storyboard.rawValue, viewControllerName: viewControllerName.rawValue) as! T
    }
    
    public static func makeOKAlert(title:String,message:String,viewController:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: nil)
        alert.addAction(OKAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public static func getAlert(title:String,message:String) -> UIAlertController{
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    public static func makeSubscribeToListenAlert(on window:UIWindow){
        let title = NSLocalizedString("SubscribeToListen".localized(using: "Localizable"), comment: "")
        let alert = UIAlertController(title: title, message: NSLocalizedString("PleaseActivateaPackageToUnlockAccess".localized(using: "Localizable"), comment: "")+NSLocalizedString("toExclusiveContentFromKiki".localized(using: "Localizable"), comment: ""), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("SubscribeNow".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: { action in
            let mainMenu = getRootViewController().drawerViewController as! SMMainMenuViewController
            mainMenu.navigateToPackagePage()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("CLOSE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.cancel, handler: nil))
        window.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    public static func makeNoContentAlert(on winow:UIWindow){
        let title = "No Content Available"
        let message = "Looks like there;s no content available at the moment. Please try again later."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        winow.rootViewController!.present(alertController, animated: true, completion: nil)
    }
    
    private static func getRootViewController() -> KYDrawerController{
        return UIApplication.shared.keyWindow!.rootViewController as! KYDrawerController
    }
    
    //    static func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
    //        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    //        label.numberOfLines = 0
    //        label.lineBreakMode = NSLineBreakMode.byWordWrapping
    //        label.font = font
    //        label.text = text
    //
    //        label.sizeToFit()
    //        return label.frame.height
    //    }
    
    //    static func createAlertViewControllerWithAction(title:String, message: String, viewController: UIViewController,completion: @escaping (Bool) -> ()){
    //        //alert view controller
    //        var alertController = UIAlertController()
    //
    //        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //
    //        let OKAction = UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default) { (action) in
    //            // ...
    //            print("In ok button")
    //            completion(true)
    //        }
    //        alertController.addAction(OKAction)
    //
    //        viewController.present(alertController, animated: true) {
    //            // ...
    //            print("Present view controller")
    //        }
    //    }
    
    // Creates a UIColor from a Hex string.
    static func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
}
