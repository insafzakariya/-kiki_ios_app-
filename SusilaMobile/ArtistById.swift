//
//  ArtistById.swift
//  SusilaMobile
//
//  Created by Kiroshan on 5/25/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation
class ArtistById {
    
    var id: Int
    var name: String
    var image: String?
    var songsCount: String?
    var numberOfAlbums: String?
    
    init(id: Int, name: String, image: String, songsCount: String?, numberOfAlbums: String?) {

        self.id = id
        self.name = name
        self.image = image.removingPercentEncoding
        self.songsCount = songsCount
        self.numberOfAlbums = numberOfAlbums
        
    }
}

extension ArtistById {
    
    internal struct JsonKeys {
        static let id = "id"
        static let name = "name"
        static let image = "image"
        static let songsCount = "songsCount"
        static let numberOfAlbums = "numberOfAlbums"
    }
}
