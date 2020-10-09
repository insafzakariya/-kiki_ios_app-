//
//  SongGenre.swift
//  SusilaMobile
//
//  Created by MacBookSH on 12/6/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import Foundation

class SongGenre {
    
    var genreId: Int
    var genreImage: String
    var genreDescription: String?
    var genreName: String?
    var genreColor: String
    
    init(genreId: Int, genreImage: String, genreDescription: String?, genreName: String, genreColor: String){
        
        self.genreId = genreId
        self.genreImage = genreImage
        self.genreDescription = genreDescription
        self.genreName = genreName
        self.genreColor = genreColor
    }
}

extension SongGenre {
    
    internal struct JsonKeys{
        
        static let genreId = "id"
        static let genreImage = "image"
        static let genreDescription = "description"
        static let genreName = "name"
        static let genreColor = "color"
    }
    
}
