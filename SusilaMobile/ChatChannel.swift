//
//  Channel.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-06.
//

import Foundation

struct ChatChannel{
    var id:Int
    var sid:String
    var accountSid:String
    var serviceSid:String
    var friendlyName:String
    var uniqueName:String
    var imageURL:URL?
    var isBlocked:Bool
    var isMember:Bool
}
