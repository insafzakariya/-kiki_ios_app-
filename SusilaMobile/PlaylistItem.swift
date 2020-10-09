//
//  PlaylistItem.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/13/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

class PlaylistItem {
    
    var id = ""
    var name = ""
    var desc = ""
    var url = ""
    
    func add(id: String, name: String, desc: String, url: String) {
        //item.append([id, name, desc, url])
        mainInstance.item.append([id, name, desc, url])
        
        print("Values ",id ," ",name," ",desc," ",url)
        print("Array ", mainInstance.item)
    }
    
    func isExists(id: String) {
        if mainInstance.item.contains(where: { $0.contains(id) }) {
            print("Exists")
        }
    }
}
