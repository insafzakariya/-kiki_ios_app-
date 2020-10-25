//
//  User.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/17/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class User{
    
    var username: String
    var password: String
    var name: String
    var provider: AuthMethod
    var gender: Gender?
    var language: Language?
    var accessToken: String?
    var email:String?
    var socialAccessToken: String?
    var socialAccessTokenSecret: String?
    var mobileNumber: String?
    var whitelisted: Bool
    var country: String?
    var device_id: String

    
    init(username: String, password: String, name: String, provider: AuthMethod, gender: Gender?, language: Language?, accessToken: String?, socialAccessToken: String?, socialAccessTokenSecret: String?, mobileNumber: String?,whitelisted: String?,country: String?, device_id: String,email:String? = nil){
        
        self.username = username
        self.password = password
        self.name = name
        self.provider = provider
        self.gender = gender
        self.language = language
        self.accessToken = accessToken
        self.socialAccessToken = socialAccessToken
        self.socialAccessTokenSecret = socialAccessTokenSecret
        self.mobileNumber = mobileNumber
        self.whitelisted = (whitelisted != nil)
        self.country = country
        self.device_id = device_id
        self.email = email
    }
}
