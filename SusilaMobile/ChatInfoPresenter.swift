//
//  ChatInfoPresenter.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-07.
//

import Foundation

class ChatInfoPresenter{
    
    fileprivate let chatService = ChatServiceManager.shared
    
    var members:[ChatArtist]?
    
    
    func getMembers(for channel:ChatChannel,onCompleted:@escaping ()->()){
        chatService.getArtistMembers(in: channel) { (members) in
            if let members = members{
                self.members = members
                onCompleted()
            }
        }
    }
    
    
}
