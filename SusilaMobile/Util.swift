//
//  Util.swift
//  Order
//
//  Created by Rashminda on 2/8/16.
//  Copyright © 2016 Rashminda. All rights reserved.
//

import Foundation
import UIKit


extension NSDate
{
    /**
     This adds a new method dateAt to NSDate.
     
     It returns a new date at the specified hours and minutes of the receiver
     
     :param: hours: The hours value
     :param: minutes: The new minutes
     
     :returns: a new NSDate with the same year/month/day as the receiver, but with the specified hours/minutes values
     */
    func dateAt(hours: Int, minutes: Int) -> NSDate
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        print("Now = \(self)")
        
        var date_components = calendar.components([NSCalendar.Unit.year,NSCalendar.Unit.month,NSCalendar.Unit.day],from: self as Date)
        
        //Create an NSDate for 8:00 AM today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate as NSDate
    }
}


// Creates a UIColor from a Hex string.
func colorWithHexString (hex:String) -> UIColor {
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

func createAlertViewController(title:String, message: String, viewController: UIViewController){
    //alert view controller
    var alertController = UIAlertController()
    
    alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    
    
    let OKAction = UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default) { (action) in
        // ...
        print("In ok button")
    }
    alertController.addAction(OKAction)
    
    viewController.present(alertController, animated: true) {
        // ...
        print("Present view controller")
    }
}

func isValidEmail(testStr:String) -> Bool {
    // println("validate calendar: \(testStr)")
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func getCurrentDate() -> String
{
    let formatter:DateFormatter = DateFormatter()
    formatter.dateFormat = "ddMMYYYY_hhmmss"
    let date = NSDate()
    let ret = formatter.string(from: date as Date)
    return ret
}

func resizeImage(image: UIImage) -> NSData
{
    var actualHeight:CGFloat = image.size.height;
    var actualWidth:CGFloat = image.size.width;
    let maxHeight:CGFloat = 300.0;
    let maxWidth:CGFloat = 400.0;
    var imgRatio:CGFloat = actualWidth/actualHeight;
    let maxRatio:CGFloat = maxWidth/maxHeight;
    let compressionQuality:CGFloat = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    let imageData:NSData = img.jpegData(compressionQuality: compressionQuality)! as NSData
    UIGraphicsEndImageContext()
    
    return  imageData
    
    
}

func ltzName() -> String { return NSTimeZone.local.identifier }

func convertStringToDictionary(text: String) -> [String:AnyObject]? {
    if let data = text.data(using: String.Encoding.utf8) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject]
            return json
        }catch{
            print("error")
            return nil
        }
    }
    
    
    return nil
}




extension String {
    var isValidPassword: Bool {
        if count < 6 { return false }
        if rangeOfCharacter(from: .lowercaseLetters, options: .literal, range: nil) == nil { return false }
        if rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) == nil { return false }
        if rangeOfCharacter(from: .uppercaseLetters, options: .literal, range: nil) == nil { return false }
        return true
    }
}


struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0.0, width: width, height: self.frame.size.height)
            
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0.0, y: self.frame.size.height - width, width: self.frame.size.height, height: width)
            
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0.0, y: 0.0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}





extension String
{
    var parseJSONString: AnyObject?
    {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data
        {
            // Will return an object or nil if JSON decoding fails
            do
            {
                let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                if let jsonResult = message as? NSMutableArray
                {
                    print(jsonResult)
                    
                    return jsonResult //Will return the json array output
                }
                else
                {
                    return nil
                }
            }
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                return nil
            }
        }
        else
        {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}

func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}

func removeNullsFromDictionary(origin:[String:AnyObject]) -> [String:AnyObject] {
    var destination:[String:AnyObject] = [:]
    for key in origin.keys {
        if origin[key] != nil && !(origin[key] is NSNull)
        {
            if origin[key] is [String:AnyObject] {
                destination[key] = removeNullsFromDictionary(origin: origin[key] as! [String:AnyObject]) as AnyObject?
            } else if origin[key] is [AnyObject] {
                let orgArray = origin[key] as! [AnyObject]
                var destArray: [AnyObject] = []
                for item in orgArray {
                    if item is [String:AnyObject] {
                        destArray.append(removeNullsFromDictionary(origin: item as! [String:AnyObject]) as AnyObject)
                    } else {
                        destArray.append(item)
                    }
                }
            } else {
                destination[key] = origin[key]
            }
        } else {
            destination[key] = "" as AnyObject?
        }
    }
    return destination
}


