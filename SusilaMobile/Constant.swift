//
//  Constant.swift
//  HyreCar
//
//  Created by Rashminda on 2/15/16.
//  Copyright © 2016 Rashminda. All rights reserved.
//

import Foundation
import UIKit

let defaults = UserDefaults.standard
let firstColor = colorWithHexString(hex: "#00897B")
let secondColor:UIColor = colorWithHexString(hex: "#008a7c")
let thirdColor:UIColor = colorWithHexString(hex: "#008a7c")

// MUSIC APP
struct Constants {
    static let color_background = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
    static let color_brand = UIColor(red:0.00, green:0.61, blue:0.62, alpha:1.0)
    static let lightGrayColor = UIColor(red: 220/255, green: 226/255, blue: 226/255, alpha: 1.0)
    static let kikiBlueColor = UIColor(red: 68/255, green: 137/255, blue: 136/255, alpha: 1.0)
    static let musicAppBackColor = UIColor(red: 231/255, green: 235/255, blue: 246/255, alpha: 1.0)
    static let videoAppBackColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1.0)
    static let color_separator = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
    static func getFont(size:CGFloat) -> UIFont { return UIFont(name: "Roboto-Bold", size: size)! }
    static let color_red = UIColor(red:1.00, green:0.00, blue:0.00, alpha:1.0)
    static let color_transparent = UIColor(red:0.10, green:0.10, blue:0.10, alpha:0.0)
    static let color_selectedSong = UIColor(red:0.10, green:0.10, blue:0.10, alpha:0.9)
}
//Kiroshan
//color update second release
//let KikiDarkGray:UIColor = colorWithHexString(hex: "#1A1A1A")
//let KikiDarkCyan:UIColor = colorWithHexString(hex: "#009B9E")
//let KikiUnselectedBtn:UIColor = colorWithHexString(hex: "#4D4D4D")

