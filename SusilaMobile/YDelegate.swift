//
//  YDelegate.swift
//  Dance Off Bro
//
//  Created by Rashminda on 29/07/16.
//  Copyright © 2016 Rashminda. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation












func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
    
    let asset = AVAsset(url: url as URL)
    let assetImageGenerator = AVAssetImageGenerator(asset: asset)
    
    var time = asset.duration
    time.value = min(time.value, 2)
    
    do {
        let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
        return UIImage(cgImage: imageRef)
    } catch {
        print("error")
        return nil
    }
}


// Helper function inserted by Swift 4.2 migrator.
 func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
 func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

