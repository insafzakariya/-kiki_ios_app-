//
//  Utils.swift
//  SusilaMobile
//
//  Created by Meuru Muthuthanthri on 5/19/19.
//  Copyright © 2019 Isuru Jayathissa. All rights reserved.
//

import Foundation

class Utils {
    static func isSriLankanPhoneNumber(_ phoneNum: String?) -> Bool {
        if (phoneNum != nil) {
            return phoneNum!.hasPrefix("+94")
        } else {
            return false
        }
    }
}
