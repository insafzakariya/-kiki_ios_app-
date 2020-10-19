//
//  AllSongsModel.swift
//  SusilaMobile
//
//  Created by MacBookSH on 12/6/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import UIKit
import SwiftyJSON

class AllSongsModel:NSObject{
    fileprivate let api = ApiClient()
    var allSongsList: [Song] = [Song]()
    var allGenreList: [SongGenre] = [SongGenre]()
    var recentSongs: [Song] = [Song]()
    var songsListBySelectedGenre:[Song] = [Song]()
    var songsByGenre: [String: [Song]] = [:]

    func getSongsOfGenre( genre:String, getSongsOfGenreCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ songs: [Song]?) -> Void) {
        if (songsByGenre[genre] != nil) {
            songsListBySelectedGenre = songsByGenre[genre] ?? [Song]()
            getSongsOfGenreCallFinished(true, nil, songsByGenre[genre])
            return
        }
        api.getSongsOfGenre(offset: 0, genre:genre, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.songsListBySelectedGenre.removeAll()
                    for jsonObject in jsonList{
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.songsListBySelectedGenre.append(song)
                        
                    }
                    self.songsByGenre[genre] = self.songsListBySelectedGenre
                    getSongsOfGenreCallFinished(true, nil, self.songsListBySelectedGenre)
                    
                }else{
                    getSongsOfGenreCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getSongsOfGenreCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getSongsOfGenreCallFinished): \(error.localizedDescription)")
            getSongsOfGenreCallFinished(false, error, nil)
        }
    }
    
    func getRecentSongs( getRecentSongsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getRecentSongs(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                NSLog("getRecentSongsListCallFinished : \(String(describing: jsonArray))")
                
                if let jsonList = jsonArray{
                    
                    self.recentSongs.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.recentSongs.append(song)
                        
                    }
                    
                    getRecentSongsListCallFinished(true, nil, nil)
                    
                }else{
                    getRecentSongsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getRecentSongsListCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getRecentSongsListCallFinished): \(error.localizedDescription)")
            getRecentSongsListCallFinished(false, error, nil)
        }
    }
    
    func getAllSongsGenreList( getAllSongsGenreListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getAllSongsGenreList(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                
                if let jsonList = jsonArray{
                    
                    self.allGenreList.removeAll()
                                        for jsonObject in jsonList{
                    
                                            let songGenre = SongGenre(genreId: jsonObject[SongGenre.JsonKeys.genreId].int ?? -1, genreImage: jsonObject[SongGenre.JsonKeys.genreImage].string ?? "", genreDescription: jsonObject[SongGenre.JsonKeys.genreDescription].string ?? "", genreName: jsonObject[SongGenre.JsonKeys.genreName].string ?? "", genreColor: jsonObject[SongGenre.JsonKeys.genreColor].string ?? "")
                    
                                            self.allGenreList.append(songGenre)
                    
                                        }
                    NSLog("getAllSongsGenreList : \(String(describing: self.allGenreList))")
                    getAllSongsGenreListCallFinished(true, nil, nil)
                    
                }else{
                    getAllSongsGenreListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getAllSongsGenreListCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getAllSongsGenreListCallFinished): \(error.localizedDescription)")
            getAllSongsGenreListCallFinished(false, error, nil)
        }
    }
    
    
    func getAllSongsList(offset:Int, getAllSongsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getAllSongsList(offset:offset, success: { (data, code) -> Void in
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        self.allSongsList.append(song)
                        
                    }
                    
                    getAllSongsListCallFinished(true, nil, nil)
                    
                }else{
                    getAllSongsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getAllSongsListCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getAllSongsListCallFinished): \(error.localizedDescription)")
            getAllSongsListCallFinished(false, error, nil)
        }
    }
}
