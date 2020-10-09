//
//  Global.swift
//  SusilaMobile
//
//  Created by Admin on 8/20/19.
//  Copyright © 2019 KIroshan. All rights reserved.
//

class Main {
    var name:String
    var like:Bool
    var list:Bool
    
    var userName:String
    var status:Bool
    var viwerId:Int
    var mobileNo:String
    
    var epPlayingStatus:Bool
    var epPlayingId:Int
    
    var exitStatus:Bool
    
    var item = [[String]]()
    
    var playlistSessionToken:String
    
    var playlistId:Int
    var playlistName:String
    var playlistImage:String
    
    var subscribeStatus:Bool
    
    var currentPlayingId:Int
    var currentPlayingName:String
    
    var pImage: UIImage
    
    var searchStatus: Bool
    
    var songArray:[Int] = []
    
    init(name:String, like:Bool, list:Bool, userName:String, status:Bool, viwerId:Int, mobileNo:String, epPlayingStatus:Bool, epPlayingId:Int, exitStatus:Bool, item:[String], playlistSessionToken:String, playlistName:String, playlistImage:String, subscribeStatus:Bool, currentPlayingId:Int, currentPlayingName:String, playlistId:Int, pImage: UIImage, searchStatus: Bool, songArray:[Int] = []) {
        
        self.name = name
        self.like = like
        self.list = list
        
        self.userName = userName
        self.status = status
        self.viwerId = viwerId
        self.mobileNo = mobileNo
        
        self.epPlayingStatus = epPlayingStatus
        self.epPlayingId = epPlayingId
        
        self.exitStatus = exitStatus
        
        self.item = [item]
        self.playlistSessionToken = playlistSessionToken
        self.playlistName = playlistName
        self.playlistImage = playlistImage
        
        self.subscribeStatus = subscribeStatus
        
        self.currentPlayingId = currentPlayingId
        self.currentPlayingName = currentPlayingName
        
        self.playlistId = playlistId
        
        self.pImage = pImage
        self.searchStatus = searchStatus
        
        self.songArray = songArray
    }
}
var mainInstance = Main(name:"My Global Class", like:false, list:false, userName:"", status:false, viwerId:0, mobileNo:"", epPlayingStatus:false, epPlayingId:0, exitStatus:true, item: [], playlistSessionToken:"", playlistName:"New Playlist", playlistImage:"", subscribeStatus:false, currentPlayingId:0, currentPlayingName:"", playlistId:0, pImage: UIImage(named:"camera_icon")!, searchStatus: false, songArray: [])
