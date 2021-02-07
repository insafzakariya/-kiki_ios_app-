//
//  ChatManager.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-07.
//

import Foundation
import TwilioChatClient

protocol ChatManagerDelegate:AnyObject {
    func reloadMessaged()
    func receivedNewMessage()
}

class ChatManager:NSObject{
    
    static let shared = ChatManager()
    
    private var client:TwilioChatClient?
    private var connectedChannel:TCHChannel?
    weak var delegate:ChatManagerDelegate?
    private(set) var messages:[TCHMessage] = []
    
    private var initializationCompletionHanler:((_ value:Bool)-> ())?
    
    var channelSID:String?
    
    
    private override init() {
        super.init()
    }
    
    func initializeClient(with token:String,isCompleted:@escaping (Bool)->()){
        TwilioChatClient.chatClient(withToken: token, properties: nil, delegate: self) { [weak self] (result, chatClient) in
            self?.client = chatClient
            self?.initializationCompletionHanler = isCompleted
            if let e = result.error{
                Log("Failed due to \(e.localizedDescription)")
            }
        }
    }
    
    func exit(){
        if let client = self.client{
            client.delegate = nil
            client.shutdown()
            self.client = nil
        }
    }
    
    func sendMessage(message:String, completion:@escaping (TCHResult,TCHMessage?)->()){
        if let messages = connectedChannel?.messages{
            let messageOptions = TCHMessageOptions().withBody(message)
            messages.sendMessage(with: messageOptions) { (result, message) in
                completion(result,message)
                if let e = result.error{
                    Log("send Message failed duw to \(e.localizedDescription)")
                }
            }
        }
    }
    
    private func checkChannel(for SID:String,_ completion: @escaping (TCHResult?,TCHChannel?)->()){
        guard let client = client, let channelList = client.channelsList() else {
            return
        }
        channelList.channel(withSidOrUniqueName: SID) { (result, channel) in
            completion(result,channel)
            if let e = result.error{
                Log("Check chennel failed due to \(e.localizedDescription)")
            }
        }
    }
    
    private func join(channel:TCHChannel,completion:@escaping (Bool)->()){
        self.connectedChannel = channel
        if channel.status == .joined{
            Log("User has already joined the channel")
            completion(true)
        }else{
            channel.join { (result) in
                completion(result.isSuccessful())
                if let e = result.error{
                    Log("Couldn't join due to: \(e.localizedDescription)")
                }
                
            }
        }
    }
    
    private func updateToken(_ token:String,completion:@escaping (Bool)->()){
        self.client?.updateToken(token, completion: { (result) in
            completion(result.isSuccessful())
            if let e = result.error{
                Log("Failed to update token due to \(e.localizedDescription)")
            }
        })
    }
    
    private func refreshToken(){
        let chatService = ChatServiceManager.shared
        chatService.getChatToken { (token) in
            if let newToken = token{
                self.updateToken(newToken) { (isSuccess) in
                    if isSuccess{
                        Log("Chat Token updated successfully")
                    }else{
                        Log("Chat Token failed to update")
                    }
                }
            }
        }
    }
}


extension ChatManager:TwilioChatClientDelegate{
    
    func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        if status == .completed{
            checkChannel(for: channelSID!) { (result, chanel) in
                if let res = result{
                    if res.isSuccessful(){
                        if let channel = chanel{
                            self.join(channel: channel) { (isJoined) in
                                if isJoined{
                                    Log("Joined to \(channel.uniqueName ?? "N/A")")
                                }else{
                                    Log("Couldn't joined to \(channel.uniqueName ?? "N/A")")
                                }
                                self.initializationCompletionHanler!(isJoined)
                            }
                        }
                    }else{
                        Log("Check Channel failed due to: \(res.error?.localizedDescription ?? "N/A")")
                        self.initializationCompletionHanler!(res.isSuccessful())
                    }
                }
                
            }
        }
        
    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
        messages.append(message)
        DispatchQueue.main.async {
            self.delegate?.reloadMessaged()
            if self.messages.count > 0 {
                self.delegate?.receivedNewMessage()
            }
        }
    }
    
    func chatClientTokenExpired(_ client: TwilioChatClient) {
        refreshToken()
    }
    
    func chatClientTokenWillExpire(_ client: TwilioChatClient) {
        refreshToken()
    }
}
