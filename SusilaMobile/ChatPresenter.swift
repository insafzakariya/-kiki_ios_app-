//
//  ChatPresenter.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-08.
//

import Foundation

class ChatPresenter{
    
    let navDismissHandler = "exitChatHandler"
    
    fileprivate let serviceLayer = ApiClient()
    var channels:[ChatChannel] = []
    
    
    func getChatWebURL(for chatID:String,using token:String) -> URL{
        let urlString = chatWebViewBaseURL + ApiClient.SubUrl.chatWebView
        return URL(string: String(format: urlString,token,chatID))!
    }
    
    func getChannels(){
        serviceLayer.getChatChannels { (channels) in
            self.channels = channels ?? []
        }
    }
    
    func getToken(onComplete:@escaping(String?)->()){
        if  let userID = Int(UserDefaultsManager.getUserId()!), let userName = UserDefaultsManager.getUsername(){
            serviceLayer.createMember(username: userName, userID: userID) { (token) in
                onComplete(token)
            }
        }
    }

}
