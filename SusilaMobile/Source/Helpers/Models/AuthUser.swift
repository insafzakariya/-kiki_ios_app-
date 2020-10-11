//
//  AuthUser.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/25/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class AuthUser: NSObject, NSCoding{

    
    var id: Int
    var name: String
    var accessToken: String
    var dateOfBirth: String?
    var gender: Gender?
    var language: Language?
    var mobileNumber: String?
    
    init(id: Int, name: String, accessToken: String, dateOfBirth: String?, gender: Gender?, language: Language?, mobileNumber: String?){
        
        self.id = id
        self.name = name
        self.accessToken = accessToken
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.language = language
        self.mobileNumber = mobileNumber
        
    }
    
    
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeInteger(forKey: "id")
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.accessToken = decoder.decodeObject(forKey: "accessToken") as? String ?? ""
        self.dateOfBirth = decoder.decodeObject(forKey: "dateOfBirth") as? String
        self.gender = decoder.decodeObject(forKey: "gender") as? Gender
        self.language = decoder.decodeObject(forKey: "language") as? Language
        self.mobileNumber = decoder.decodeObject(forKey: "mobileNumber") as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
        coder.encode(accessToken, forKey: "accessToken")
        coder.encode(dateOfBirth, forKey: "dateOfBirth")
        coder.encode(gender, forKey: "gender")
        coder.encode(language, forKey: "language")
        coder.encode(mobileNumber, forKey: "mobileNumber")
    }
    
}

extension AuthUser {

    internal struct JsonKeys{
        static let verified = "verified"
        static let name = "name"
        static let id = "id"
        static let mobile_number = "mobile_number"
        static let access_token = "access_token"
        static let language = "language"
        static let gender = "gender"
        static let date_of_birth = "date_of_birth"
        static let username = "username"
        static let mobno = "mobno"
        static let country = "country"
    }
    
    static func getGender(text : String) -> Gender{
        switch text {
        case "M":
            return Gender.MALE
        case "F":
            return Gender.FEMALE
        default:
            return Gender.None
        }
    }
    
    static func getGenderFromName(text : String) -> Gender{
        switch text {
        case "MALE":
            return Gender.MALE
        case "FEMALE":
            return Gender.FEMALE
        default:
            return Gender.None
        }
    }

    
    static func getGenderFromHashValue(hashVal : Int) -> Gender{
        switch hashVal {
        case Gender.MALE.hashValue:
            return Gender.MALE
        case Gender.FEMALE.hashValue:
            return Gender.FEMALE
        default:
            return Gender.None
        }
    }
    
    
    static func getGenderServerCode(gender : Gender) -> String{
        switch gender {
        case .MALE:
            return "M"
        case .FEMALE:
            return "F"
        default:
            return ""
        }
    }
    
    static func getLanguage(text : String) -> Language{
        switch text.lowercased() {
        case "si":
            return Language.SINHALA
        case "ta":
            return Language.TAMIL
        case "en":
            return Language.ENGLISH
        default:
            return Language.None
        }
    }

    static func getLanguageFromHashValue(hashVal : Int) -> Language{
        switch hashVal {
        case Language.SINHALA.hashValue:
            return Language.SINHALA
        case Language.TAMIL.hashValue:
            return Language.TAMIL
        case Language.ENGLISH.hashValue:
            return Language.ENGLISH
        default:
            return Language.None
        }
    }
    
    static func getLanguageServerCode(language : Language) -> String{
        switch language {
        case .SINHALA:
            return "SI"
        case .TAMIL:
            return "TA"
        case .ENGLISH:
            return "EN"
        default:
            return ""
        }
    }
}
