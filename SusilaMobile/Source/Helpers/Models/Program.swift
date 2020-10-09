//
//  Program.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/30/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import SwiftyJSON

class Program: NSObject {
    
    var id: Int
    var name: String
    @objc
    var image: String?
    var description_p: String?
    @objc
    var episode: Episode?
    var subscribed: Bool
    var liked:Bool
    @objc
    var type: String
    var channelId: Int
    
    init(id: Int, name: String, image: String?, description_p: String?, episode: Episode?, subscribed: Bool, type: String, channelId: Int, liked: Bool){
        self.id = id
        self.name = name
        self.image = image
        self.description_p = description_p
        self.episode = episode
        self.subscribed = subscribed
        self.type = type
        self.channelId = channelId
        self.liked = liked
    }
    
    convenience init(json: JSON) {
        self.init(id: json[Program.JsonKeys.id].int ?? -1, name: json[Program.JsonKeys.name].string ?? "", image: json[Program.JsonKeys.image].string, description_p: json[Program.JsonKeys.description_p].string, episode: nil, subscribed: json[Program.JsonKeys.subscribed].bool ?? false, type: json[Program.JsonKeys.type].string ?? "", channelId: json[Program.JsonKeys.id].int ?? 0, liked: json[Program.JsonKeys.liked].bool ?? false)
    }

}

extension Program {
    
    internal struct JsonKeys{
        static let name = "name"
        static let id = "id"
        static let image = "image"
        static let description_p = "description"
        static let episode = "episode"
        static let subscribed = "subscribed"
        static let type = "type"
        static let liked = "is_liked"
    }
}
