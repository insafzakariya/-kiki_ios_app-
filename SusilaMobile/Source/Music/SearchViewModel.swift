//
//  SearchModel.swift
//  SusilaMobile
//
//  Created by Meuru Muthuthanthri on 5/4/19.
//  Copyright © 2019 Isuru Jayathissa. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchViewModel {
    
    private let api = ApiClient()
    var searchByWordMainList: [Song] = []
    var songList: [Song] = []
    var songsList: [Song] = []
    var artistLists: [Artist] = []
    var playlistList: [GlobalPlaylistItem] = []
    var artistListsAll: [Artist] = []
    var playlistListAll: [GlobalPlaylistItem] = []
    var searchHistory: [String] = []
    
    func searchSong( text:String, searchSongCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ isEmpty: Bool) -> Void) {
        if (text.isEmpty) {
            self.songList.removeAll()
            searchSongCallFinished(true, nil, true)
            return
        }
        api.searchSongs(text:text, success: { (data, code) -> Void in
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                if let jsonList = jsonArray {
                    self.songList.removeAll()
                    for jsonObject in jsonList {
                        let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string?.removingPercentEncoding ?? "", artist: jsonObject[Song.JsonKeys.name].string ?? "")
                        self.songList.append(song)
                    }
                    searchSongCallFinished(true, nil, self.songList.isEmpty)
                } else {
                    searchSongCallFinished(false, NSError(), true)
                }
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                searchSongCallFinished(false, error, true)
            }
        }) { (error) -> Void in
            NSLog("Error (getSongsOfGenreCallFinished): \(error.localizedDescription)")
            searchSongCallFinished(false, error, true)
        }
    }
    
    func searchByWordAll(key: String, type: String, offset: Int, searchByWordAllCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ isEmpty: Bool) -> Void) {
        api.searchByWordAll(key: key, type: type, offset: offset, success: { (data, code) -> Void in
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                if let jsonList = jsonArray {
                    if type == "song" {
                        self.songList.removeAll()
                        for jsonObject in jsonList {
                            let song = Song(id: jsonObject[Song.JsonKeys.id].int ?? -1, name: jsonObject[Song.JsonKeys.name].string ?? "", duration: jsonObject[Song.JsonKeys.duration].int ?? 0, date: jsonObject[Song.JsonKeys.date].string ?? "", description: jsonObject[Song.JsonKeys.description].string ?? "", image: jsonObject[Song.JsonKeys.image].string ?? "", blocked: jsonObject[Song.JsonKeys.blocked].bool ?? false, url: jsonObject[Song.JsonKeys.url].string?.removingPercentEncoding ?? "", artist: jsonObject[Song.JsonKeys.artist].string ?? "")
                            self.songList.append(song)
                        }
                        searchByWordAllCallFinished(true, nil, self.songList.isEmpty)
                    } else if type == "artist" {
                        for jsonObjectArtist in jsonList {
                            let artist = Artist(id: jsonObjectArtist[Artist.JsonKeys.id].int ?? -1, name: jsonObjectArtist[Artist.JsonKeys.name].string ?? "", image: jsonObjectArtist[Artist.JsonKeys.image].string ?? "", songsCount: jsonObjectArtist[Artist.JsonKeys.songsCount].int ?? 0, numberOfAlbums: jsonObjectArtist[Artist.JsonKeys.numberOfAlbums].int ?? 0)
                            self.artistListsAll.append(artist)
                        }
                        searchByWordAllCallFinished(true, nil, self.artistListsAll.isEmpty)
                    } else if type == "playlist" {
                        for jsonObjectPlaylist in jsonList {
                            let playlist = GlobalPlaylistItem(id: jsonObjectPlaylist[GlobalPlaylistItem.JsonKeys.id].int ?? -1, order: jsonObjectPlaylist[GlobalPlaylistItem.JsonKeys.order].int ?? -1, name: jsonObjectPlaylist[GlobalPlaylistItem.JsonKeys.name].string ?? "", date: jsonObjectPlaylist[GlobalPlaylistItem.JsonKeys.date].string ?? "", image: jsonObjectPlaylist[GlobalPlaylistItem.JsonKeys.image].string ?? "", number_of_songs: jsonObjectPlaylist[GlobalPlaylistItem.JsonKeys.number_of_songs].int ?? -1)
                            self.playlistListAll.append(playlist)
                        }
                        searchByWordAllCallFinished(true, nil, self.playlistListAll.isEmpty)
                    }
                } else {
                    searchByWordAllCallFinished(false, NSError(), true)
                }
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                searchByWordAllCallFinished(false, error, true)
            }
        }) { (error) -> Void in
            NSLog("Error (searchByWordAllCallFinished): \(error.localizedDescription)")
            searchByWordAllCallFinished(false, error, true)
        }
    }
    
    func searchByWord(text:String, searchByWordCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ isEmpty: Bool) -> Void) {
        if (text.isEmpty) {
            self.searchByWordMainList.removeAll()
            searchByWordCallFinished(true, nil, true)
            return
        }
        api.searchByWord(text:text, success: { (data, code) -> Void in
            if code == 200 {
                let json = JSON(data as Any)
                self.songsList.removeAll()
                self.artistLists.removeAll()
                self.playlistList.removeAll()

                let jsonArraySong: Array<JSON> = json["songs"].arrayValue
                let jsonArrayArtist: Array<JSON> = json["artistLists"].arrayValue
                let jsonArrayPlaylist: Array<JSON> = json["playlists"].arrayValue
                if !jsonArraySong.isEmpty {
                    for jsonObjectSong in jsonArraySong {
                        let song = Song(id: jsonObjectSong[Song.JsonKeys.id].int ?? -1, name: jsonObjectSong[Song.JsonKeys.name].string ?? "", duration: jsonObjectSong[Song.JsonKeys.duration].int ?? 0, date: jsonObjectSong[Song.JsonKeys.date].string ?? "", description: jsonObjectSong[Song.JsonKeys.description].string ?? "", image: jsonObjectSong[Song.JsonKeys.image].string ?? "", blocked: jsonObjectSong[Song.JsonKeys.blocked].bool ?? false, url: jsonObjectSong[Song.JsonKeys.url].string?.removingPercentEncoding ?? "", artist: jsonObjectSong[Song.JsonKeys.artist].string ?? "")
                        self.songsList.append(song)
                    }
                }
                if !jsonArrayArtist.isEmpty {
                    for jsonObjectArtist in jsonArrayArtist {
                        let artist = Artist(id: jsonObjectArtist[Artist.JsonKeys.id].int ?? -1, name: jsonObjectArtist[Artist.JsonKeys.name].string ?? "", image: jsonObjectArtist[Artist.JsonKeys.image].string ?? "", songsCount: jsonObjectArtist[Artist.JsonKeys.songsCount].int ?? 0, numberOfAlbums: jsonObjectArtist[Artist.JsonKeys.numberOfAlbums].int ?? 0)
                        self.artistLists.append(artist)
                    }
                }
                if !jsonArrayPlaylist.isEmpty {
                    for jsonObjectPlaylist in jsonArrayPlaylist {
                        let playlist = GlobalPlaylistItem(id: jsonObjectPlaylist[GlobalPlaylistItem.JsonKeys.id].int ?? -1, order: jsonObjectPlaylist[GlobalPlaylistItem.JsonKeys.order].int ?? -1, name: jsonObjectPlaylist[GlobalPlaylistItem.JsonKeys.name].string ?? "", date: jsonObjectPlaylist[GlobalPlaylistItem.JsonKeys.date].string ?? "", image: jsonObjectPlaylist[GlobalPlaylistItem.JsonKeys.image].string ?? "", number_of_songs: jsonObjectPlaylist[GlobalPlaylistItem.JsonKeys.number_of_songs].int ?? -1)
                        self.playlistList.append(playlist)
                    }
                }
                searchByWordCallFinished(true, nil, false)
            } else {
                searchByWordCallFinished(false, nil, true)
            }
        }) { (error) -> Void in
            NSLog("Error (searchByWordCallFinished): \(error.localizedDescription)")
            searchByWordCallFinished(false, error, true)
        }
    }
    
    func getSearchHistory(getSearchHistoryCallFinished: @escaping (_ status: Bool, _ error: NSError?, _ isEmpty: Bool) -> Void) {
        api.getSearchHistory(success: { (data, code) -> Void in
            switch code {
            case 200:
                let jsonArray = JSON(data as Any).array
                if let jsonList = jsonArray {
                     //self.searchHistory.append(jsonObject)
                    self.searchHistory.removeAll()
                    for jsonObject in jsonList {
                        self.searchHistory.append(jsonObject.stringValue)
                    }
                    getSearchHistoryCallFinished(true, nil, self.songList.isEmpty)
                } else {
                    getSearchHistoryCallFinished(false, NSError(), true)
                }
            default:
                let jsonData = JSON(data as Any)
                let error = Common.getErrorFromJson(description: jsonData[ErrorJsonKeys.errorMessage].string ?? "", errorType: "\(jsonData[ErrorJsonKeys.errorCode].int ?? -1)", errorCode: jsonData[ErrorJsonKeys.errorCode].int ?? -1)
                getSearchHistoryCallFinished(false, error, true)
            }
        }) { (error) -> Void in
            NSLog("Error (getSearchHistoryCallFinished): \(error.localizedDescription)")
            getSearchHistoryCallFinished(false, error, true)
        }
    }
}
