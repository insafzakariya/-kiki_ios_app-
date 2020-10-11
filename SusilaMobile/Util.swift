//
//  Util.swift
//  Order
//
//  Created by Rashminda on 2/8/16.
//  Copyright © 2016 Rashminda. All rights reserved.
//

import Foundation
import UIKit









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


