//
//  Episode.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/30/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class Episode: NSObject {

    @objc
    var id: Int
    var name: String
    var image: String?
    var description_e: String?
    @objc
    var videoLink: String?
    var previewLink: String?
    var subtitleLink: String?
    var trailer_only: Bool
    
    init(id: Int, name: String, image: String?, description_e: String?, videoLink: String?, previewLink: String?, subtitleLink: String?, trailer_only: Bool){
        self.id = id
        self.name = name
        self.image = image
        self.description_e = description_e
        self.videoLink = videoLink
        self.previewLink = previewLink
        self.subtitleLink = subtitleLink
        self.trailer_only = trailer_only
    }
}


extension Episode {
    
    internal struct JsonKeys{
        
        static let name = "name"
        static let id = "id"
        static let image = "image"
        static let description_e = "description"
        static let video_link = "video_link"
        static let preview_link = "preview_link"
        static let trailer_only = "trailer_only"
    }
    
}
