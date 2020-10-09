//
//  GlobalPlaylistItem.swift
//  SusilaMobile
//
//  Created by MacBookSH on 12/6/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import Foundation

class GlobalPlaylistItem {
    
    var id: Int
    var order: Int
    var name: String
    var date: String?
    var image: String?
    var number_of_songs: Int
    
    init(id: Int, order: Int, name: String, date: String, image: String, number_of_songs: Int) {
        
        self.id = id
        self.order = order
        self.name = name
        self.date = date
        self.image = image
        self.number_of_songs = number_of_songs
    }
}

extension GlobalPlaylistItem {
    
    internal struct JsonKeys{
        
        static let id = "id"
        static let order = "order"
        static let name = "name"
        static let date = "date"
        static let image = "image"
        static let number_of_songs = "number_of_songs"
    }
    
}

