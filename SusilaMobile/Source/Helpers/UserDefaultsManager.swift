//
//  Preferences.swift
//
//  Created by Isuru Jayathissa
//  Copyright © 2016 Isuru Jayathissa. All rights reserved.
//


import UIKit

class UserDefaultsManager {
    
    fileprivate class func setValue(_ value: AnyObject?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    fileprivate class func getValue(_ key: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
    
    fileprivate class func removeValue(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension UserDefaultsManager {
    
    fileprivate struct PreferencesConstants {
        static let Username = "Username"
        //        static let LastLogoutUsername = "LastLogoutUsername"
        static let KeepMeLogin = "KeepMeLogin"
        static let Country = "country"
        static let UserId = "UserId"
        static let OauthAccessToken = "Oauth_AccessToken"
        static let LoginUser = "LoginUser"
        static let IsActiveUser = "IsActiveUser"
        static let MobileNo = "079"
        static let BirthDate = "23-06-1992"
        static let Gender = "M"
        static let Language = "SI"
        static let ChannelID = "ChannelID"
        static let ChannelName = "ChannelName"
        static let mobCode = "MobCode"
        static let IswhiteList = "IswhiteList"
        static let KidsMode = "KidsMode"
        static let KidsModePassword = "KidsModePassword"
        static let videoResolution = "videoResolution"
        static let appIcon = "appIcon"
    }
    
    static func getAppIconName() -> String?{
        UserDefaultsManager.getValue(PreferencesConstants.appIcon) as? String
    }
    
    static func setAppIconName(for name:String){
        UserDefaultsManager.setValue(name as AnyObject?, key: PreferencesConstants.appIcon)
    }
    
    class func setUsername(_ username: String?) {
        UserDefaultsManager.setValue(username as AnyObject?, key: PreferencesConstants.Username)
    }
    class func setGender(_ gender: String?) {
        UserDefaultsManager.setValue(gender as AnyObject?, key: PreferencesConstants.Gender)
    }
    class func setMobileNo(_ mobileno: String?) {
        UserDefaultsManager.setValue(mobileno as AnyObject?, key: PreferencesConstants.MobileNo)
    }
    class func setCountryCode(_ countryCode: String?) {
        UserDefaultsManager.setValue(countryCode as AnyObject?, key: PreferencesConstants.Country)
    }
    class func setLangauge(_ language: String?) {
        UserDefaultsManager.setValue(language as AnyObject?, key: PreferencesConstants.Language)
    }
    class func setBirthDate(_ birthdate: String?) {
        UserDefaultsManager.setValue(birthdate as AnyObject?, key: PreferencesConstants.BirthDate)
    }
    class func setMobeCode(_ setMobeCode: String?) {
        UserDefaultsManager.setValue(setMobeCode as AnyObject?, key: PreferencesConstants.mobCode)
    }
    class func setWhitList(_ setWhitList: Bool) {
        UserDefaultsManager.setValue(setWhitList as AnyObject?, key: PreferencesConstants.IswhiteList)
    }
    
    class func setSettingKidsMode(_ isEnabled: Bool) {
        var statuses = UserDefaultsManager.getValue(PreferencesConstants.KidsMode)
        if (statuses == nil || !(statuses is Dictionary<String, Any>)) {
            statuses = [:] as AnyObject
        }
        var statusDict = statuses as! Dictionary<String, Bool>
        statusDict[UserDefaultsManager.getUserId()!] = isEnabled
        UserDefaultsManager.setValue(statusDict as AnyObject?, key: PreferencesConstants.KidsMode)
    }
    
    class func setSettingKidsModePassword(_ passwordStr: String?) {
        var passwords = UserDefaultsManager.getValue(PreferencesConstants.KidsModePassword)
        if (passwords == nil || !(passwords is Dictionary<String, Any>)) {
            passwords = [:] as AnyObject
        }
        var passwordDict = passwords as! Dictionary<String, String>
        passwordDict[UserDefaultsManager.getUserId()!] = passwordStr
        UserDefaultsManager.setValue(passwordDict as AnyObject?, key: PreferencesConstants.KidsModePassword)
    }
    
    class func getUsername() -> String? {
        return UserDefaultsManager.getValue(PreferencesConstants.Username) as? String
    }
    class func getCountry() -> String? {
        return UserDefaultsManager.getValue(PreferencesConstants.Country) as? String
    }
    class func getMobileNo() -> String? {
        return UserDefaultsManager.getValue(PreferencesConstants.MobileNo) as? String
    }
    class func getLanguage() -> String? {
        return UserDefaultsManager.getValue(PreferencesConstants.Language) as? String
    }
    class func getGender() -> String? {
        return UserDefaultsManager.getValue(PreferencesConstants.Gender) as? String
    }
    class func getBirthDate() -> String? {
        return UserDefaultsManager.getValue(PreferencesConstants.BirthDate) as? String
    }
    class func getMobeCode() -> String? {
        return UserDefaultsManager.getValue(PreferencesConstants.mobCode) as? String ?? ""
    }
    
    class func setUserId(_ userId: String?) {
        UserDefaultsManager.setValue(userId as AnyObject?, key: PreferencesConstants.UserId)
    }
    class func getUserId() -> String? {
        return UserDefaultsManager.getValue(PreferencesConstants.UserId) as? String ?? ""
        
    }
    
    
    class func setKeepMeLogin(_ keepMeLogin: Bool) {
        UserDefaultsManager.setValue(keepMeLogin as AnyObject?, key: PreferencesConstants.KeepMeLogin)
    }
    class func getKeepMeLogin() -> Bool {
        let boolVal = UserDefaultsManager.getValue(PreferencesConstants.KeepMeLogin) as? Bool
        
        if let boolVal = boolVal{
            return boolVal
        }else{
            return false
        }
    }
    
    class func setAccessToken(_ accessToken: String?) {
        UserDefaultsManager.setValue(accessToken as AnyObject?, key: PreferencesConstants.OauthAccessToken)
    }
    class func getAccessToken() -> String? {
        return UserDefaultsManager.getValue(PreferencesConstants.OauthAccessToken) as? String
    }
    
    class func setUser(_ user: AuthUser?) {
        UserDefaultsManager.setValue(user as AnyObject?, key: PreferencesConstants.LoginUser)
    }
    
    class func getUser() -> AuthUser? {
        return UserDefaultsManager.getValue(PreferencesConstants.LoginUser) as? AuthUser
    }
    
    class func setChannelID(_ channelId: Int?) {
        UserDefaultsManager.setValue(channelId as AnyObject?, key: PreferencesConstants.ChannelID)
    }
    
    class func setChannelName(_ channelName: String?) {
        UserDefaultsManager.setValue(channelName as AnyObject?, key: PreferencesConstants.ChannelName)
    }
    
    class func getChannelName() -> String? {
        return UserDefaultsManager.getValue(PreferencesConstants.ChannelName) as? String
        
    }
    class func getChannelID() -> Int? {
        return UserDefaultsManager.getValue(PreferencesConstants.ChannelID) as? Int
        
    }
    class func getWhitList() -> Bool {
        let boolVal = UserDefaultsManager.getValue(PreferencesConstants.IswhiteList) as? Bool
        
        if let boolVal = boolVal{
            return boolVal
        }else{
            return false
        }
        
    }
    //    class func setLastLogoutUsername(_ username: String) {
    //        Preferences.setValue(username as AnyObject?, key: PreferencesConstants.LastLogoutUsername)
    //    }
    //
    //    class func getLastLogoutUsername() -> String? {
    //        return Preferences.getValue(PreferencesConstants.LastLogoutUsername) as? String
    //    }
    
    
    class func setIsActiveUser(_ isActiveUser: Bool) {
        UserDefaultsManager.setValue(isActiveUser as AnyObject?, key: PreferencesConstants.IsActiveUser)
    }
    class func getIsActiveUser() -> Bool {
        let boolVal = UserDefaultsManager.getValue(PreferencesConstants.IsActiveUser) as? Bool
        
        if let boolVal = boolVal{
            return boolVal
        }else{
            return false
        }
    }
    
    class func getSettingKidsMode() -> Bool {
        var statuses = UserDefaultsManager.getValue(PreferencesConstants.KidsMode)
        if (statuses == nil || !(statuses is Dictionary<String, Any>)) {
            statuses = [:] as AnyObject
        }
        let statuesDict = statuses as! Dictionary<String, Bool>
        let boolVal = statuesDict[UserDefaultsManager.getUserId()!]
        
        if let boolVal = boolVal{
            return boolVal
        }else{
            return false
        }
    }
    
    class func getKidsModePassword() -> String? {
        var passwords = UserDefaultsManager.getValue(PreferencesConstants.KidsModePassword)
        if (passwords == nil || !(passwords is Dictionary<String, Any>)) {
            passwords = [:] as AnyObject
        }
        let passwordsDict = passwords as! Dictionary<String, String>
        return passwordsDict[UserDefaultsManager.getUserId()!] ?? ""
    }
    
    class func setVideoResolution(_ resoltuion: Int?) {
        UserDefaultsManager.setValue(resoltuion as AnyObject?, key: PreferencesConstants.videoResolution)
    }
    class func getVideoResolution() -> Int? {
        return UserDefaultsManager.getValue(PreferencesConstants.videoResolution) as? Int ?? 480
        
    }
}

