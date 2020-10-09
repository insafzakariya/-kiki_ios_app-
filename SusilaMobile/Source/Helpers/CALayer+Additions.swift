//
//  CALayer+Additions.swift
//  CAMS
//
//  Created by Isuru Jayathissa on 8/11/15.
//  Copyright (c) 2015 Isuru Jayathissa. All rights reserved.
//

import UIKit

extension CALayer {
    var borderColorFromUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        }
        
        set (color) {
            self.borderColor = color.cgColor
        }
    }
    
}
