//
//  HomeDataModel.swift
//  SusilaMobile
//
//  Created by MacBookSH on 12/6/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class HomeDataModel:NSObject{
    fileprivate let api = ApiClient()
    var playerView: PlayerView?
    var popularSongsList: [Song] = [Song]()
    var latestSongsList: [Song] = [Song]()
    var radioChannelsList: [Song] = [Song]()
    var popularArtistsList: [Artist] = [Artist]()
    var popularArtistSongsList: [Song] = [Song]()
    var latestPlaylistSongsList: [Song] = [Song]()
    var songByIdList: [Song] = [Song]()
    var suggessionSongList: [Song] = [Song]()
    var artistByIdList: [ArtistById] = [ArtistById]()
    var playlistByIdList: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    
    var userPlaylists: [Message] = [Message]()
    var globalPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    
    func updateAction(content_Id:Int, screen_Id:Int, screen_Action_Id:Int, screen_Time:String, updateActionCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.updateAction(content_Id:content_Id, screen_Id:screen_Id, screen_Action_Id:screen_Action_Id, screen_Time:screen_Time, success: { (data, code) -> Void in
            switch code {
            case 200:
                updateActionCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                updateActionCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            NSLog("Error (updateActionCallFinished): \(error.localizedDescription)")
            updateActionCallFinished(false, error, nil)
        }
    }
    
    func getPopularSongs(getPopularSongsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getYouMightLike(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.popularSongsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.popularSongsList.append(song)
                        
                    }
                    
                    getPopularSongsListCallFinished(true, nil, nil)
                    
                }else{
                    getPopularSongsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getPopularSongsListCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getPopularSongsListCallFinished): \(error.localizedDescription)")
            getPopularSongsListCallFinished(false, error, nil)
        }
    }
    
    func getSongById(sid: String, getSongByIdCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getSongById(sid: sid, success: { (data, code) -> Void in
            switch code {
            case 200:
                self.songByIdList.removeAll()
                let jsonObject = JSON(data as Any)
                let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                self.songByIdList.append(song)
                getSongByIdCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getSongByIdCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            NSLog("Error (getSongByIdCallFinished): \(error.localizedDescription)")
            getSongByIdCallFinished(false, error, nil)
        }
    }
    
    func getArtistById(aid: String, getArtistByIdCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getArtistById(aid: aid, success: { (data, code) -> Void in
            switch code {
            case 200:
                self.artistByIdList.removeAll()
                let jsonObject = JSON(data as Any)
                
                let artist = ArtistById(id: jsonObject[ArtistById.JsonKeys.id].int ?? -1, name: jsonObject[ArtistById.JsonKeys.name].string ?? "", image: jsonObject[ArtistById.JsonKeys.image].string ?? "", songsCount: jsonObject[ArtistById.JsonKeys.songsCount].string ?? "", numberOfAlbums: jsonObject[ArtistById.JsonKeys.numberOfAlbums].string ?? "")
                
                self.artistByIdList.append(artist)
                getArtistByIdCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getArtistByIdCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            NSLog("Error (getArtistByIdCallFinished): \(error.localizedDescription)")
            getArtistByIdCallFinished(false, error, nil)
        }
    }
    
    func getPlaylistById(pid: String, getPlaylistByIdCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getPlaylistById(pid: pid, success: { (data, code) -> Void in
            switch code {
            case 200:
                self.playlistByIdList.removeAll()
                let jsonObject = JSON(data as Any)
                
               let playlist = GlobalPlaylistItem(id: jsonObject[GlobalPlaylistItem.JsonKeys.id].int ?? -1, order: jsonObject[GlobalPlaylistItem.JsonKeys.order].int ?? -1, name: jsonObject[GlobalPlaylistItem.JsonKeys.name].string ?? "", date: jsonObject[GlobalPlaylistItem.JsonKeys.date].string ?? "", image: jsonObject[GlobalPlaylistItem.JsonKeys.image].string ?? "", number_of_songs: jsonObject[GlobalPlaylistItem.JsonKeys.number_of_songs].int ?? -1)
                
                self.playlistByIdList.append(playlist)
                getPlaylistByIdCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getPlaylistByIdCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            NSLog("Error (getPlaylistByIdCallFinished): \(error.localizedDescription)")
            getPlaylistByIdCallFinished(false, error, nil)
        }
    }
    
    func getHomePopularSongs(getHomePopularSongsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getHomePopularSongs(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.popularSongsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.popularSongsList.append(song)
                        
                    }
                    getHomePopularSongsListCallFinished(true, nil, nil)
                    
                } else {
                    getHomePopularSongsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getHomePopularSongsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getPopularSongsListCallFinished): \(error.localizedDescription)")
            getHomePopularSongsListCallFinished(false, error, nil)
        }
    }
    
    func getHomeLatestSongs(getHomeLatestSongsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getHomeLatestSongs(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.latestSongsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.latestSongsList.append(song)
                        
                    }
                    getHomeLatestSongsListCallFinished(true, nil, nil)
                    
                } else {
                    getHomeLatestSongsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getHomeLatestSongsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getPopularSongsListCallFinished): \(error.localizedDescription)")
            getHomeLatestSongsListCallFinished(false, error, nil)
        }
    }
    
    func getRadioChannels(getRadioChannelsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getRadioChannels(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.radioChannelsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[1].int ?? 0, date: jsonObject[""].string ?? "", description: jsonObject[""].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject["false"].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        //print("radio ", Song.JsonKeys.url)
                        self.radioChannelsList.append(song)
                        print("radio ", self.radioChannelsList)
                    }
                    getRadioChannelsListCallFinished(true, nil, nil)
                    
                } else {
                    getRadioChannelsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getRadioChannelsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getPopularSongsListCallFinished): \(error.localizedDescription)")
            getRadioChannelsListCallFinished(false, error, nil)
        }
    }
    
    func getHomePopularArtists(getHomePopularArtistsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getHomePopularArtist(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.popularArtistsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let artist = Artist(id: jsonObject[Artist.JsonKeys.id].int ?? -1, name: jsonObject[Artist.JsonKeys.name].string ?? "", image: jsonObject[Artist.JsonKeys.image].string ?? "", songsCount: jsonObject[Artist.JsonKeys.songsCount].int ?? 0, numberOfAlbums: jsonObject[Artist.JsonKeys.numberOfAlbums].int ?? 0)
                        
                        self.popularArtistsList.append(artist)
                        
                    }
                    getHomePopularArtistsListCallFinished(true, nil, nil)
                    
                } else {
                    getHomePopularArtistsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getHomePopularArtistsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getPopularSongsListCallFinished): \(error.localizedDescription)")
            getHomePopularArtistsListCallFinished(false, error, nil)
        }
    }
    
    func getHomePopularArtistSongs(id: Int, getHomePopularArtistSongsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getHomePopularArtistSongs(id: id, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.popularArtistSongsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.popularArtistSongsList.append(song)
                        
                    }
                    getHomePopularArtistSongsListCallFinished(true, nil, nil)
                    
                } else {
                    getHomePopularArtistSongsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getHomePopularArtistSongsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getHomePopularArtistSongsListCallFinished): \(error.localizedDescription)")
            getHomePopularArtistSongsListCallFinished(false, error, nil)
        }
    }
    
    func getLatestPlaylistSongs(id: String, getHomeLatestPlaylistSongsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getLatestPlaylistSongs(id: id, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.latestPlaylistSongsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.latestPlaylistSongsList.append(song)
                        
                    }
                    getHomeLatestPlaylistSongsListCallFinished(true, nil, nil)
                    
                } else {
                    getHomeLatestPlaylistSongsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getHomeLatestPlaylistSongsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getPopularSongsListCallFinished): \(error.localizedDescription)")
            getHomeLatestPlaylistSongsListCallFinished(false, error, nil)
        }
    }
    
    
    /*func getPlaylists( getPlaylistsCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getGlobalPlayLists(success: { (data, code) -> Void in
            NSLog("Worked43 : \(String(describing: data))")
            NSLog("Worked43C : \(String(describing: code))")
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                NSLog("getPlaylists : \(String(describing: jsonArray))")
                
                if let jsonList = jsonArray {
                    getPlaylistsCallFinished(true, nil, nil)
                    var playlists = [GlobalPlaylistItem]()
                    for jsonObject in jsonList{
                        
                        let playlist = GlobalPlaylistItem(id: jsonObject[GlobalPlaylistItem.JsonKeys.id].int ?? -1, order: jsonObject[GlobalPlaylistItem.JsonKeys.order].int ?? -1, name: jsonObject[GlobalPlaylistItem.JsonKeys.name].string ?? "", date: jsonObject[GlobalPlaylistItem.JsonKeys.date].string ?? "", image: jsonObject[GlobalPlaylistItem.JsonKeys.image].string ?? "", number_of_songs: jsonObject[GlobalPlaylistItem.JsonKeys.number_of_songs].int ?? -1)
                        
                        playlists.append(playlist)
                    }
                } else{
                    getPlaylistsCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getPlaylistsCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getUserPlaylistsCallFinished): \(error.localizedDescription)")
            getPlaylistsCallFinished(false, error, nil)
        }
    }*/
    
    func getPlaylists(getGlobalPlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getGlobalPlayLists(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    var playlists = [GlobalPlaylistItem]()
                    for jsonObject in jsonList{
                        
                        let playlist = GlobalPlaylistItem(id: jsonObject[GlobalPlaylistItem.JsonKeys.id].int ?? -1, order: jsonObject[GlobalPlaylistItem.JsonKeys.order].int ?? -1, name: jsonObject[GlobalPlaylistItem.JsonKeys.name].string ?? "", date: jsonObject[GlobalPlaylistItem.JsonKeys.date].string ?? "", image: jsonObject[GlobalPlaylistItem.JsonKeys.image].string ?? "", number_of_songs: jsonObject[GlobalPlaylistItem.JsonKeys.number_of_songs].int ?? -1)
                        
                        playlists.append(playlist)
                    }
                    self.globalPlaylists = playlists
                    
                    getGlobalPlaylistCallFinished(true, nil, nil)
                    
                }else{
                    getGlobalPlaylistCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getGlobalPlaylistCallFinished(false, error, nil)
                
            }
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getGlobalPlaylistCallFinished): \(error.localizedDescription)")
            getGlobalPlaylistCallFinished(false, error, nil)
        }
    }
    
    func addToLibrary(key: String, songs: Int, addToLibraryCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        
        api.addToLibrary(key: key, songs: songs, success: { (data, code) -> Void in
            switch code {
            case 200:
                addToLibraryCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                addToLibraryCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (addToLibraryCallFinished): \(error.localizedDescription)")
            addToLibraryCallFinished(false, error, nil)
        }
    }
    
    func getSuggessionSongs(songID: Int, getSuggessionSongsCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getSuggessionSongs(songID: songID, success: { (data, code) -> Void in
            
            if code == 200 {
                let jsonArray = JSON(data as Any).array
                self.suggessionSongList.removeAll()
                if let jsonList = jsonArray{
            
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.suggessionSongList.append(song)
                    }
                    getSuggessionSongsCallFinished(true, nil, nil)
                    
                } else {
                    getSuggessionSongsCallFinished(false, nil, nil)
                }
            } else {
                getSuggessionSongsCallFinished(false, nil, nil)
            }

        }) { (error) -> Void in
            NSLog("Error (getSuggessionSongsCallFinished): \(error.localizedDescription)")
            getSuggessionSongsCallFinished(false, error, nil)
        }
    }
}
