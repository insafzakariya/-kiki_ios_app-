//
//  BrowseModel.swift
//  SusilaMobile
//
//  Created by Kiroshan T on 12/9/19.
//  Copyright © 2019 Isuru Jayathissa. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class BrowseDataModel:NSObject {
    fileprivate let api = ApiClient()
    var genreSongsList: [Song] = [Song]()
    var allArtistsList: [Artist] = [Artist]()
    var SongsByArtistList: [Song] = [Song]()
    var genreArtistsList: [Artist] = [Artist]()
    var genrePlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    
    func getBrowseSongsByArtist(id: Int, getBrowseArtistSongsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getHomePopularArtistSongs(id: id, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.SongsByArtistList.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.SongsByArtistList.append(song)
                        
                    }
                    getBrowseArtistSongsListCallFinished(true, nil, nil)
                    
                } else {
                    getBrowseArtistSongsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getBrowseArtistSongsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getBrowseArtistSongsListCallFinished): \(error.localizedDescription)")
            getBrowseArtistSongsListCallFinished(false, error, nil)
        }
    }
    
    func getBrowseGenreArtists(id: Int, getBrowseGenreArtistsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getGenreArtists(id: id, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.genreArtistsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let artist = Artist(id: jsonObject[Artist.JsonKeys.id].int ?? -1, name: jsonObject[Artist.JsonKeys.name].string ?? "", image: jsonObject[Artist.JsonKeys.image].string ?? "", songsCount: jsonObject[Artist.JsonKeys.songsCount].int ?? 0, numberOfAlbums: jsonObject[Artist.JsonKeys.numberOfAlbums].int ?? 0)
                        
                        self.genreArtistsList.append(artist)
                        
                    }
                    getBrowseGenreArtistsListCallFinished(true, nil, nil)
                    
                } else {
                    getBrowseGenreArtistsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getBrowseGenreArtistsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getBrowseGenreArtistsListCallFinished): \(error.localizedDescription)")
            getBrowseGenreArtistsListCallFinished(false, error, nil)
        }
    }
    
    func getGenrePlaylists(id: Int, getGenrePlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getGenrePlaylists(id: id, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    var playlists = [GlobalPlaylistItem]()
                    for jsonObject in jsonList{
                        
                        let playlist = GlobalPlaylistItem(id: jsonObject[GlobalPlaylistItem.JsonKeys.id].int ?? -1, order: jsonObject[GlobalPlaylistItem.JsonKeys.order].int ?? -1, name: jsonObject[GlobalPlaylistItem.JsonKeys.name].string ?? "", date: jsonObject[GlobalPlaylistItem.JsonKeys.date].string ?? "", image: jsonObject[GlobalPlaylistItem.JsonKeys.image].string ?? "", number_of_songs: jsonObject[GlobalPlaylistItem.JsonKeys.number_of_songs].int ?? -1)
                        
                        playlists.append(playlist)
                    }
                    self.genrePlaylists = playlists
                    
                    getGenrePlaylistCallFinished(true, nil, nil)
                    
                }else{
                    getGenrePlaylistCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getGenrePlaylistCallFinished(false, error, nil)
                
            }
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getGenrePlaylistCallFinished): \(error.localizedDescription)")
            getGenrePlaylistCallFinished(false, error, nil)
        }
    }
    
    func getSongsByGenre(offset: Int, genre:String, getSongsOfGenreCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getSongsOfGenre(offset: offset, genre:genre, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.genreSongsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.genreSongsList.append(song)
                        
                    }
                    
                    getSongsOfGenreCallFinished(true, nil, nil)
                    
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
            NSLog("Error (getPopularSongsListCallFinished): \(error.localizedDescription)")
            getSongsOfGenreCallFinished(false, error, nil)
        }
    }
    
    func getBrowseAllArtists(getBrowseAllArtistsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getBrowseAllArtist(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.allArtistsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let artist = Artist(id: jsonObject[Artist.JsonKeys.id].int ?? -1, name: jsonObject[Artist.JsonKeys.name].string ?? "", image: jsonObject[Artist.JsonKeys.image].string ?? "", songsCount: jsonObject[Artist.JsonKeys.songsCount].int ?? 0, numberOfAlbums: jsonObject[Artist.JsonKeys.numberOfAlbums].int ?? 0)
                        
                        self.allArtistsList.append(artist)
                        
                    }
                    getBrowseAllArtistsListCallFinished(true, nil, nil)
                    
                } else {
                    getBrowseAllArtistsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getBrowseAllArtistsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getBrowseAllArtistsListCallFinished): \(error.localizedDescription)")
            getBrowseAllArtistsListCallFinished(false, error, nil)
        }
    }
}
