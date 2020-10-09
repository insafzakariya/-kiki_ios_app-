//
//  ExampleData.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 8/1/17.
//  Copyright © 2017 Yong Su. All rights reserved.
//

import Foundation

public struct Section {
    var name: String
    var collapsed: Bool
    var sectionID: Int
    var songs: [Song]
    
    init(name: String, collapsed: Bool = true, sectionID: Int, songs: [Song]) {
        self.name = name
        self.collapsed = collapsed
        self.sectionID = sectionID
        self.songs = songs
    }
}
