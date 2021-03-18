//
//  UIImage.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 10/11/20.
//

import Foundation

extension UIImage {
    
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/4, size.width/4)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    func roundImage() -> UIImage
    {
        let newImage = self.copy() as! UIImage
        let cornerRadius = self.size.height/2
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
        let bounds = CGRect(origin: CGPoint.zero, size: self.size)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        newImage.draw(in: bounds)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage!
    }
    
    class func roundImage(image : UIImage) -> UIImage? {
        // copy
        guard let newImage = image.copy() as? UIImage else {
            return nil
        }
        // start context
        UIGraphicsBeginImageContextWithOptions(newImage.size, false, 0.0)
        // bounds
        let cornerRadius = newImage.size.height / 2
        let minDim = min(newImage.size.height, newImage.size.width)
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: minDim, height: minDim))
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        // new image
        newImage.draw(in: bounds)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // crop
        let maybeCrop = UIImage.crop(image: finalImage!, cropRect: bounds)
        return maybeCrop
    }
    
    
    class func crop(image: UIImage, cropRect : CGRect) -> UIImage? {
        guard let imgRef = image.cgImage!.cropping(to: cropRect) else {
            return nil
        }
        return UIImage(cgImage: imgRef)
    }
}
