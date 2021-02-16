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
    var artistCount:Int = 0
    
    func getMessages(onCompleted:@escaping()->()){
        chatManager.getMessages(messageCount: ChatConfig.messageCount) { (isSuccess, messages) in
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
    
    func getArtists(for channel:ChatChannel, onCompleted:@escaping ()->()){
        chatService.getMembers(in: channel) { (members) in
            if let artists = members{
                self.artists = artists
                self.artistCount = artists.count
            }
            onCompleted()
        }
    }
    
    private func getFans(for channel:ChatChannel,onCompleted:@escaping()->()){
        chatService.getMembers(for: .User, in: channel) { (members) in
            if let fans = members{
                self.users = fans
            }else{
                self.users = []
            }
            onCompleted()
        }
    }
    
    private func setTotalMember(){
        self.allUsers = self.artists! + self.users!
    }
    
    func sendMessage(message:String,isSuccess:@escaping(Bool)->()){
        chatManager.sendMessage(message: message) { (result, message) in
            isSuccess(result.isSuccessful())
        }
    }
    
    
    func updateMembers(for channel:ChatChannel,onCompleted:(()->())?){
        getArtists(for: channel) { 
            self.getFans(for: channel) {
                self.setTotalMember()
                onCompleted?()
            }
        }
    }
    
    deinit {
        messages.removeAll()
        artists = nil
        users = nil
        allUsers = nil
    }
}
