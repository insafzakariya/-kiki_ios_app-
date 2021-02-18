//
//  Song.swift
//  SusilaMobile
//
//  Created by MacBookSH on 12/10/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import Foundation

class Song {
    
    var id: Int
    var name: String
    var duration: Int?
    var date: String?
    var description: String?
    var image: String?
    var blocked: Bool?
    var url: String?
    var artist: String
    
    init(id: Int, name: String, duration: Int?, date: String, description: String?, image: String,blocked: Bool,url: String, artist: String){
        
        self.id = id
        self.name = name
        self.duration = duration
        self.date = date
        self.description = description
        self.image = image.removingPercentEncoding
        self.blocked = blocked
        self.url = url
        self.artist = artist
    }
}

extension Song {
    
    internal struct JsonKeys{
        
        static let id = "id"
        static let name = "name"
        static let duration = "duration"
        static let date = "date"
        static let description = "description"
        static let image = "image"
        static let blocked = "blocked"
        static let url = "url"
        static let fileURL = "fileUrl"
        static let artist = "artist"
    }
    
}

