//
//  Channel.swift
//  SusilaMobile
//
//  Created by Isuru_Jayathissa on 10/11/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class Channel: NSObject {

    var id: Int
    var name: String
    var image: String?
    var description_c: String?

    
    init(id: Int, name: String, image: String?, description_c: String?){
        
        self.id = id
        self.name = name
        self.image = image
        self.description_c = description_c
    }
    
    
}


extension Channel {
    
    internal struct JsonKeys{
        
        static let name = "name"
        static let id = "id"
        static let image = "image"
        static let description_c = "description"
        
    }
    
}
