//
//  Preferences.swift
//
//  Created by Isuru Jayathissa
//  Copyright © 2016 Isuru Jayathissa. All rights reserved.
//


import UIKit

/**
 *  Wrapper around NSUserDefaults
 */
class Preferences {
    
    /**
     Save a value
     
     - parameter value: Value to save
     - parameter key:   Key for the value
     */
    fileprivate class func setValue(_ value: AnyObject?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /**
     Retrieve a value
     
     - parameter key: Key for the value
     
     - returns: Value for the given key
     */
    fileprivate class func getValue(_ key: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
    
    /**
     Deletes a value
     
     - parameter key: Key for the value to delete
     */
    fileprivate class func removeValue(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension Preferences {
    
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
    }
    
    /**
     Save Username.
     
     - parameter Username:
     */
    class func setUsername(_ username: String?) {
        Preferences.setValue(username as AnyObject?, key: PreferencesConstants.Username)
    }
    class func setGender(_ gender: String?) {
        Preferences.setValue(gender as AnyObject?, key: PreferencesConstants.Gender)
    }
    class func setMobileNo(_ mobileno: String?) {
        Preferences.setValue(mobileno as AnyObject?, key: PreferencesConstants.MobileNo)
    }
    class func setCountryCode(_ countryCode: String?) {
        Preferences.setValue(countryCode as AnyObject?, key: PreferencesConstants.Country)
    }
    class func setLangauge(_ language: String?) {
        Preferences.setValue(language as AnyObject?, key: PreferencesConstants.Language)
    }
    class func setBirthDate(_ birthdate: String?) {
        Preferences.setValue(birthdate as AnyObject?, key: PreferencesConstants.BirthDate)
    }
    class func setMobeCode(_ setMobeCode: String?) {
        Preferences.setValue(setMobeCode as AnyObject?, key: PreferencesConstants.mobCode)
    }
    class func setWhitList(_ setWhitList: Bool) {
        Preferences.setValue(setWhitList as AnyObject?, key: PreferencesConstants.IswhiteList)
    }
    
    class func setSettingKidsMode(_ isEnabled: Bool) {
        var statuses = Preferences.getValue(PreferencesConstants.KidsMode)
        if (statuses == nil || !(statuses is Dictionary<String, Any>)) {
            statuses = [:] as AnyObject
        }
        var statusDict = statuses as! Dictionary<String, Bool>
        statusDict[Preferences.getUserId()!] = isEnabled
        Preferences.setValue(statusDict as AnyObject?, key: PreferencesConstants.KidsMode)
    }
    
    class func setSettingKidsModePassword(_ passwordStr: String?) {
        var passwords = Preferences.getValue(PreferencesConstants.KidsModePassword)
        if (passwords == nil || !(passwords is Dictionary<String, Any>)) {
            passwords = [:] as AnyObject
        }
        var passwordDict = passwords as! Dictionary<String, String>
        passwordDict[Preferences.getUserId()!] = passwordStr
        Preferences.setValue(passwordDict as AnyObject?, key: PreferencesConstants.KidsModePassword)
    }
    
    /**
     Retrieve Username.
     
     - returns: Username String if already saved. nil if not.
     */
    class func getUsername() -> String? {
        return Preferences.getValue(PreferencesConstants.Username) as? String
    }
    class func getCountry() -> String? {
        return Preferences.getValue(PreferencesConstants.Country) as? String
    }
    class func getMobileNo() -> String? {
        return Preferences.getValue(PreferencesConstants.MobileNo) as? String
    }
    class func getLanguage() -> String? {
        return Preferences.getValue(PreferencesConstants.Language) as? String
    }
    class func getGender() -> String? {
        return Preferences.getValue(PreferencesConstants.Gender) as? String
    }
    class func getBirthDate() -> String? {
        return Preferences.getValue(PreferencesConstants.BirthDate) as? String
    }
    class func getMobeCode() -> String? {
        return Preferences.getValue(PreferencesConstants.mobCode) as? String ?? ""
    }
    
    class func setUserId(_ userId: String?) {
        Preferences.setValue(userId as AnyObject?, key: PreferencesConstants.UserId)
    }
    class func getUserId() -> String? {
        return Preferences.getValue(PreferencesConstants.UserId) as? String ?? ""
        
    }
    
    
    class func setKeepMeLogin(_ keepMeLogin: Bool) {
        Preferences.setValue(keepMeLogin as AnyObject?, key: PreferencesConstants.KeepMeLogin)
    }
    class func getKeepMeLogin() -> Bool {
        let boolVal = Preferences.getValue(PreferencesConstants.KeepMeLogin) as? Bool
        
        if let boolVal = boolVal{
            return boolVal
        }else{
            return false
        }
    }
    
    class func setAccessToken(_ accessToken: String?) {
        Preferences.setValue(accessToken as AnyObject?, key: PreferencesConstants.OauthAccessToken)
    }
    class func getAccessToken() -> String? {
        return Preferences.getValue(PreferencesConstants.OauthAccessToken) as? String
        
    }
    
    class func setUser(_ user: AuthUser?) {
        Preferences.setValue(user as AnyObject?, key: PreferencesConstants.LoginUser)
    }
    class func getUser() -> AuthUser? {
        return Preferences.getValue(PreferencesConstants.LoginUser) as? AuthUser
        
    }
    
    class func setChannelID(_ channelId: Int?) {
        Preferences.setValue(channelId as AnyObject?, key: PreferencesConstants.ChannelID)
    }
    class func setChannelName(_ channelName: String?) {
        Preferences.setValue(channelName as AnyObject?, key: PreferencesConstants.ChannelName)
    }
    class func getChannelName() -> String? {
        return Preferences.getValue(PreferencesConstants.ChannelName) as? String
        
    }
    class func getChannelID() -> Int? {
        return Preferences.getValue(PreferencesConstants.ChannelID) as? Int
        
    }
    class func getWhitList() -> Bool {
        let boolVal = Preferences.getValue(PreferencesConstants.IswhiteList) as? Bool
        
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
        Preferences.setValue(isActiveUser as AnyObject?, key: PreferencesConstants.IsActiveUser)
    }
    class func getIsActiveUser() -> Bool {
        let boolVal = Preferences.getValue(PreferencesConstants.IsActiveUser) as? Bool
        
        if let boolVal = boolVal{
            return boolVal
        }else{
            return false
        }
    }
    
    class func getSettingKidsMode() -> Bool {
        var statuses = Preferences.getValue(PreferencesConstants.KidsMode)
        if (statuses == nil || !(statuses is Dictionary<String, Any>)) {
            statuses = [:] as AnyObject
        }
        let statuesDict = statuses as! Dictionary<String, Bool>
        let boolVal = statuesDict[Preferences.getUserId()!]
        
        if let boolVal = boolVal{
            return boolVal
        }else{
            return false
        }
    }
    
    class func getKidsModePassword() -> String? {
        var passwords = Preferences.getValue(PreferencesConstants.KidsModePassword)
        if (passwords == nil || !(passwords is Dictionary<String, Any>)) {
            passwords = [:] as AnyObject
        }
        let passwordsDict = passwords as! Dictionary<String, String>
        return passwordsDict[Preferences.getUserId()!] ?? ""
    }
    
    class func setVideoResolution(_ resoltuion: Int?) {
        Preferences.setValue(resoltuion as AnyObject?, key: PreferencesConstants.videoResolution)
    }
    class func getVideoResolution() -> Int? {
        return Preferences.getValue(PreferencesConstants.videoResolution) as? Int ?? 480
        
    }
}

