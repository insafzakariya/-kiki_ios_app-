//
//  Channel.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-06.
//

import Foundation

/*
 {
         "id": 8,
         "sid": "CH5eae752253b943eb80d030bebec88105",
         "accountSid": "AC0ae07ea83c66c2d716ff0527351e567e",
         "serviceSid": "IS7007992d468d4190abc21181946f6093",
         "friendlyName": "INBOX",
         "uniqueName": "INBOX",
         "imagePath": "https%3A%2F%2Fstorage.googleapis.com%2Fkiki_images%2Flive%2Fchat%2Fchannel%2F00.png",
         "block": false,
         "member": true
     }
 */
struct ChatChannel{
    
    var name:String
    var imageURL:URL
    var isMember:Bool
    var isBlocked:Bool
}
