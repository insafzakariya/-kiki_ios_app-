//
//  String.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 10/11/20.
//

import Foundation

extension String {
    
    var isValidPassword: Bool {
        if count < 6 { return false }
        if rangeOfCharacter(from: .lowercaseLetters, options: .literal, range: nil) == nil { return false }
        if rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) == nil { return false }
        if rangeOfCharacter(from: .uppercaseLetters, options: .literal, range: nil) == nil { return false }
        return true
    }
    
    //    var parseJSONString: AnyObject?
    //    {
    //        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
    //        
    //        if let jsonData = data
    //        {
    //            // Will return an object or nil if JSON decoding fails
    //            do
    //            {
    //                let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
    //                if let jsonResult = message as? NSMutableArray
    //                {
    ////                    print(jsonResult)
    //                    
    //                    return jsonResult //Will return the json array output
    //                }
    //                else
    //                {
    //                    return nil
    //                }
    //            }
    //            catch let error as NSError
    //            {
    //                print("An error occurred: \(error)")
    //                return nil
    //            }
    //        }
    //        else
    //        {
    //            // Lossless conversion of the string was not possible
    //            return nil
    //        }
    //    }
    
    var localizedString:String{
        NSLocalizedString(self.localized(using: "Localizable"), comment: "")
    }
    
    var decodedURL:URL?{
        return URL(string: self.removingPercentEncoding ?? "")
    }
    
    var encodeURL:String{
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    var hexStringToUIColor:UIColor{
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    }
    
}
