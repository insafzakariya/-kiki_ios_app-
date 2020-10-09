//
//  PlaylistModel.swift
//  SusilaMobile
//
//  Created by MacBookSH on 12/6/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class PlaylistModel:NSObject{
    fileprivate let api = ApiClient()
    var globalPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var playlists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var sections: [Section] = [Section]()
    var playlistSongs: [Song] = [Song]()
    
    func getPlaylists(getGlobalPlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getPlaylists(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                print("Worked42 ", data as Any)
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    var playlists = [GlobalPlaylistItem]()
                    for jsonObject in jsonList{
                        
                        let playlist = GlobalPlaylistItem(id: jsonObject[GlobalPlaylistItem.JsonKeys.id].int ?? -1, order: jsonObject[GlobalPlaylistItem.JsonKeys.order].int ?? -1, name: jsonObject[GlobalPlaylistItem.JsonKeys.name].string ?? "", date: jsonObject[GlobalPlaylistItem.JsonKeys.date].string ?? "", image: jsonObject[GlobalPlaylistItem.JsonKeys.image].string ?? "", number_of_songs: jsonObject[GlobalPlaylistItem.JsonKeys.number_of_songs].int ?? -1)
                        
                        playlists.append(playlist)
                    }
                        self.playlists = playlists
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
    
    func loadAllPlaylistData() {
        self.sections.removeAll()
        self.playlists.forEach{ playlist in
            self.getSongsOfPlaylist(listID: playlist.id, getSongsOfPlaylistCallFinished: { (status, error, songs) in
                if (status) {
                    self.sections.append(Section(name: playlist.name, collapsed: true, sectionID: playlist.id, songs: songs ?? []))
                }
            })
        }
    }
    
    func getSongsOfPlaylist(listID: Int, getSongsOfPlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ songs: [Song]?) -> Void) {
        api.getSongsOfPlaylist(listID: listID, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    self.playlistSongs.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.playlistSongs.append(song)
                    }
                    getSongsOfPlaylistCallFinished(true, nil, self.playlistSongs)
                    
                }else{
                    getSongsOfPlaylistCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getSongsOfPlaylistCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getSongsOfPlaylistCallFinished): \(error.localizedDescription)")
            getSongsOfPlaylistCallFinished(false, error, nil)
        }
    }
    
    func getSongsOfPlaylistGlobal(listID: Int, getSongsOfPlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ songs: [Song]?) -> Void) {
        api.getSongsOfPlaylistGlobal(listID: listID, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    self.playlistSongs.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.playlistSongs.append(song)
                    }
                    getSongsOfPlaylistCallFinished(true, nil, self.playlistSongs)
                    
                }else{
                    getSongsOfPlaylistCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getSongsOfPlaylistCallFinished(false, error, nil)
                
            }
            
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getSongsOfPlaylistCallFinished): \(error.localizedDescription)")
            getSongsOfPlaylistCallFinished(false, error, nil)
        }
    }
    
    func createPlaylist( playlistName: String, createPlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ playlist: GlobalPlaylistItem?) -> Void) {
        api.createPlaylist(playlistName: playlistName, imageUrl: "String", success: { (data, code) -> Void in
            
            switch code {
            case 201:
                
                if let jsonObject = JSON(data as Any).dictionary {
                    let playlist = GlobalPlaylistItem(id: jsonObject[GlobalPlaylistItem.JsonKeys.id]?.int ?? 0, order: jsonObject[GlobalPlaylistItem.JsonKeys.order]?.int ?? 0, name: jsonObject[GlobalPlaylistItem.JsonKeys.name]?.string ?? "", date: jsonObject[GlobalPlaylistItem.JsonKeys.date]?.string ?? "", image: jsonObject[GlobalPlaylistItem.JsonKeys.image]?.string ?? "", number_of_songs: jsonObject[GlobalPlaylistItem.JsonKeys.number_of_songs]?.int ?? 0)
                    self.sections.append(Section(name: playlist.name, collapsed: true, sectionID: playlist.id, songs: []))
                    createPlaylistCallFinished(true, nil, playlist)
                } else {
                    createPlaylistCallFinished(false, nil, nil)
                }
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                createPlaylistCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (createPlaylistCallFinished): \(error.localizedDescription)")
            createPlaylistCallFinished(false, error, nil)
        }
    }
    
    func addToPlayList( playlistId:Int, songId:Int, addToPlayListCallFinished: @escaping (_ status: Bool) -> Void) {
        /*api.addToPlaylist(playlistId: playlistId, songId: songId, success: { (code) -> Void in
            
            switch code {
            case 201:
                addToPlayListCallFinished(true)
            default:
                addToPlayListCallFinished(false)
            }
        }) { (error) -> Void in
            addToPlayListCallFinished(false)
        }*/
    }
    
    

}
