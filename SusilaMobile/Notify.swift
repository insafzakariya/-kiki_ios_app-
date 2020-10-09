//
//  Notify.swift
//  SusilaMobile
//
//  Created by Kiroshan on 5/14/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

class Notify {
    
    var status: Bool
    var title: String
    var body: String
    var image_url: String
    var type: String
    var content_type: String
    var content_id: String
    var date_time: String
    var list:Program
    
    init(status: Bool, title: String, body: String, image_url: String, type: String, content_type: String, content_id: String, date_time: String, list: Program) {
        self.status = status
        self.title = title
        self.body = body
        self.image_url = image_url
        self.type = type
        self.content_type = content_type
        self.content_id = content_id
        self.date_time = date_time
        self.list = list
    }
}

var notifyInstance = Notify(status: false, title: "", body: "", image_url: "", type: "", content_type: "", content_id: "", date_time: "", list: Program(id: 0, name: "", image: "", description_p: "", episode: nil, subscribed: false, type: "", channelId: 0, liked: false))
