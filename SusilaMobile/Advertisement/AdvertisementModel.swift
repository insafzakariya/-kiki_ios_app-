//
//  AdvertisementModel.swift
//  SusilaMobile
//
//  Created by Meuru Muthuthanthri on 7/20/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import Foundation

class AdvertisementModel: NSObject {
    var videoUrl: String?
    var webUrl: String
    var stopMainContent: Bool
    var clickAction: Bool
    var imageURL: String
    var title: String
    var duration: Int
    var startTime: Int
    var position: AdvertisementPosition
    var id: Int
    
    init(videoUrl: String?, webUrl: String, stopMainContent: Bool, clickAction: Bool, imageURL: String, title: String, duration: Int, startTime: Int, position: String, id: Int?) {
        self.videoUrl = videoUrl
        self.webUrl = webUrl
        self.stopMainContent = stopMainContent
        self.clickAction = clickAction
        self.imageURL = imageURL
        self.title = title
        self.duration = duration
        self.startTime = startTime
        self.position = AdvertisementPosition.init(rawValue: position) ?? AdvertisementPosition.unknown
        self.id = id ?? 0
    }
}

enum AdvertisementPosition : String {
    case top_right
    case top_left
    case scroll
    case full_screen
    case unknown
}

extension AdvertisementModel {
    
    internal struct JsonKeys{
        static let videoUrl = "videoURL"
        static let webUrl = "webURL"
        static let stopMainContent = "stopMainContent"
        static let clickAction = "clickAction"
        static let imageURL = "imageURL"
        static let title = "title"
        static let duration = "duration"
        static let startTime = "startTime"
        static let position = "position"
        static let id = "id"
    }
}
