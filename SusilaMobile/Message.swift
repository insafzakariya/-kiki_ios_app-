//
//  File.swift
//  SusilaMobile
//
//  
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import Foundation

class Message {
    
    var messageId: Int
    var messageDate: String
    var messageType: Int
    var message: String?
    var read: Bool
    var expanded: Bool
    var expandedHeight: Float
    
    init(messageId: Int, messageDate: String, messageType: Int, message: String?, read: Bool, expanded: Bool, expandedHeight: Float){
        
        self.messageId = messageId
        self.messageDate = messageDate
        self.messageType = messageType
        self.read = read
        self.message = message
        self.expanded = expanded
        self.expandedHeight = expandedHeight
    }
}

extension Message {
    
    internal struct JsonKeys{
        
        static let messageId = "messageId"
        static let messageDate = "messageDate"
        static let messageType = "messageType"
        static let read = "read"
        static let message = "message"
        static let expanded = "expanded"
        static let expandedHeight = "expandedHeight"
    }
    
}
