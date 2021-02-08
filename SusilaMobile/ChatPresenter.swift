//
//  ChatPresenter.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-08.
//

import Foundation

class ChatPresenter{
    
    fileprivate let chatManager = ChatManager.shared
    fileprivate let chatService = ChatServiceManager.shared
    
    var messages:[ChatMessage] = []
    var artists:[ChatMember]?
    var users:[ChatMember]?
    var allUsers:[ChatMember]?
    
    
    func getMessages(onCompleted:@escaping()->()){
        chatManager.getMessages(messageCount: 1000) { (isSuccess, messages) in
            if let retrevedMessages = messages{
                for message in retrevedMessages{
                    var type:ContentType!
                    var content:String?
                    if let body = message.body{
                        if body.starts(with: "http"){
                            type = .URL
                            content = ChatMessage.extractURL(from: body)
                        }else{
                            type = .Text
                            content = body
                        }
                        self.messages.append(ChatMessage(senderID: message.author ?? "N/A", content: content ?? "", contentType: type))
                    }
                }
                onCompleted()
            }
        }
    }
    
    func getArtists(for channel:ChatChannel, onCompleted:@escaping (Int)->()){
        chatService.getMembers(in: channel) { (members) in
            if let artists = members{
                self.artists = artists
                onCompleted(artists.count)
            }else{
                onCompleted(0)
            }
            
        }
    }
    
    func getFans(for channel:ChatChannel,onCompleted:@escaping()->()){
        chatService.getMembers(for: .User, in: channel) { (members) in
            if let fans = members{
                self.users = fans
            }else{
                self.users = []
            }
            onCompleted()
        }
    }
    
    func setTotalMember(){
        self.allUsers = self.artists! + self.users!
    }
    
    func sendMessage(message:String){
        chatManager.sendMessage(message: message) { (result, message) in
            if result.isSuccessful(){
                Log("Message Send Success")
            }
        }
    }
    
    
}
