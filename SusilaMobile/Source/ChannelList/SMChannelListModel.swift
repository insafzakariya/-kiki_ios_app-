//
//  SMChannelListModel.swift
//  SusilaMobile
//
//  Created by Isuru_Jayathissa on 10/11/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

//import UIKit
import SwiftyJSON
import ImageSlideshow

class SMChannelListModel: BaseEpisodeModel {

    fileprivate let api = ApiClient()
    
    var programList: [Program] = [Program]()
    var newCategroyProg = Dictionary<String, Any>()

    var channelList: [Channel] = [Channel]()
    var channelImageList : [AlamofireSource] = [AlamofireSource]()
    var carousalProgramList : [Program] = [Program]()
    
    func getCarouselProgramList(getCarouselProgramListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getCarouselList(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{

                    self.channelImageList.removeAll()
                    self.carousalProgramList.removeAll()
                    for jsonObject in jsonList{

                        if let item = AlamofireSource(urlString: (jsonObject[Program.JsonKeys.image].string ?? "").removingPercentEncoding ?? ""){
                            self.channelImageList.append(item)
                        }
                        
                        self.carousalProgramList.append(Program(json: jsonObject))
                    }
                    
                    getCarouselProgramListCallFinished(true, nil, nil)

                }else{
                    getCarouselProgramListCallFinished(false, nil, nil)
                }
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getCarouselProgramListCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (getChannelImageListCallFinished): \(error.localizedDescription)")
            getCarouselProgramListCallFinished(false, error, nil)
        }
    }
    
    
    func getChannelList(getChannelListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getChannelList(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{

                    self.channelList.removeAll()
                    for jsonObject in jsonList{

                       let channel = Channel(id: jsonObject[Channel.JsonKeys.id].int ?? -1, name: jsonObject[Channel.JsonKeys.name].string ?? "", image: jsonObject[Channel.JsonKeys.image].string, description_c: jsonObject[Channel.JsonKeys.description_c].string)

                        self.channelList.append(channel)
                    }

                    getChannelListCallFinished(true, nil, nil)

                } else {
                    getChannelListCallFinished(false, nil, nil)
                }
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getChannelListCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (getEpisodeList): \(error.localizedDescription)")
            getChannelListCallFinished(false, error, nil)
        }
    }
    
    func getChannelListEpisode(channelID:Int, getChannelEpisodeListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: Bool) -> Void) {
        api.getPrograms(channelID: channelID, isTrailers: false, success: { (data, code) -> Void in
            switch code {
            case 200:
                let chId =  "\(channelID)"

                let jsonArray = JSON(data as Any).array
                if let jsonList = jsonArray {
                    if (!jsonList.isEmpty) {
                        self.programList.removeAll()
                        for jsonObject in jsonList {
                            self.programList.append(self.covertJsonToProgram(jsonObject, channelID: channelID))
                            //print("asASDSAD",  self.programList.count)
                        }
                        //if self.programList.count>1 {
                            self.newCategroyProg[chId] = self.programList
                        //}
                        
                        //                        self.userHostList.add(self.newCategroyProg)
                        //\\print("asASDSAD", self.newCategroyProg)

                        
                    
                        getChannelEpisodeListCallFinished(true, nil, false)
                    
                    } else {
                        
                        for (ind, jsonObject) in self.channelList.enumerated() {
                            if channelID == jsonObject.id {
                                self.channelList.remove(at: ind)
                            }
                            
                        }
                        getChannelEpisodeListCallFinished(false, nil, true)
                }
                }
            default:
                    let jsonData = JSON(data as Any)
                    
                    let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getChannelEpisodeListCallFinished(false, error, false)
                
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (getEpisodeList): \(error.localizedDescription)")
            getChannelEpisodeListCallFinished(false, error, false)
        }
    }
    func covertJsonToProgram(_ jsonObject: JSON, channelID: Int) -> Program {
        let episodeJsonObject = jsonObject[Program.JsonKeys.episode]
        let type = jsonObject[Program.JsonKeys.type].string!
        let isVodEpisode = type == "vod"
        let episode = Episode(id: episodeJsonObject[Episode.JsonKeys.id].int ?? -1, name: episodeJsonObject[Episode.JsonKeys.name].string ?? "", image: episodeJsonObject[Episode.JsonKeys.image].string, description_e: episodeJsonObject[Episode.JsonKeys.description_e].string, videoLink: episodeJsonObject[Episode.JsonKeys.video_link].string, previewLink: episodeJsonObject[Episode.JsonKeys.preview_link].string, subtitleLink: isVodEpisode ? self.constructSubtitleUrl(videoUrl: episodeJsonObject[Episode.JsonKeys.video_link].string!) : "", trailer_only: episodeJsonObject[Episode.JsonKeys.trailer_only].bool ?? false
        )
        
        let program = Program(id: jsonObject[Program.JsonKeys.id].int ?? -1, name: jsonObject[Program.JsonKeys.name].string ?? "", image: jsonObject[Program.JsonKeys.image].string, description_p: jsonObject[Program.JsonKeys.description_p].string, episode: episode, subscribed: jsonObject[Program.JsonKeys.subscribed].bool ?? false, type: type, channelId: channelID, liked: episodeJsonObject[Program.JsonKeys.liked].bool ?? false)
        return program
    }
}
