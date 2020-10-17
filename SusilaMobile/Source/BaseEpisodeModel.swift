//
//  BaseEpisodeModel.swift
//  SusilaMobile
//
//  Created by Meuru Muthuthanthri on 5/6/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import SwiftyJSON
import ImageSlideshow
import SWXMLHash

class BaseEpisodeModel: NSObject {
    
    fileprivate let api = ApiClient()
    
    var episodeList: [Episode] = [Episode]()
    var episodeListNotify: [Episode] = []
    
    func getEpisodeList(programID: Int, offset: Int, programType: String, getEpisodeListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getEpisodeList(programID: programID, offset: offset, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                if let jsonList = jsonArray {
                    if jsonList.isEmpty {
                        getEpisodeListCallFinished(false, nil, nil)
                    } else {
                        self.episodeList.removeAll()
                        for jsonObject in jsonList{
                            
                            let episode = Episode(id: jsonObject[Episode.JsonKeys.id].int ?? -1, name: jsonObject[Episode.JsonKeys.name].string ?? "", image: jsonObject[Episode.JsonKeys.image].string, description_e: jsonObject[Episode.JsonKeys.description_e].string, videoLink: jsonObject[Episode.JsonKeys.video_link].string, previewLink: jsonObject[Episode.JsonKeys.preview_link].string,
                                                  subtitleLink: programType == "vod" ? self.constructSubtitleUrl(videoUrl: jsonObject[Episode.JsonKeys.video_link].string!) : "", trailer_only: jsonObject[Episode.JsonKeys.trailer_only].bool ?? false
                            )
                            
                            self.episodeList.append(episode)
                        }
                        getEpisodeListCallFinished(true, nil, nil)
                    }
                } else {
                    getEpisodeListCallFinished(false, nil, nil)
                }
                
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getEpisodeListCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (getEpisodeList): \(error.localizedDescription)")
            getEpisodeListCallFinished(false, error, nil)
        }
    }
    
    func getEpisodeListNotify(programID: Int, offset: Int, programType: String, getEpisodeListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getEpisodeList(programID: programID, offset: offset, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                if let jsonList = jsonArray {
                    if jsonList.isEmpty {
                        getEpisodeListCallFinished(false, nil, nil)
                    } else {
                        self.episodeListNotify.removeAll()
                        for jsonObject in jsonList{
                            
                            let episode = Episode(id: jsonObject[Episode.JsonKeys.id].int ?? -1, name: jsonObject[Episode.JsonKeys.name].string ?? "", image: jsonObject[Episode.JsonKeys.image].string, description_e: jsonObject[Episode.JsonKeys.description_e].string, videoLink: jsonObject[Episode.JsonKeys.video_link].string, previewLink: jsonObject[Episode.JsonKeys.preview_link].string,
                                                  subtitleLink: programType == "vod" ? self.constructSubtitleUrl(videoUrl: jsonObject[Episode.JsonKeys.video_link].string!) : "", trailer_only: jsonObject[Episode.JsonKeys.trailer_only].bool ?? false
                            )
                            
                            self.episodeListNotify.append(episode)
                        }
                        getEpisodeListCallFinished(true, nil, nil)
                    }
                } else {
                    getEpisodeListCallFinished(false, nil, nil)
                }
                
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getEpisodeListCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (getEpisodeList): \(error.localizedDescription)")
            getEpisodeListCallFinished(false, error, nil)
        }
    }
    
    func constructSubtitleUrl(videoUrl: String) -> String {
        let vidoeStrUrl = videoUrl.removingPercentEncoding ?? ""
        do {
            let regex = try NSRegularExpression(pattern: "(.*)(smil:)([\\d]+)(.smil)(.*)(\\?token=.*)")
            let results = regex.matches(in: vidoeStrUrl,
                                        range: NSRange(location: 0, length: vidoeStrUrl.count))
            let match = results.first
            let urlPrefix  = String(vidoeStrUrl[Range((match?.range(at: 1))!, in:vidoeStrUrl)!])
            let smil = String(vidoeStrUrl[Range((match?.range(at: 3))!, in:vidoeStrUrl)!])
            let urlSuffix = String(vidoeStrUrl[Range((match?.range(at: 6))!, in:vidoeStrUrl)!])
            
            let finalUrl = "\(urlPrefix)\(smil).ttml\(urlSuffix)"
            return finalUrl
        } catch (let e) {
            Log(e.localizedDescription)
            return ""
        }
    }
    
    func fetchSubtitle(url: String,fetchSubtitleCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ xml: String?) -> Void) {
        print(url)
        if url.isEmpty { return }
        api.getSubtitle(urlStr: url, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                fetchSubtitleCallFinished(true, nil, data)
            default:
                fetchSubtitleCallFinished(false, ErrorHandler.UnKnownForRequest, nil)
            }
        }) { (error) -> Void in
            fetchSubtitleCallFinished(false, error, nil)
        }
    }
    
    func fetchAdvertisement(programId: Int, fetchAdvertisementeCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ data: [AdvertisementModel]?) -> Void) {
        api.getAdvertisement(programId: programId, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                if let jsonList = jsonArray {
                    if jsonList.isEmpty {
                        fetchAdvertisementeCallFinished(false, nil, nil)
                    } else {
                        var advertisementList: [AdvertisementModel] = []
                        for jsonObject in jsonList {
                            let advertisement = AdvertisementModel(videoUrl: jsonObject[AdvertisementModel.JsonKeys.videoUrl].string, webUrl: jsonObject[AdvertisementModel.JsonKeys.webUrl].string!, stopMainContent: jsonObject[AdvertisementModel.JsonKeys.stopMainContent].bool!, clickAction: jsonObject[AdvertisementModel.JsonKeys.clickAction].bool!, imageURL: jsonObject[AdvertisementModel.JsonKeys.imageURL].string!, title: jsonObject[AdvertisementModel.JsonKeys.title].string!, duration: jsonObject[AdvertisementModel.JsonKeys.duration].int!, startTime: jsonObject[AdvertisementModel.JsonKeys.startTime].int!, position: jsonObject[AdvertisementModel.JsonKeys.position].string!, id: jsonObject[AdvertisementModel.JsonKeys.id].int)
                            advertisementList.append(advertisement)
                        }
                        fetchAdvertisementeCallFinished(true, nil, advertisementList)
                    }
                } else {
                    fetchAdvertisementeCallFinished(false, nil, nil)
                }
                
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                fetchAdvertisementeCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            Common.logout()
            NSLog("Error (getEpisodeList): \(error.localizedDescription)")
            fetchAdvertisementeCallFinished(false, error, nil)
        }
    }
    
}
