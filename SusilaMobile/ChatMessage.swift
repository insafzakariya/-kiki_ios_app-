//
//  ChatMessage.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-08.
//

import Foundation
import TwilioChatClient

enum ContentType{
    case Text
    case URL
}

struct ChatMessage {
    
    var senderID:String
    var content:String
    var contentType:ContentType
    
    
    static func extractURL(from content:String) -> String?{
        if let decodedContent = content.decodedURL?.absoluteString{
            if decodedContent.contains("url=http"){
                if let urlPrefix = decodedContent.components(separatedBy: "url=").last{
                    if urlPrefix.contains(".gif&"){
                        if let url = urlPrefix.components(separatedBy: ".gif&").first{
                            let modifiedURL = url + ".gif"
                            return modifiedURL
                        }
                    }
                }
            }
        }
        return nil
    }
    
    static func convertMessage(message:TCHMessage)->ChatMessage?{
        var type:ContentType!
        var content:String?
        if let body = message.body{
            if body.starts(with: "http"){
                type = .URL
                content = ChatMessage.extractURL(from: body)
            }else{
                type = .Text
                content = body
            }
            return ChatMessage(senderID: message.author!, content: content ?? "", contentType: type)
        }
        return nil
    }
}
