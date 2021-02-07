//
//  ChatPresenter.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-07.
//

import Foundation

class ChatPresenter{
    
    fileprivate let chatService = ChatServiceManager.shared
    fileprivate let chatManager = ChatManager.shared
    
    var chatChannels:[ChatChannel] = []
    var chatToken:String?
    
    func getChatChannels(){
        chatService.getChannels { (channels) in
            if let channels = channels{
                self.chatChannels = channels
            }
        }
    }
    
    func getChatToken(){
        chatService.getChatToken { token in
            if let chatToken = token{
                self.chatToken = chatToken
            }
        }
    }
    
    func initializeChat(for channel:ChatChannel,isCompleted:@escaping(Bool)->()){
        if let token = self.chatToken{
            chatManager.initializeClient(with: token) { (isSuccess) in
                isCompleted(isSuccess)
            }
        }
    }
    
    func createMember(for channel:ChatChannel,onComplete:@escaping (Bool)->()){
        if let name = UserDefaultsManager.getUsername(),
           let userID = UserDefaultsManager.getUserId(){
            chatService.createMember(name: name, userID: userID, for: channel) { (isSuccess) in
                onComplete(isSuccess)
            }
        }
    }
    
    
}
