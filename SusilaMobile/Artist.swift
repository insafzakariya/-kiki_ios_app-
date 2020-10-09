//
//  Artist.swift
//  SusilaMobile
//
//  Created by Kiroshan on 1/13/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class Artist {
    
    var id: Int
    var name: String
    var image: String?
    var songsCount: Int?
    var numberOfAlbums: Int?
    
    init(id: Int, name: String, image: String, songsCount: Int?, numberOfAlbums: Int?) {

        self.id = id
        self.name = name
        self.image = image.removingPercentEncoding
        self.songsCount = songsCount
        self.numberOfAlbums = numberOfAlbums
        
    }
}

extension Artist {
    
    internal struct JsonKeys {
        static let id = "id"
        static let name = "name"
        static let image = "image"
        static let songsCount = "songsCount"
        static let numberOfAlbums = "numberOfAlbums"
    }
}
