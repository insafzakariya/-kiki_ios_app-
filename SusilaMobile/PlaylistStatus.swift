//
//  PlaylistStatus.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/17/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class PlaylistStatus {
    
    var response: String
    
    init(response: String) {
        self.response = response
    }
}

extension PlaylistStatus {
    
    internal struct JsonKeys {
        static let response = "response"
    }
}
