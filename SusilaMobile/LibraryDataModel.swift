//
//  LibraryDataModel.swift
//  SusilaMobile
//
//  Created by Kiroshan on 1/31/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class LibraryDataModel:NSObject {
    fileprivate let api = ApiClient()
    var librarySongsList: [Song] = [Song]()
    var libraryArtistsList: [Artist] = [Artist]()
    var playlists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var kikiPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var allPlaylist: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var allSongs: [Song] = [Song]()
    var allArtists: [Artist] = [Artist]()
    var playlistSongs: [Song] = [Song]()
    var selectPlaylistSongsList: [Song] = [Song]()
    var selectArtistSongsList: [Song] = [Song]()
    var playlistStatus: [PlaylistStatus] = [PlaylistStatus]()
    var tempPlaylistSongs: [Song] = [Song]()
    var returnPlaylistData: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    
    func getLibrarySongs(getLibrarySongsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getLibrarySongs(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.librarySongsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.librarySongsList.append(song)
                        
                    }
                    getLibrarySongsListCallFinished(true, nil, nil)
                    
                } else {
                    getLibrarySongsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getLibrarySongsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getLibrarySongsListCallFinished): \(error.localizedDescription)")
            getLibrarySongsListCallFinished(false, error, nil)
        }
    }
    
    func getLibraryArtists(getLibraryArtistsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getLibraryArtists(success: { (data, code) -> Void in
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                if let jsonList = jsonArray {
                    self.libraryArtistsList.removeAll()
                    for jsonObject in jsonList {
                        let artist = Artist(id: jsonObject[Artist.JsonKeys.id].int ?? -1, name: jsonObject[Artist.JsonKeys.name].string ?? "", image: jsonObject[Artist.JsonKeys.image].string ?? "", songsCount: jsonObject[Artist.JsonKeys.songsCount].int ?? 0, numberOfAlbums: jsonObject[Artist.JsonKeys.numberOfAlbums].int ?? 0)
                        self.libraryArtistsList.append(artist)
                    }
                    getLibraryArtistsListCallFinished(true, nil, nil)
                    
                } else {
                    getLibraryArtistsListCallFinished(false, nil, nil)
                }
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getLibraryArtistsListCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            NSLog("Error (getLibraryArtistsListCallFinished): \(error.localizedDescription)")
            getLibraryArtistsListCallFinished(false, error, nil)
        }
    }
    
    func getPlaylists(getPlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getPlaylists(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    var playlists = [GlobalPlaylistItem]()
                    for jsonObject in jsonList{
                        
                        let playlist = GlobalPlaylistItem(id: jsonObject[GlobalPlaylistItem.JsonKeys.id].int ?? -1, order: jsonObject[GlobalPlaylistItem.JsonKeys.order].int ?? -1, name: jsonObject[GlobalPlaylistItem.JsonKeys.name].string ?? "", date: jsonObject[GlobalPlaylistItem.JsonKeys.date].string ?? "", image: jsonObject[GlobalPlaylistItem.JsonKeys.image].string ?? "", number_of_songs: jsonObject[GlobalPlaylistItem.JsonKeys.number_of_songs].int ?? -1)
                        
                        playlists.append(playlist)
                    }
                        self.playlists = playlists
                    getPlaylistCallFinished(true, nil, nil)
                    
                }else{
                    getPlaylistCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getPlaylistCallFinished(false, error, nil)
                
            }
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getPlaylistCallFinished): \(error.localizedDescription)")
            getPlaylistCallFinished(false, error, nil)
        }
    }
    
    func getKiKiPlaylists(getPlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getKiKiPlaylists(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    var playlists = [GlobalPlaylistItem]()
                    for jsonObject in jsonList{
                        
                        let playlist = GlobalPlaylistItem(id: jsonObject[GlobalPlaylistItem.JsonKeys.id].int ?? -1, order: jsonObject[GlobalPlaylistItem.JsonKeys.order].int ?? -1, name: jsonObject[GlobalPlaylistItem.JsonKeys.name].string ?? "", date: jsonObject[GlobalPlaylistItem.JsonKeys.date].string ?? "", image: jsonObject[GlobalPlaylistItem.JsonKeys.image].string ?? "", number_of_songs: jsonObject[GlobalPlaylistItem.JsonKeys.number_of_songs].int ?? -1)
                        
                        playlists.append(playlist)
                    }
                        self.kikiPlaylists = playlists
                    getPlaylistCallFinished(true, nil, nil)
                    
                }else{
                    getPlaylistCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getPlaylistCallFinished(false, error, nil)
                
            }
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getPlaylistCallFinished): \(error.localizedDescription)")
            getPlaylistCallFinished(false, error, nil)
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
                    getSongsOfPlaylistCallFinished(true, nil, nil)
                    
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
    
    func getAllPlaylist(getAllPlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getAllPlaylist(success: { (data, code) -> Void in
            
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
                        self.allPlaylist = playlists
                    getAllPlaylistCallFinished(true, nil, nil)
                    
                }else{
                    getAllPlaylistCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getAllPlaylistCallFinished(false, error, nil)
                
            }
            
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getAllPlaylistCallFinished): \(error.localizedDescription)")
            getAllPlaylistCallFinished(false, error, nil)
        }
    }
    
    func getAllSongs(offset:Int, getAllSongsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getAllSongsList(offset:offset, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        self.allSongs.append(song)
                    }
                    getAllSongsListCallFinished(true, nil, nil)
                    
                } else {
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
    
    func getAllArtists(getAllArtistsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getBrowseAllArtist(success: { (data, code) -> Void in
            
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                if let jsonList = jsonArray{
                    
                    self.allArtists.removeAll()
                    for jsonObject in jsonList {
                        let artist = Artist(id: jsonObject[Artist.JsonKeys.id].int ?? -1, name: jsonObject[Artist.JsonKeys.name].string ?? "", image: jsonObject[Artist.JsonKeys.image].string ?? "", songsCount: jsonObject[Artist.JsonKeys.songsCount].int ?? 0, numberOfAlbums: jsonObject[Artist.JsonKeys.numberOfAlbums].int ?? 0)
                        self.allArtists.append(artist)
                    }
                    getAllArtistsListCallFinished(true, nil, nil)
                } else {
                    getAllArtistsListCallFinished(false, nil, nil)
                }
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getAllArtistsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getAllArtistsListCallFinished): \(error.localizedDescription)")
            getAllArtistsListCallFinished(false, error, nil)
        }
    }
    
    func getSelectPlaylistSongs(id: String, getSelectPlaylistSongsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getLatestPlaylistSongs(id: id, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.selectPlaylistSongsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.selectPlaylistSongsList.append(song)
                        
                    }
                    getSelectPlaylistSongsListCallFinished(true, nil, nil)
                    
                } else {
                    getSelectPlaylistSongsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getSelectPlaylistSongsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getSelectPlaylistSongsListCallFinished): \(error.localizedDescription)")
            getSelectPlaylistSongsListCallFinished(false, error, nil)
        }
    }
    
    func getSelectArtistSongs(id: Int, getSelectArtistSongsListCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getHomePopularArtistSongs(id: id, success: { (data, code) -> Void in
            
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray{
                    
                    self.selectArtistSongsList.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.selectArtistSongsList.append(song)
                        
                    }
                    getSelectArtistSongsListCallFinished(true, nil, nil)
                    
                } else {
                    getSelectArtistSongsListCallFinished(false, nil, nil)
                }
                
                
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getSelectArtistSongsListCallFinished(false, error, nil)
            }
            
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (getSelectArtistSongsListCallFinished): \(error.localizedDescription)")
            getSelectArtistSongsListCallFinished(false, error, nil)
        }
    }
    
    func playlistLoadTempTable(session_id: String, pid: Int, playlistLoadTempTableCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.playlistLoadTempTable(session_id: session_id, pid: pid, success: { (data, code) -> Void in
            switch code {
            case 201:
                playlistLoadTempTableCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                playlistLoadTempTableCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (playlistLoadTempTableCallFinished): \(error.localizedDescription)")
            playlistLoadTempTableCallFinished(false, error, nil)
        }
    }
    
    func updatePlaylist(name: String, pid: Int, songs: [Int], image: String, updatePlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.updatePlaylist(name: name, pid: pid, songs: songs, image: image, success: { (data, code) -> Void in
            switch code {
            case 200:
                updatePlaylistCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                updatePlaylistCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            NSLog("Error (updatePlaylistCallFinished): \(error.localizedDescription)")
            updatePlaylistCallFinished(false, error, nil)
        }
    }
    
    func getPlaylistData(pid: Int, getPlaylistDataCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getPlaylistData(pid: pid, success: { (data, code) -> Void in
            switch code {
            case 200:
                if let jsonObject = JSON(data as Any).dictionary {
                    self.returnPlaylistData.removeAll()
                    let playlist = GlobalPlaylistItem(id: jsonObject[GlobalPlaylistItem.JsonKeys.id]?.int ?? 0, order: jsonObject[GlobalPlaylistItem.JsonKeys.order]?.int ?? 0, name: jsonObject[GlobalPlaylistItem.JsonKeys.name]?.string ?? "", date: jsonObject[GlobalPlaylistItem.JsonKeys.date]?.string ?? "", image: jsonObject[GlobalPlaylistItem.JsonKeys.image]?.string ?? "", number_of_songs: jsonObject[GlobalPlaylistItem.JsonKeys.number_of_songs]?.int ?? 0)
                    self.returnPlaylistData.append(playlist)
                    getPlaylistDataCallFinished(true, nil, nil)
                } else {
                    getPlaylistDataCallFinished(false, nil, nil)
                }
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getPlaylistDataCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            NSLog("Error (getPlaylistDataCallFinished): \(error.localizedDescription)")
            getPlaylistDataCallFinished(false, error, nil)
        }
    }
    
    func addToTempPlaylistSongs(session_id: String, ref_id: Int, type: String, addToTempPlaylistSongsCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.addToTempPlaylist(session_id: session_id, ref_id: ref_id, type: type, success: { (data, code) -> Void in
            switch code {
            case 201:
                addToTempPlaylistSongsCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                addToTempPlaylistSongsCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            //Common.logout()
            NSLog("Error (addToTempPlaylistSongsCallFinished): \(error.localizedDescription)")
            addToTempPlaylistSongsCallFinished(false, error, nil)
        }
    }
    
    func getTempPlaylist(session_id: String, getTempPlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.getTempPlaylist(session_id: session_id, success: { (data, code) -> Void in
            switch code {
            case 200:
                
                let jsonArray = JSON(data as Any).array
                
                if let jsonList = jsonArray {
                    self.tempPlaylistSongs.removeAll()
                    for jsonObject in jsonList{
                        
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                        
                        self.tempPlaylistSongs.append(song)
                    }
                    getTempPlaylistCallFinished(true, nil, nil)
                    
                } else{
                    getTempPlaylistCallFinished(false, nil, nil)
                }
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getTempPlaylistCallFinished(false, error, nil)
                
            }
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (getTempPlaylistCallFinished): \(error.localizedDescription)")
            getTempPlaylistCallFinished(false, error, nil)
        }
    }
    
    func createPlaylist(playlistName: String, imageUrl: String, createPlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        print("Playlist name ", playlistName)
        print("Playlist image ", imageUrl)
        api.createPlaylist(playlistName: playlistName, imageUrl: imageUrl, success: { (data, code) -> Void in
            
            switch code {
            case 201:
                
                if let jsonObject = JSON(data as Any).dictionary {
                    self.returnPlaylistData.removeAll()
                    let playlist = GlobalPlaylistItem(id: jsonObject[GlobalPlaylistItem.JsonKeys.id]?.int ?? 0, order: jsonObject[GlobalPlaylistItem.JsonKeys.order]?.int ?? 0, name: jsonObject[GlobalPlaylistItem.JsonKeys.name]?.string ?? "", date: jsonObject[GlobalPlaylistItem.JsonKeys.date]?.string ?? "", image: jsonObject[GlobalPlaylistItem.JsonKeys.image]?.string ?? "", number_of_songs: jsonObject[GlobalPlaylistItem.JsonKeys.number_of_songs]?.int ?? 0)
                    self.returnPlaylistData.append(playlist)
                    createPlaylistCallFinished(true, nil, nil)
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
    
    func addToPlaylist(playlistId: String, songs: [String], addToPlaylistCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.addToPlaylist(playlistId: playlistId, songs: songs, success: { (data, code) -> Void in
            switch code {
            case 201:
                addToPlaylistCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                addToPlaylistCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (addToPlaylistCallFinished): \(error.localizedDescription)")
            addToPlaylistCallFinished(false, error, nil)
        }
    }
    
    func removeFromLibrary(key: String, id: Int, removeFromLibraryCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.removeFromLibrary(key: key, id: id, success: { (data, code) -> Void in
            switch code {
            case 200:
                removeFromLibraryCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                removeFromLibraryCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            //            Common.logout()
            NSLog("Error (removeFromLibraryCallFinished): \(error.localizedDescription)")
            removeFromLibraryCallFinished(false, error, nil)
        }
    }
    
    func removePlaylistFromLibrary(id: Int, removePlaylistFromLibraryCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ userInfo: [String: AnyObject]?) -> Void) {
        api.removePlaylistFromLibrary(id: id, success: { (data, code) -> Void in
            switch code {
            case 201:
                removePlaylistFromLibraryCallFinished(true, nil, nil)
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                removePlaylistFromLibraryCallFinished(false, error, nil)
            }
        }) { (error) -> Void in
            NSLog("Error (removePlaylistFromLibraryCallFinished): \(error.localizedDescription)")
            removePlaylistFromLibraryCallFinished(false, error, nil)
        }
    }
    
    
}
