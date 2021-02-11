//
//  ChatServiceManager.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-07.
//

import Foundation
import Alamofire

enum MemberRoleType:String{
    case Artist = "channel_admin"
    case User = "channel_user"
}

class ChatServiceManager{
    
    static let shared = ChatServiceManager()
    private var client = ApiClient()
    
    private init(){}
    
    
    func getChatToken(onCompleted:@escaping (String?)->()){
        client.getChatToken { (token) in
            onCompleted(token)
        }
    }
    
    func getChannels(onCompleted:@escaping ([ChatChannel]?)->()){
        client.getChatChannels { (channels) in
            onCompleted(channels)
        }
    }
    
    func createMember(name:String,userID:String, for channel: ChatChannel,onComplete:@escaping (Bool)->()){
        getUserMemberRole { (roleID) in
            if let ID = roleID{
                self.client.createMember(name: name, roleID: ID, userID: userID, for: channel) { (isSuccess) in
                    onComplete(isSuccess)
                }
            }
        }
    }
    
    private func getUserMemberRole(for type:MemberRoleType = .User,onComplete:@escaping (String?)->()){
        client.getMemberRole(for: type) { (roleID) in
            onComplete(roleID)
        }
    }
    
    
    func getMembers(for type:MemberRoleType = .Artist, in channel:ChatChannel, onComplete:@escaping ([ChatMember]?)->()){
        client.getMembers(for: type, in: channel) { (members) in
            onComplete(members)
        }
    }
    
    
}
