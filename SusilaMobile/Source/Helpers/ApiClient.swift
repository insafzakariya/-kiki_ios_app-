//
//  ApiClient.swift
//
//  Created by Isuru Jayathissa
//  Copyright © 2016 Isuru Jayathissa. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ApiClient {
    
    enum APICalls {
        case Login
        case LoginWithToken
        case Regiter
        case UpdateCurrentUser
        case GetPrograms
        case SMSVerify
        case PromoCode
        case Subscribe
        case LikeProgram
        case ProgramTrailer
        case GetPackageList
        case SubscribePackage
        case GetCurrentPackage
        case GetChannelList
        case GetChannelImageList
        case GetSubscribedList
        case SendAnalytics
        case SendMobileNumber
        //
        case GetHomePopularSongs
        case GetHomeLatestSongs
        case GetRadioChannels
        case GetPopularArtist
        case GetLatestPlaylistSongs
        case GetPopularArtistSongs
        case GetBrowseAllArtist
        case GetGenreArtists
        case GetGenrePlaylists
        
        //Library
        case getLibraySongs
        case getLibrayArtists
        case GetLibrayPlaylists
        case AddToTempPlaylist
        case GetTempPlaylist
        case CreatePlaylist
        case AddSongsToPlaylist
        case AddToLibrary
        case RemoveFromLibrary
        case RemovePlaylistFromLibrary
        
        case UpdateFCMToken
        case UpdateAction
        
        case PlaylistLoadTempTable
        case UpdatePlaylist
        
        case GetSongById
        case GetArtistById
        case GetPlaylistById
        case SearchByWord
        case SearchByWordAll
        case GetSearchHistory
        case GetSuggessionSongs
        
        //IAP
        case GetPackages
    }
    
    struct SubUrl {
        // POST
        static let Login = "service/login"
        static let LoginWithToken = "auth/token"
        static let Regiter = "service/register"
        static let UpdateCurrentUser = "auth/viewer"
        static let GetPrograms = "content/programs" // need to add channel id
        static let SMSVerify = "auth/verify"
        static let PromoCode = "subscription/promocode/"
        static let Subscribe = "content/action/subscribe"
        static let UnSubscribe = "content/action/unsubscribe"
        static let LikeProgram = "content/action/like/program/"
        static let LikeProgram_v2 = "content/action/"
        static let sendAnalytics = "analytics/player/"
        static let GetPackageList = "subscription/packages"
        static let SubscribePackage = "subscription/packages/subscribe/"
        static let GetCurrentPackage = "subscription/current" //
        static let GetSubscribedList = "content/programs/subscribed"  // need to add channel id
        static let Trailer = "content/programs/trailer/v2/"
        static let GetChannelList = "content/channels"
        static let GetImageList = "ads/slider"
        static let GetNotification = "notification/received"
        static let readNotifications = "notification/received/markread"
        static let ClearNotifications = "notification/clear"
        static let YouMightAlsoLike = "audio/songs/suggestions/?limit=30&offset=0"
        static let UserPlayLists = "audio/playlist"
        static let AllSongs = "audio/songs"
        static let AllSongsGenre = "audio/songs/attr/genre"
        static let RecentSongs = "audio/songs/recent"
        static let GlobalPlaylist = "audio/playlist"
        static let SongsOfPlaylist = "audio/playlist/songs"
        static let createPlaylist = "audio/playlist/create"
        static let AddSongsToPlaylist = "playlist/songs/add"
        static let SongsOfGenre = "audio/songs/genre"
        static let Search = "audio/songs/search"
        
        static let SendMobileNumber = "password/request"
        static let passwordRequestVerify = "password/request/verify"
        static let passwordRequest = "password/reset"
        
        //
        static let HomePopularSongs = "audio/playlist/songs?ps=true&offset=0&limit=15"
        static let HomeLatestSongs = "audio/playlist/songs?ls=true&offset=0&limit=15"
        static let RadioChannels = "radio/channel"
        static let HomePopularArtists = "audio/artist/popular?pa=true"
        static let LatestPlaylistSongs = "audio/playlist/songs/"
        static let HomePopularArtistSongs = "artist/"
        static let BrowseAllArtistSongs = "artist/list?offset=1&limit=15"
        static let BrowseGenreArtists = "genre/"
        static let BrowseGenrePlaylists = "genre/"
        
        //Library
        static let LibrarySongs = "library/songs?limit=15&offset=1"
        static let LibraryArtists = "library/artists?limit=15&offset=1"
        static let LibraryPlaylist = "library/playlist?limit=15&offset=1"
        static let addToTempPlaylist = "audio/playlist/addtotemp"
        static let getTempPlaylist = "audio/playlist/temp/all?session_id="
        static let addToLibary = "library/add"
        static let removeFromLibary = "library/remove"
        static let removePlaylistFromLibary = "audio/playlist/remove"
        
        static let updateFCMToken = "deviceid/update"
        static let updateAction = "analytics/screen"
        
        static let playlistLoadTempTable = "audio/playlist/temp/reload"
        static let updatePlaylist = "playlist/songs/editsongs"
        
        static let GetSongById = "audio/songsbyid?song_id="
        static let GetArtistById = "artist/searchbyid?artist_id="
        static let GetPlaylistById = "playlist/playlistdata/"
        static let SearchByWord = "audio/search-all?query_text="
        static let SearchByWordAll = "audio/search-by-type?"
        static let GetSearchHistory = "audio/search-history?limit=5"
        static let GetSuggessionSongs = "audio/songs/suggession/genre?"
        
        static let GetPackages = "/rest/plan/planlist/10"
        static let ActivateIAPPackage = "/rest/apple/pay"
        static let GetSubscriptionStatus = "/rest/subscription/isSubscribe/%@"
        
        
        //Chat
        static let ChatToken = "chat/token-generate"
        static let CreateMember = "chat/create-member"
        static let Members = "chat/get-chat-members/%@/%@"
        static let Chennels = "chat/channels"
        static let Chats = "chat/get-chats"
        static let MemberRole = "chat/get-role/%@"
    }
    
    struct StringKeys{
        static let HEADER_AUTHORIZATION = "Authorization"
        static let HEADER_TOKEN_AUTHENTICATION = "Bearer-Access-Token"
        static let HEADER_CONTENT_TYPE = "Content-Type"
        static let CONTENT_TYPE = "application/json"
        
        static let USERNAME = "username";
        static let PASSWORD = "password";
        static let SOCIAL_TYPE = "social_type";
        static let NAME = "name";
        static let SOCIAL_TOKEN = "social_token";
        static let SOCIAL_TOKEN_SECRET = "social_token_secret";
        static let HTTP_CREATED = 201;
        static let MOBILE_NUMBER = "mobile_number";
        static let MOBILE_NO = "mobile_no";
        static let White_Listed = "whitelisted";
        static let DATE_OF_BIRTH = "date_of_birth";
        static let GENDER = "gender";
        static let LANGUAGE = "language";
        static let COUNTRYCODE = "country";
        static let SERVER_VALUE_FEMALE = "F";
        static let SERVER_VALUE_MALE = "M";
        static let SERVER_VALUE_SINHALA = "Si";
        static let SERVER_VALUE_TAMIL = "Ta";
        static let SERVER_VALUE_ENGLISH = "En";
        static let SMSCode = "smsCode";
        static let DEVICE_ID = "device_id";
        static let EMAIL = "email"
        static let SOCIAL_USER_ID = "social_userid"
        
        static let IMAGE_URL = "imageUrl";
        static let PLAYLIST_ID = "playlist_id";
        static let SONGS = "songs";
        static let TYPE = "type";
        static let IDS = "ids";
        static let ID = "id";
        static let REF_ID = "refId";
        static let SESSION_ID = "sessionId";
        static let BASE_64 = "image_base64";
        static let FCM_DEVICE_ID = "deviceId";
        static let PLAYLISTID = "playlistId";
        
    }
    
    func getIAPPackages(onComplete:@escaping (_ packages:[String:Int],_ validityPeriod:[String:Int])->()){
        let url = URL(string: IAPBaseURL + SubUrl.GetPackages)!
        Log(url.absoluteString)
        var tempPackages:[String:Int] = [:]
        var tempDurations:[String:Int] = [:]
        ServiceManager.APIRequest(url: url, method: .get) { (response, responseCode) in
            if responseCode == 200{
                let jsonData:JSON = JSON((response as! DataResponse<Any>).result.value!)
                if let jsonResponse = jsonData as? JSON{
                    Log(jsonResponse.description)
                    if let packages = jsonResponse.array{
                        for package in packages{
                            if let name = package["name"].string,
                               let id = package["id"].int,
                               let duration = package["day"].int{
                                tempPackages[name] = id
                                tempDurations[name] = duration
                            }
                        }
                        onComplete(tempPackages,tempDurations)
                    }else{
                        onComplete(tempPackages,tempDurations)
                    }
                }else{
                    onComplete(tempPackages,tempDurations)
                }
            }else{
                onComplete(tempPackages,tempDurations)
                Log(responseCode.description)
            }
        }
    }
    
    func activatePackage(packageID:Int,onComplete:@escaping (_ success:Bool)->()){
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           FileManager.default.fileExists(atPath: appStoreReceiptURL.path){
            let rawReceiptData = try! Data(contentsOf: appStoreReceiptURL)
            let receiptData = rawReceiptData.base64EncodedString()
            let viewerID = UserDefaultsManager.getUserId()!
            
            let params:[String:Any] = [
                "receiptString":receiptData,
                "planId":packageID,
                "viewerId":Int(viewerID)
            ]
            Log(params.description)
            
            let url = URL(string: IAPBaseURL + SubUrl.ActivateIAPPackage)!
            Log(url.absoluteString)
            ServiceManager.APIRequest(url: url, method: .post, params: params) { (response, responseCode) in
                if responseCode == 200{
                    let jsonData:JSON = JSON((response as! DataResponse<Any>).result.value!)
                    Log(jsonData.description)
                    if let jsonResponse = jsonData as? JSON{
                        if let status = jsonResponse["status"].string{
                            if status == "ACCEPT"{
                                onComplete(true)
                            }else{
                                onComplete(false)
                            }
                        }else{
                            onComplete(false)
                        }
                    }else{
                        onComplete(false)
                    }
                }else{
                    onComplete(false)
                }
            }
        }else{
            onComplete(false)
        }
        
    }
    
    func getSubscriptionStatus(onComplete:@escaping (_ name:String?)->()){
        
        let url = URL(string: IAPBaseURL + String(format: SubUrl.GetSubscriptionStatus, UserDefaultsManager.getUserId()!))!
        Log(url.absoluteString)
        ServiceManager.APIRequest(url: url, method: .get) { (response, responseCode) in
            if responseCode == 200{
                let jsonData:JSON = JSON((response as! DataResponse<Any>).result.value!)
                Log(jsonData.description)
                if let jsonResponse = jsonData as? JSON{
                    if let plan = jsonResponse["planDtos"].array?.first{
                        if let name = plan["name"].string{
                            onComplete(name)
                        }else{
                            onComplete(nil)
                        }
                    }else{
                        onComplete(nil)
                    }
                }else{
                    onComplete(nil)
                }
            }else{
                onComplete(nil)
            }
        }
    }
    
    
    
    internal func updateFCMToken(deviceId:String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl+SubUrl.updateFCMToken)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? "",
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE
        ]
        
        let parameters = [
            StringKeys.FCM_DEVICE_ID:deviceId
        ] as [String : Any]
        
        request(url!, apiCallType: .UpdateFCMToken, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func updateAction(content_Id:Int, screen_Id:Int, screen_Action_Id:Int, screen_Time:String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl+SubUrl.updateAction+"/"+String(content_Id)+"/"+String(screen_Id)+"/"+String(screen_Action_Id)+"/"+screen_Time)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? "",
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .UpdateAction, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func passwordResetCodeRequest(number: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.SendMobileNumber + "?mobile_no=" + number)
        Log(url?.description ?? "")
        //let url = URL(string:"http://34.93.78.242/mobile-tv-webservice/api/v1/password/request?mobile_no="+number)
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .SendMobileNumber, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func passwordResetCodeSend(viwerId: String, otp: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.passwordRequestVerify + "?viwer_id="+viwerId+"&otp="+otp)
        Log(url?.description ?? "")
        //let url = URL(string:"http://34.93.78.242/mobile-tv-webservice/api/v1/password/request/verify?viwer_id="+viwerId+"&otp="+otp)
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .SendMobileNumber, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func resetPasswordSend(viwerId: String, password: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.passwordRequest + "?viwer_id="+viwerId+"&password="+password)
        Log(url?.description ?? "")
        //let url = URL(string:"http://34.93.78.242/mobile-tv-webservice/api/v1/password/reset?viwer_id="+viwerId+"&password="+password)
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .SendMobileNumber, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func loginWithUsername(username: String, password: String, authMethod: AuthMethod, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.Login)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken
        ]
        
        let parameters = [
            StringKeys.USERNAME:username,
            StringKeys.PASSWORD:password,
            StringKeys.SOCIAL_TYPE:authMethod.rawValue.lowercased(),
            StringKeys.SOCIAL_TOKEN:""
            
        ] as [String : Any]
        
        request(url!, apiCallType: .Login, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func authLoginWithAccessToken(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.LoginWithToken)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .LoginWithToken, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func registerWithUsername(username: String, password: String, name: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.Regiter)
        Log(url?.description ?? "")
        
        //StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken
        ]
        
        let parameters = [
            
            StringKeys.USERNAME:username,
            StringKeys.PASSWORD:password,
            StringKeys.NAME:name,
            StringKeys.SOCIAL_TYPE:AuthMethod.CUSTOM.rawValue.lowercased()
            
            
        ] as [String : Any]
        
        request(url!, apiCallType: .Regiter, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func register(user: User, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.Regiter)
        Log(url?.description ?? "")
        
        //StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken
        ]
        Log(headers.description)
        
        var parameters : [String : Any]? = nil
        
        switch user.provider {
        case AuthMethod.CUSTOM:
            parameters = [
                
                StringKeys.USERNAME:user.username,
                StringKeys.PASSWORD:user.password,
                StringKeys.NAME:user.name,
                StringKeys.SOCIAL_TYPE:user.provider.rawValue.lowercased(),
                StringKeys.DEVICE_ID:user.device_id
            ] as [String : Any]
            
        case .FACEBOOK:
            parameters = [
                
                StringKeys.SOCIAL_TOKEN:user.socialAccessToken ?? "",
                StringKeys.SOCIAL_TYPE:user.provider.rawValue.lowercased(),
                StringKeys.DEVICE_ID:user.device_id
            ] as [String : Any]
        case .GOOGLE:
            parameters = [
                StringKeys.USERNAME:user.username,
                StringKeys.PASSWORD:user.password,
                StringKeys.SOCIAL_TOKEN:user.socialAccessToken ?? "",
                StringKeys.SOCIAL_TYPE:user.provider.rawValue.lowercased(),
                StringKeys.DEVICE_ID:user.device_id
            ] as [String : Any]
            
        case .TWITTER:
            
            parameters = [
                
                StringKeys.SOCIAL_TOKEN:user.socialAccessToken ?? "",
                StringKeys.SOCIAL_TOKEN_SECRET:user.socialAccessTokenSecret ?? "",
                StringKeys.SOCIAL_TYPE:user.provider.rawValue.lowercased(),
                StringKeys.DEVICE_ID:user.device_id
            ] as [String : Any]
            
            
        case .APPLE:
            parameters = [
                StringKeys.USERNAME:user.username,
                StringKeys.PASSWORD:user.password,
                StringKeys.NAME:user.name,
                StringKeys.SOCIAL_USER_ID:user.socialAccessToken ?? "",
                StringKeys.SOCIAL_TOKEN:user.socialAccessToken ?? "",
                StringKeys.SOCIAL_TYPE:user.provider.rawValue.lowercased(),
                StringKeys.EMAIL:user.email ?? "",
                StringKeys.DEVICE_ID:user.device_id
            ] as [String : Any]
            
        default:()
        }
        
        Log(parameters?.description ?? "")
        request(url!, apiCallType: .Regiter, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    
    internal func updateUserDetails(mobileNo: String, country: String, birthdate: String, gender: String, language: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.UpdateCurrentUser)
        Log(url?.description ?? "")
        
        //        StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters = [
            StringKeys.MOBILE_NUMBER:mobileNo,
            StringKeys.DATE_OF_BIRTH:birthdate,
            StringKeys.GENDER:gender,
            StringKeys.LANGUAGE:language,
            StringKeys.White_Listed:UserDefaultsManager.getWhitList(),
            StringKeys.COUNTRYCODE:""
        ] as [String : Any]
        
        request(url!, apiCallType: .UpdateCurrentUser, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    internal func requestPhoneCode( success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: mobileCodeRequestUrl)
        Log(url?.description ?? "")
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        //        let parameters = [
        ////            StringKeys.MOBILE_NUMBER:mobileNo,
        ////            StringKeys.White_Listed:true
        //            ] as [String : Any]
        
        request(url!, apiCallType: .UpdateCurrentUser, method: .post, parameters: nil, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    
    internal func getNotificationList(startDate: String, endDate: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        //https://susilamobiletv.info/mobile-tv-webservice/api/v1/notification/received
        //let url = URL(string: kAPIBaseUrl + SubUrl.GetNotification + "?limit=50" + "&start_date=" + startDate + "&end_date=" + endDate + "&offset=0" )
        let url = URL(string: kAPIBaseUrl + SubUrl.GetNotification + "?limit=50" )
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    internal func readNotifications(idArray: Array<Any>, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        //https://susilamobiletv.info/mobile-tv-webservice/api/v1/notification/received
        //let url = URL(string: kAPIBaseUrl + SubUrl.GetNotification + "?limit=50" + "&start_date=" + startDate + "&end_date=" + endDate + "&offset=0" )
        let url = URL(string: kAPIBaseUrl + SubUrl.readNotifications)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        //        let parameters: [String: Any]? = nil
        //        let parameters = [
        //
        //            StringKeys.SMSCode:idArray
        //
        //            ] as [String : Any]
        
        requestNoti(url!, apiCallType: .GetPrograms, method: .post, parameters: idArray, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    internal func clearNotification(notificationID: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        let url = URL(string: kAPIBaseUrl + SubUrl.ClearNotifications + "/" + String(notificationID) )
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func clearAllNotification(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        let url = URL(string: kAPIBaseUrl + SubUrl.ClearNotifications)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getYouMightLike(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.YouMightAlsoLike )
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getPopularSongs(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.YouMightAlsoLike )
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getHomePopularSongs(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.HomePopularSongs)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetHomePopularSongs, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getHomeLatestSongs(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.HomeLatestSongs)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetHomeLatestSongs, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getHomePopularArtist(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.HomePopularArtists)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPopularArtist, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getGenreArtists(id: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.BrowseGenreArtists + String(id) + "/artists")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPopularArtist, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getGenrePlaylists(id: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.BrowseGenrePlaylists + String(id) + "/playlists")
        Log(url?.description ?? "")
        //let url = URL(string: kAPIBaseUrl + SubUrl.GlobalPlaylist)
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetGenrePlaylists, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getHomePopularArtistSongs(id: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.HomePopularArtistSongs + String(id) + "/songs")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPopularArtist, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getBrowseAllArtist(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.BrowseAllArtistSongs)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetBrowseAllArtist, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getRadioChannels(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.RadioChannels)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetRadioChannels, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getLatestPlaylistSongs(id: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.LatestPlaylistSongs + id + "?g=true")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetLatestPlaylistSongs, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getAllSongsList(offset:Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.AllSongs + "?limit=10&offset=\(offset)" )
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getAllSongsGenreList(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.AllSongsGenre )
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    //Library
    internal func getLibrarySongs(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.LibrarySongs)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .getLibraySongs, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getLibraryArtists(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.LibraryArtists)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .getLibrayArtists, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func searchSongs( text:String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        guard let url = URL(string: kAPIBaseUrl + SubUrl.Search + "/\(sanitizeString(text))") else {
            failure(NSError(domain: "", code: 0, userInfo: [:]))
            return
        }
        
        Log(url.description)
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func searchByWord(text:String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        guard let url = URL(string: kAPIBaseUrl + SubUrl.SearchByWord + "\(sanitizeString(text))") else {
            failure(NSError(domain: "", code: 0, userInfo: [:]))
            return
        }
        Log(url.description)
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url, apiCallType: .SearchByWord, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func searchByWordAll(key: String, type: String, offset: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        var url: URL?
        let baseURLString = kAPIBaseUrl + SubUrl.SearchByWordAll + "query_text=%@&type=%@&offset=%@&limit=10"
        if type=="song" {
            url = URL(string: String(format: baseURLString, key,type,offset.description).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        } else {
            url = URL(string: String(format: baseURLString, key,type,"0").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        }
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .SearchByWordAll, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getSearchHistory(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.GetSearchHistory)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetSearchHistory, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getRecentSongs(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.RecentSongs)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    func sanitizeString(_ param: String) -> String {
        return param.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    internal func getSongsOfGenre(offset: Int, genre:String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        guard let url = URL(string: kAPIBaseUrl + SubUrl.SongsOfGenre + "/\(sanitizeString(genre))?offset="+String(offset)+"&limit=10") else {
            failure(NSError(domain: "", code: 0, userInfo: [:]))
            return
        }
        
        Log(url.description)
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getGlobalPlayLists(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.GlobalPlaylist + "?g=true&offset=0&limit=200")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
            //NSLog("Worked43 : \(String(describing: data))")
            //NSLog("Worked43C : \(String(describing: code))")
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getPlaylists(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.GlobalPlaylist )
        Log(url?.description ?? "")
        //let url = URL(string: kAPIBaseUrl + SubUrl.GlobalPlaylist)
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getKiKiPlaylists(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.LibraryPlaylist)
        Log(url?.description ?? "")
        //let url = URL(string: kAPIBaseUrl + SubUrl.GlobalPlaylist)
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetLibrayPlaylists, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getAllPlaylist(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.GlobalPlaylist + "?g=true&offset=0&limit=200")
        Log(url?.description ?? "")
        //let url = URL(string: kAPIBaseUrl + SubUrl.GlobalPlaylist)
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func createPlaylist(playlistName:String, imageUrl:String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl+SubUrl.createPlaylist)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters = [
            StringKeys.NAME:playlistName,
            StringKeys.BASE_64:imageUrl
        ] as [String : Any]
        
        request(url!, apiCallType: .CreatePlaylist, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func addToPlaylist(playlistId:String, songs:[String], success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl+SubUrl.AddSongsToPlaylist)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters = [
            StringKeys.PLAYLIST_ID: playlistId,
            StringKeys.SONGS: songs
        ] as [String : Any]
        
        request(url!, apiCallType: .AddSongsToPlaylist, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func addToLibrary(key:String, songs:Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl+SubUrl.addToLibary)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        print("Key S song id's ", [songs])
        let parameters = [
            StringKeys.TYPE: key,
            StringKeys.IDS: [songs]
        ] as [String : Any]
        
        request(url!, apiCallType: .AddToLibrary, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func removeFromLibrary(key:String, id:Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl+SubUrl.removeFromLibary)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        let parameters = [
            StringKeys.TYPE: key,
            StringKeys.IDS: [id]
        ] as [String : Any]
        
        request(url!, apiCallType: .RemoveFromLibrary, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func removePlaylistFromLibrary(id:Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl+SubUrl.removePlaylistFromLibary)
        Log(url?.description ?? "")
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        let parameters = [
            StringKeys.ID: String(id)
        ] as [String : Any]
        
        request(url!, apiCallType: .RemovePlaylistFromLibrary, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    /*internal func addToPlaylist( playlistId:Int, songId:Int, success: @escaping (_ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
     
     let url = URL(string: kAPIBaseUrl + SubUrl.AddSongsToPlaylist + "/\(playlistId)" )
     
     requestPost(url!, body: "[\(songId)]", success: { (data, code) -> Void in
     success(code)
     }) { (error) -> Void in
     failure(error)
     }
     }*/
    
    internal func playlistLoadTempTable(session_id: String, pid: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.playlistLoadTempTable)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters = [
            StringKeys.SESSION_ID:session_id,
            StringKeys.PLAYLISTID: pid
        ] as [String : Any]
        
        request(url!, apiCallType: .PlaylistLoadTempTable, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func updatePlaylist(name: String, pid: Int, songs: [Int], image:String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.updatePlaylist)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters = [
            StringKeys.NAME: name,
            StringKeys.PLAYLIST_ID: pid,
            StringKeys.SONGS: songs,
            StringKeys.BASE_64: image
        ] as [String : Any]
        
        request(url!, apiCallType: .UpdatePlaylist, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func addToTempPlaylist(session_id: String, ref_id: Int, type: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.addToTempPlaylist)
        Log(url?.description ?? "")
        // + "?song_id=" + String(songId) + "&session_id=" + session_id
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters = [
            StringKeys.SESSION_ID:session_id,
            StringKeys.REF_ID: ref_id,
            StringKeys.TYPE: type
        ] as [String : Any]
        
        request(url!, apiCallType: .AddToTempPlaylist, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getPlaylistData(pid: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + "playlist/playlistdata/" + String(pid) + "?g=false")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .AddToTempPlaylist, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getTempPlaylist(session_id: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.getTempPlaylist + session_id)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetTempPlaylist, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
            print(error)
        }
    }
    
    internal func getSongsOfPlaylist(listID:Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.SongsOfPlaylist + "/\(listID)")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getSuggessionSongs(songID:Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.GetSuggessionSongs + "limit=10&offset=0&song_id=\(songID)")
        Log(url?.description ?? "")
        
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetSuggessionSongs, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getSongsOfPlaylistGlobal(listID:Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.SongsOfPlaylist + "/\(listID)?g=true")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getSongById(sid: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.GetSongById + sid)
        Log(url?.description ?? "")
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetSongById, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getArtistById(aid: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.GetArtistById + aid)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetArtistById, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getPlaylistById(pid: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.GetPlaylistById + pid + "?g=true")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPlaylistById, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getEpisodeList(programID: Int, offset: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        //        let url = URL(string: kAPIBaseUrl + SubUrl.GetPrograms + "/\(programID)" + "/episodes" + "?limit=100000" + "&start_date=" + "&end_date=" + "&offset=" + "\(offset)")
        let url = URL(string: kAPIBaseUrl + SubUrl.GetPrograms + "/\(programID)" + "/allepisodes" + "?limit=20" + "&offset=" + "\(offset)")
        Log(url?.description ?? "")
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getSubtitle(urlStr: String, success: @escaping (_ data: String?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        Log(urlStr)
        Alamofire.request(urlStr,
                          parameters: nil,
                          headers: [:]
        )
        .responseString(encoding: String.Encoding.utf8 ,completionHandler: { response in
            switch response.result {
            case .success( let data):
                if let responseReceived = response.response {
                    success(data, responseReceived.statusCode)
                } else {
                    failure(ErrorHandler.NoResponseForRequest)
                }
            case .failure(let error):
                failure(error as NSError)
            }
        })
    }
    
    internal func getAdvertisement(programId: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        let url = URL(string: kAPIBaseUrl + "ads/content?content_id=\(programId)")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func smsCodeVerify(smsCode: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.SMSVerify)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters = [
            
            StringKeys.SMSCode:smsCode
            
        ] as [String : Any]
        
        request(url!, apiCallType: .SMSVerify, method: .post, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func validatePromoCode(promoCode: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string: kAPIBaseUrl + SubUrl.PromoCode + sanitizeString(promoCode))
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .PromoCode, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getSubscribe(programID: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        //https://susilamobiletv.info/mobile-tv-webservice/api/v1/content/action/subscribe/PROGRAM_ID
        
        let url = URL(string: kAPIBaseUrl + "content/action/2" + "/\(programID)/2")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .Subscribe, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    internal func getUnSubscribe(programID: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        //https://susilamobiletv.info/mobile-tv-webservice/api/v1/content/action/subscribe/PROGRAM_ID
        
        let url = URL(string: kAPIBaseUrl + "content/action/2" + "/\(programID)/2")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .Subscribe, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func trailer(programId: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        let url = URL(string: kAPIBaseUrl + SubUrl.Trailer + "\(programId)")
        Log(url?.description ?? "")
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .ProgramTrailer, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func likeProgram(programId: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        let url = URL(string: kAPIBaseUrl + SubUrl.LikeProgram + "\(programId)")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .LikeProgram, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func likeProgram_v2(contentType: Int, contentId: Int, actionType: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        let url = URL(string: kAPIBaseUrl + SubUrl.LikeProgram_v2 + "\(contentType)/" + "\(contentId)/" + "\(actionType)")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .LikeProgram, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func sendAnalytics(actionType: String, contendId:Int, currentTime:String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        let url = URL(string: kAPIBaseUrl + SubUrl.sendAnalytics + "\(sanitizeString(actionType))/\(contendId)?action_time=\(currentTime)")
        Log(url?.description ?? "")
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        let parameters: [String: Any]? = nil
        request(url!, apiCallType: .SendAnalytics, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getCurrentPackage(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        ///mobile-tv-webservice/api/v1/subscription/packages
        
        let url = URL(string: kAPIBaseUrl + SubUrl.GetCurrentPackage)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetCurrentPackage, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getPackageList(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        ///mobile-tv-webservice/api/v1/subscription/packages
        
        let url = URL(string: kAPIBaseUrl + SubUrl.GetPackageList )
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPackageList, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    
    internal func subscribePackage(packageId: Int, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        ///mobile-tv-webservice/api/v1/subscription/packages
        
        let url = URL(string: kAPIBaseUrl + SubUrl.SubscribePackage + "\(packageId)")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .SubscribePackage, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    internal func getSubscribedListWithouthChannelID(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        //https://susilamobiletv.info/mobile-tv-webservice/api/v1/content/programs/PROGRAM_ID/episodes
        //let url = URL(string: kAPIBaseUrl + SubUrl.GetSubscribedList + "?channel=" + "\(channelID)" )
        //let url = URL(string: kAPIBaseUrl + SubUrl.GetSubscribedList + "?k=\(Preferences.getSettingKidsMode())")
        
        let url = URL(string: kAPIBaseUrl + SubUrl.GetSubscribedList)
        Log(url?.description ?? "")
        
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetSubscribedList, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    
    // MARK: - BaseHomeVwSideShow
    internal func getCarouselList(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        //https://susilamobiletv.info/mobile-tv-webservice/api/v1/content/programs/PROGRAM_ID/episodes
        let url = URL(string: kAPIBaseUrl + SubUrl.GetImageList + "?k=\(UserDefaultsManager.getSettingKidsMode())&offset=0&limit=8")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetChannelImageList, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    // MARK: - BaseHomeVwProgramsId
    internal func getChannelList(success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        //https://cdn.kiki.lk/mobile-tv-webservice/api/v1/content/channels
        let url = URL(string: kAPIBaseUrl + SubUrl.GetChannelList + "?k=\(UserDefaultsManager.getSettingKidsMode())")
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetChannelList, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    // MARK: - BaseHomeVwProgramsList
    internal func getPrograms(channelID: Int, isTrailers:Bool, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        var parameter =  "?channel=\(channelID)&offset=0&limit=500"
        if (isTrailers) {
            parameter = parameter + "&sort=random&t=true"
        } else {
            parameter = parameter + "&sort=latest"
        }
        let url = URL(string: kAPIBaseUrl + SubUrl.GetPrograms + parameter)
        Log(url?.description ?? "")
        
        let headers: HTTPHeaders = [
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? ""
        ]
        
        let parameters: [String: Any]? = nil
        
        request(url!, apiCallType: .GetPrograms, method: .get, parameters: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    fileprivate func requestPost(_ url: URL, body: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        func callAPIrequest(){
            Log(url.description)
            var request = URLRequest(url: url)
            request.httpBody = body.data(using: String.Encoding.utf8, allowLossyConversion: true)
            request.httpMethod = "POST"
            request.addValue(StringKeys.CONTENT_TYPE, forHTTPHeaderField: StringKeys.HEADER_CONTENT_TYPE)
            request.addValue(kBasicServerAuthToken, forHTTPHeaderField: StringKeys.HEADER_AUTHORIZATION)
            request.addValue(UserDefaultsManager.getAccessToken() ?? "", forHTTPHeaderField: StringKeys.HEADER_TOKEN_AUTHENTICATION)
            
            
            Alamofire.request(request).responseJSON { (dataResponse:DataResponse<Any>) in
                if let response = dataResponse.response {
                    _ = HttpValidator.validate(response.statusCode)
                }
                switch dataResponse.result {
                case .success( let data):
                    if let response = dataResponse.response {
                        let validateResult = HttpValidator.validate(response.statusCode)
                        
                        _ = JSON(data)
                        success(data as AnyObject?, validateResult.code)
                    } else {
                        failure(ErrorHandler.NoResponseForRequest)
                    }
                case .failure( _):
                    failure(ErrorHandler.ConnectionTimeout)
                }
            }
        }
        if !Common.isNetworkAvailable() {
            return failure(ErrorHandler.NoNetwork)
        } else {
            callAPIrequest()
        }
    }
    
    
    /**
     Send a POST request.
     
     - parameter url:
     - parameter method: HTTPMethod
     - parameter parameters: URL parameters.
     - parameter success:    Closure executed on successful request completion.
     - parameter failure:    Cloure executed on request failure.
     */
    
    fileprivate func request(_ url: URL, apiCallType:APICalls, method: HTTPMethod, parameters: [String: Any]?, headers: HTTPHeaders, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        //        Log(url.description)
        //        NSLog("url ---- : \(url)")
        //        NSLog("parameters ---- : \(String(describing: parameters))")
        //        NSLog("headers ---- : \(headers)")
        //        NSLog("method ---- : \(method.rawValue)")
        
        func callAPIrequest(){
            //            if let accessToken = Preferences.getAccessToken(){
            //            let json = "[692921]"
            //
            ////            let url = URL(string: url)!
            //            let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
            //
            //            var request = URLRequest(url: url)
            //            request.httpMethod = HTTPMethod.post.rawValue
            //            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            //            request.httpBody = jsonData
            Alamofire.request(url.absoluteString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (dataResponse:DataResponse<Any>) in
                
                if let response = dataResponse.response {
                    let validateResult = HttpValidator.validate(response.statusCode)
                    //                    print("validateResult ---- : \(validateResult)")
                    
                }
                switch dataResponse.result {
                case .success( let data):
                    if let response = dataResponse.response {
                        let validateResult = HttpValidator.validate(response.statusCode)
                        
                        //                        let currentData = JSON(data)
                        //                        print("Data ---- : \(currentData)")
                        
                        switch apiCallType{
                        case .Login:
                            
                            success(data as AnyObject?, validateResult.code)
                        case .Regiter:
                            
                            success(data as AnyObject?, validateResult.code)
                            
                            
                            
                        default:
                            switch validateResult.code{
                            default:
                                success(data as AnyObject?, validateResult.code)
                                
                            }
                        }
                    } else {
                        failure(ErrorHandler.NoResponseForRequest)
                        NSLog("No response for POST request: \(String(describing: dataResponse.error))")
                    }
                case .failure(let error):
                    failure(ErrorHandler.ConnectionTimeout)
                    
                    NSLog("API Failure: \(error)")
                    
                }
            }
            //            }else{
            //                getError()
            //            }
        }
        
        
        if !Common.isNetworkAvailable() {
            
            return failure(ErrorHandler.NoNetwork)
        }else{
            callAPIrequest()
        }
    }
    fileprivate func requestNoti(_ url: URL, apiCallType:APICalls, method: HTTPMethod, parameters: Array<Any>, headers: HTTPHeaders, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        //        NSLog("url ---- : \(url)")
        //        NSLog("parameters ---- : \(parameters)")
        //        NSLog("headers ---- : \(headers)")
        //        NSLog("method ---- : \(method.rawValue)")
        Log(url.description)
        func callAPIrequest(){
            let paramsJSON = JSON(parameters)
            let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: .prettyPrinted)
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue(StringKeys.CONTENT_TYPE, forHTTPHeaderField: StringKeys.HEADER_CONTENT_TYPE)
            request.setValue(kBasicServerAuthToken, forHTTPHeaderField: StringKeys.HEADER_AUTHORIZATION)
            request.setValue(UserDefaultsManager.getAccessToken() ?? "", forHTTPHeaderField: StringKeys.HEADER_TOKEN_AUTHENTICATION)
            
            request.httpBody = paramsString?.data(using: .utf8)
            Alamofire.request(request).responseJSON { (dataResponse:DataResponse<Any>) in
                
                if let response = dataResponse.response {
                    let validateResult = HttpValidator.validate(response.statusCode)
                    print("validateResult notifications---- : \(validateResult)")
                    
                }
                switch dataResponse.result {
                case .success( let data):
                    if let response = dataResponse.response {
                        let validateResult = HttpValidator.validate(response.statusCode)
                        
                        let currentData = JSON(data)
                        print("Data ---- : \(currentData)")
                        
                        switch apiCallType{
                        case .Login:
                            
                            success(data as AnyObject?, validateResult.code)
                        case .Regiter:
                            
                            success(data as AnyObject?, validateResult.code)
                            
                            
                            
                        default:
                            switch validateResult.code{
                            default:
                                success(data as AnyObject?, validateResult.code)
                                
                            }
                        }
                    } else {
                        failure(ErrorHandler.NoResponseForRequest)
                        NSLog("No response for POST request: \(String(describing: dataResponse.error))")
                    }
                case .failure(let error):
                    failure(ErrorHandler.ConnectionTimeout)
                    
                    NSLog("API Failure: \(error)")
                    
                }
            }
            //            }else{
            //                getError()
            //            }
        }
        if !Common.isNetworkAvailable() {
            return failure(ErrorHandler.NoNetwork)
        }else{
            callAPIrequest()
        }
    }
}


typealias ChatService  = ApiClient
extension ChatService{
    
    /*
     let params:[String:Any] = [
     "receiptString":receiptData,
     "planId":packageID,
     "viewerId":Int(viewerID)
     ]
     Log(params.description)
     
     let url = URL(string: IAPBaseURL + SubUrl.ActivateIAPPackage)!
     Log(url.absoluteString)
     ServiceManager.APIRequest(url: url, method: .post, params: params) { (response, responseCode) in
     if responseCode == 200{
     let jsonData:JSON = JSON((response as! DataResponse<Any>).result.value!)
     Log(jsonData.description)
     if let jsonResponse = jsonData as? JSON{
     if let status = jsonResponse["status"].string{
     if status == "ACCEPT"{
     onComplete(true)
     }else{
     
     */
    
    private func generateChatHeader() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            StringKeys.HEADER_CONTENT_TYPE: StringKeys.CONTENT_TYPE,
            StringKeys.HEADER_AUTHORIZATION: kBasicServerAuthToken,
            StringKeys.HEADER_TOKEN_AUTHENTICATION: UserDefaultsManager.getAccessToken() ?? "N/A"
        ]
        return headers
    }
    
    func getChatToken(onComplete:@escaping (String?)->()){
        let url = URL(string: kAPIBaseUrl + SubUrl.ChatToken)!
        ServiceManager.APIRequest(url: url, method: .get,headers: generateChatHeader()) { (response, reponseCode) in
            if reponseCode == 200{
                let jsonData:JSON = JSON((response as! DataResponse<Any>).result.value!)
                if let data = jsonData["data"].dictionary{
                    if let token = data["Token"]?.string{
                        onComplete(token)
                    }
                }
                onComplete(nil)
            }
            onComplete(nil)
        }
    }
    
    func getChatChannels(onComplete:@escaping ([ChatChannel]?)->()){
        let url = URL(string: kAPIBaseUrl + SubUrl.Chennels)!
        var tempArray:[ChatChannel]?
        ServiceManager.APIRequest(url: url, method: .get,headers: generateChatHeader()) { (response, responseCode) in
            if responseCode == 200{
                tempArray = []
                let jsonData:JSON = JSON((response as! DataResponse<Any>).result.value!)
                if let jsonArray = jsonData.array{
                    for json in jsonArray{
                        let id = json["id"].int ?? 0
                        let sid = json["sid"].string ?? ""
                        let accountSID = json["accountSid"].string ?? ""
                        let serviceSID = json["serviceSid"].string ?? ""
                        let friendlyName = json["friendlyName"].string ?? ""
                        let uniqueName = json["uniqueName"].string ?? ""
                        let imageURL = json["imagePath"].stringValue.decodedURL
                        let isBlocked = json["block"].bool ?? false
                        let isMember = json["member"].bool ?? false
                        let chatChannel = ChatChannel(id: id, sid: sid, accountSid: accountSID, serviceSid: serviceSID, friendlyName: friendlyName, uniqueName: uniqueName, imageURL: imageURL, isBlocked: isBlocked, isMember: isMember)
                        tempArray?.append(chatChannel)
                    }
                }
            }
            onComplete(tempArray)
        }
    }
    
    func createMember(name:String,roleID:String,userID:String, for channel: ChatChannel,onComplete:@escaping (Bool)->()){
        let url = URL(string: kAPIBaseUrl + SubUrl.CreateMember)!
        
        let params:[String:Any] = [
            "sid": channel.sid,
            "accountSid": channel.accountSid,
            "serviceSid": channel.serviceSid,
            "name": name, //logged users name
            "identity": userID, // logged user ID
            "imagePath": channel.imageURL?.absoluteString.encodeURL,
            "roleId": roleID, // ID from role GET
            "channelIds": [channel.id]
        ]
        
        ServiceManager.APIRequest(url: url, method: .post, params: params, headers: generateChatHeader()) { (response, responseCode) in
            if responseCode == 200{
                let jsonData:JSON = JSON((response as! DataResponse<Any>).result.value!)
                if let code = jsonData["code"].string, let message = jsonData["message"].string{
                    if code == "201" && message == "Success"{
                        onComplete(true)
                    }else{
                        onComplete(false)
                    }
                }else{
                    onComplete(false)
                }
            }else{
                onComplete(false)
            }
        }
    }
    
    func getMemberRole(for type:MemberRoleType,onComplete:@escaping (String?)->()){
        let urlSuffix = String(format: SubUrl.MemberRole, type.rawValue)
        let url = URL(string: kAPIBaseUrl + urlSuffix)!
        ServiceManager.APIRequest(url: url, method: .get,headers: generateChatHeader()) { (response, reponseCode) in
            if reponseCode == 200{
                let jsonData:JSON = JSON((response as! DataResponse<Any>).result.value!)
                if let roleID = jsonData["id"].int{
                    onComplete(roleID.description)
                }else{
                    onComplete(nil)
                }
            }else{
                onComplete(nil)
            }
        }
    }
    
    func getMembers(for type:MemberRoleType, in channel:ChatChannel, onComplete:@escaping ([ChatMember]?)->()){
        let urlSuffix = String(format: SubUrl.Members, channel.id.description,type.rawValue)
        let url = URL(string: kAPIBaseUrl + urlSuffix)!
        var tempArray:[ChatMember]?
        
        ServiceManager.APIRequest(url: url, method: .get,headers: generateChatHeader()) { (response, responseCode) in
            if responseCode == 200{
                tempArray = []
                let jsonData:JSON = JSON((response as! DataResponse<Any>).result.value!)
                if let jsonArray = jsonData.array{
                    for json in jsonArray{
                        let name = json["name"].stringValue
                        let color:UIColor = json["colour"].stringValue.hexStringToUIColor
                        let imageURL = json["imagePath"].stringValue.decodedURL
                        let viewerID = json["viewerId"].stringValue
                        let artist = ChatMember(name: name, color: color, imageURL: imageURL, viewerID: viewerID, type: type)
                        tempArray?.append(artist)
                    }
                }
            }
            onComplete(tempArray)
        }
    }
}
