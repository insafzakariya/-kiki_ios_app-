//
//  Constants.swift
//
//  Created by Isuru Jayathissa
//  Copyright © 2016 Isuru Jayathissa. All rights reserved.
//

let kGoogleClientID = "638746862442-avb3f3n0414fj55qe9fnj6g3mkjjtf0b.apps.googleusercontent.com"//"com.googleusercontent.apps.859385348597-iuve496hpss5jd6qr9n4ib9a4o7j5mp3";//"540795318376-l6kjh9kce0em1mtu9snmh90uk7pocaod.apps.googleusercontent.com"
let reversedClientID = "com.googleusercontent.apps.638746862442-avb3f3n0414fj55qe9fnj6g3mkjjtf0b"

let kiOS_API_key = "AIzaSyDX2hS-C8riiI4tZzLHFOHP2zAC5NxX2bE" //"1iM721UXrVaiqDVszE9uu2qZ2P34A0roaHWAsDrd"


//let kAPIBaseUrl = "http://35.200.217.24/mobile-tv-webservice/api/v1/" // staging URL
//let remoteConfig = (UIApplication.shared.delegate as! AppDelegate).getRemoteConfig()
//let kAPIBaseUrl = remoteConfig[baseURL] as String
var kAPIBaseUrl = "http://35.200.234.252/mobile-tv-webservice/api/v1" //"http://35.200.234.252:7070/mobile-tv-webservice/api/v1/" // staging URL
var IAPBaseURL = "https://payv2.kiki.lk/susilawebpay" // staging URL

var chatWebViewBaseURL = "http://35.200.142.38:8080"
var chatBaseURL = " http://35.200.142.38:8082/kiki-chat/api/v1"

let mobileCodeRequestUrl = "http://220.247.201.206:90/"

//let kAPIBaseUrl = "https://susilamobiletv.info/mobile-tv-webservice/api/v1/" //"http://220.247.201.190:8080/mobile-tv-webservice/api/v1/" // "http://222.165.180.160/mobile-tv-webservice/api/v1/"  //"https://susilamobiletv.info/mobile-tv-webservice/api/v1/"   //

let kBasicServerAuthToken = "Basic MjpvMDZuSFZCSnlnTUdMRmNiR0YvV25kTGNheHM9"

let AVPlayerVCSetVideoURLNotification = "avplayervcsetvideourl"
let AVPlayerVCSetFullScreenVideoNotification = "avplayervcsetfullScreenvideourl"

let kFBlink = "https://www.facebook.com/mv.kiki.lk/"
//let kShareUrl = "https://cdn.kiki.lk/social/share/episode/"

let kAPPThemeOrangeColor = UIHelper.colorWithHexString(hex: "#2ecc71")

//UIColor(red: 255/255, green: 110/255, blue: 64/255, alpha: 1)
let kAPPThemeWhiteColor = UIColor.white.cgColor

let kDefaultInt = -1
let kDefaultString = ""

enum AuthMethod: String {
    case CUSTOM
    case FACEBOOK
    case GOOGLE
    case TWITTER
    case DIALOG
    case APPLE
}

enum Gender: String {
    case MALE
    case FEMALE
    case None
}

enum Language: String {
    case SINHALA
    case TAMIL
    case ENGLISH
    case None
}


enum SMErrorCode: Int {
    case DuplicateAction = 1014
}

internal struct ErrorJsonKeys{
    
    static let errorMessage = "errorMessage"
    static let errorCode = "errorCode"
}

// Firebase remote config keys
let termsAndConditionsKey = "USER_TERMS_PAGE_URL"
let licenseAgreementConfigKey = "USER_AGREEMENT_PAGE_URL"
let contactTelephoneConfigKey = "CONTACT_TELEPHONE"
let specialUserIdConfigKey = "SPECIAL_USER_ID"
let contactEmailConfigKey = "CONTACT_EMAIL"
let enableSMSVerificationConfigKey = "ENABLE_SMS_VERIFICATION"
let mobilePaymentGatewayUrlConfigKey = "MOBILE_PAYMENT_GATEWAY_URL_V2"
let baseURL_STAGING = "STAGING_SERVER_API_V_1"
let baseURL_LIVE = "MAIN_SERVER_API_V_2"
let chatBaseURLKey = "CHAT_SERVER_API_V_1"
let IAP_LIVE = "APPLE_MOBILE_PAYMENT_GATEWAY_URL_V1"
//let mobilePaymentGatewayUrlConfigKey = "STAGING_MOBILE_PAYMENT_GATEWAY_URL" // staging


