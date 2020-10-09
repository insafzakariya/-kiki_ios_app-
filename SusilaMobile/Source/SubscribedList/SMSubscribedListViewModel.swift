//
//  SMHotListViewModel.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 9/30/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import SwiftyJSON

class SMSubscribedListViewModel: BaseEpisodeModel {
    
    fileprivate let api = ApiClient()
    var programList: [Program] = [Program]()
    
    func getSubscribedListWithoutChannelID(getSubscribedListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getSubscribedListWithouthChannelID(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
            
                if let jsonList = jsonArray{
                    
                    self.programList.removeAll()
                    for jsonObject in jsonList{
                        
                        let episodeJsonObject = jsonObject[Program.JsonKeys.episode]
                        let episode = Episode(id: episodeJsonObject[Episode.JsonKeys.id].int ?? -1, name: episodeJsonObject[Episode.JsonKeys.name].string ?? "", image: episodeJsonObject[Episode.JsonKeys.image].string, description_e: episodeJsonObject[Episode.JsonKeys.description_e].string, videoLink: episodeJsonObject[Episode.JsonKeys.video_link].string, previewLink: episodeJsonObject[Episode.JsonKeys.preview_link].string, subtitleLink:
                            nil, trailer_only: episodeJsonObject[Episode.JsonKeys.trailer_only].bool ?? false
                        )
                        
                        //used hardcoded channel ID
                        
                        let program = Program(id: jsonObject[Program.JsonKeys.id].int ?? -1, name: jsonObject[Program.JsonKeys.name].string ?? "", image: jsonObject[Program.JsonKeys.image].string, description_p: jsonObject[Program.JsonKeys.description_p].string, episode: episode, subscribed: jsonObject[Program.JsonKeys.subscribed].bool ?? false, type: jsonObject[Program.JsonKeys.type].string ?? "", channelId: 0, liked: episodeJsonObject[Program.JsonKeys.liked].bool ?? false)
                        
                        
                        self.programList.append(program)
                        
                    }
                    
                    getSubscribedListCallFinished(true, nil, nil)
                    
                }else{
                    getSubscribedListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getSubscribedListCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (getSubscribedList): \(error.localizedDescription)")
            getSubscribedListCallFinished(false, error, nil)
        }
    }
}
