//
//  ChatArtist.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-07.
//

import Foundation

struct ChatMember{
    
    /*
     {
     "id": 22,
     "sid": null,
     "accountSid": null,
     "serviceSid": null,
     "name": "Hashen Dulanjana Silva",
     "identity": "657595",
     "imagePath": "https%3A%2F%2Fstorage.googleapis.com%2Fkiki_images%2Flive%2Fchat%2Fartist%2F",
     "viewerId": 657595,
     "roleId": 2,
     "roleName": "channel_admin",
     "colour": "#007FFF",
     "artistId": null,
     "channelIds": [],
     "channelDtos": []
     }
     */
    
    var name:String
    var color:UIColor
    var imageURL:URL?
    var viewerID:String
    var type:MemberRoleType
    
    
    static func getMember(from members:[ChatMember], for id:String) -> ChatMember?{
        return members.filter ({ $0.viewerID == id}).first
    }
    
    
}