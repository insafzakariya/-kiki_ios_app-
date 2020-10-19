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
    
}
