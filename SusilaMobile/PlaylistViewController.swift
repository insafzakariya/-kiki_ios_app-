//
//  PlaylistViewController.swift
//  SusilaMobile
//
//  Created by MacBookSH on 12/5/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import UIKit

class PlaylistViewController: UIView {
    
    var collapsibleTableViewController:CollapsiblePlaylistTableViewController!
    let playlistModel = PlaylistModel()
    var parentVC: DashboardViewController!
    var homeVC = HomeViewController()
    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit(){
        
        collapsibleTableViewController = CollapsiblePlaylistTableViewController()
        collapsibleTableViewController.parentView = self
        collapsibleTableViewController.tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 207.5)
        collapsibleTableViewController.view.backgroundColor = Constants.color_background
        self.addSubview(collapsibleTableViewController.view)
    }
    
    func constructPlaylists() {
        self.collapsibleTableViewController.playerView = self.parentVC.playerView
        self.collapsibleTableViewController.sections = self.playlistModel.sections
    }
    
    func createPlaylist(playlistName: String, createPlaylistCallFinished: @escaping (_ status: Bool, _ playlist: GlobalPlaylistItem?) -> Void){
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        self.playlistModel.createPlaylist(playlistName: playlistName, createPlaylistCallFinished: { (status, error, playlist) in
            createPlaylistCallFinished(status, playlist)
            DispatchQueue.main.async(execute: {
                ProgressView.shared.hide()
            })
        })
    }
    
    func addToPlaylist(playlistId: Int, songId: Int, addToPlayListCallFinished: @escaping (_ status: Bool) -> Void){
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        self.playlistModel.addToPlayList(playlistId: playlistId, songId: songId, addToPlayListCallFinished: { (status) in
            addToPlayListCallFinished(status)
            DispatchQueue.main.async(execute: {
                ProgressView.shared.hide()
            })
        })
    }
    
    func loadAllPlaylists(){
        
        self.playlistModel.getPlaylists(getGlobalPlaylistCallFinished: { (status, error, userInfo) in
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            if status {
                self.parentVC.home?.globalPlayLists = self.playlistModel.globalPlaylists
            }
            //}
        })
        
        self.playlistModel.getPlaylists(getGlobalPlaylistCallFinished: { (status, error, userInfo) in
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            if status {
                self.parentVC.allSongs!.playlistItems = self.playlistModel.playlists
                self.playlistModel.loadAllPlaylistData()
            }
            //}
        })
    }
    
    func loadSongsOfGlobalPlaylistGlobal(listID:Int){
        self.playlistModel.getSongsOfPlaylistGlobal(listID: listID, getSongsOfPlaylistCallFinished:{ (status, error, songs) in
            if (status) {
                if (songs == nil || (songs?.isEmpty)!) {
                    let alert = UIAlertController(title: "Kiki", message: "No Songs Availabale", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: nil))
                    self.parentVC!.present(alert, animated: true, completion: nil)
                } else {
                    self.parentVC.playerView.pause()
                    self.parentVC.playerView.currentPlayingList = songs!
                    self.parentVC.playerView.currentPlayingTime = 0
                    self.parentVC.playerView.play()
                }
            } else {
                let alert = UIAlertController(title: "Kiki", message: "Unexpected error occured", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: nil))
                self.parentVC!.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func loadSongsOfGlobalPlaylist(listID:Int){
        self.playlistModel.getSongsOfPlaylist(listID: listID, getSongsOfPlaylistCallFinished:{ (status, error, songs) in
            if (status) {
                if (songs == nil || (songs?.isEmpty)!) {
                    let alert = UIAlertController(title: "Kiki", message: "No Songs Availabale", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: nil))
                    self.parentVC!.present(alert, animated: true, completion: nil)
                } else {
                    self.parentVC.playerView.pause()
                    self.parentVC.playerView.currentPlayingList = songs!
                    self.parentVC.playerView.currentPlayingTime = 0
                    self.parentVC.playerView.play()
                }
            } else {
                let alert = UIAlertController(title: "Kiki", message: "Unexpected error occured", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: nil))
                self.parentVC!.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class PlayListSongsCard: UIView {
    
     var libraryDataModel = LibraryDataModel()
       var id = 0
       var imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
       var image = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-40)*1/3, height: (UIScreen.main.bounds.width-40)*1/3))
       var lblTitle = UILabel(frame: CGRect(x: 0, y: 180, width: 200, height: 20))
       var lblDescription = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 20))
       var duration = UILabel(frame: CGRect.zero)
       var year = UILabel(frame: CGRect.zero)
       //let selectedColor = UIColor(red: 198/255, green: 241/255, blue: 253/255, alpha: 1.0)
       var add = UIButton(frame: CGRect.zero)
       var line = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5))
       let selectedColor = Constants.color_background
       var styleType = 0{
           didSet{
               //lblTitle.isHidden = styleType == 0 ? true:false
               //lblDescription.isHidden = styleType == 0 ? true:false
           }
           
       }
       var index = 0{
           didSet{
               image.tag = index
           }
       }
       var imageURL = "" {
           willSet{
               
           }
           didSet{
               //image.downloadImageSongTileHomeListSquareSongs(from: URL(string: imageURL)!)
           }
       }
       
       var isSelected = false{
           willSet{
               self.backgroundColor = UIColor.clear
               
               
           }
           didSet{
               if (styleType == 0){
                   self.imageContainer.backgroundColor = isSelected ? selectedColor : UIColor.clear
               }
           }
       }
       
       
       // MARK: - INIT
       override init(frame: CGRect) {
           super.init(frame:frame)
           self.commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           self.commonInit()
       }
       private func commonInit() {
           
           imageContainer = UIView(frame: CGRect(x: 10, y: 0, width: self.frame.width , height: self.frame.width ))
           image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.width/6))
           lblTitle = UILabel(frame: CGRect(x: image.frame.width+10, y: 0, width: self.frame.width-20 , height: 20))
           lblDescription = UILabel(frame: CGRect(x: image.frame.width+20, y: lblTitle.frame.height, width: self.frame.width-20, height: 20))
           
           duration = UILabel(frame: CGRect(x: image.frame.width+20, y: lblTitle.frame.height+lblDescription.frame.height+10, width: self.frame.width-20, height: 20))
           duration.text = ""
           duration.font = UIFont.systemFont(ofSize: 13)
           duration.textColor = UIColor.gray
           
           year = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2, y: lblTitle.frame.height+lblDescription.frame.height+10, width: self.frame.width-20, height: 20))
           year.text = ""
           year.font = UIFont.systemFont(ofSize: 13)
           year.textColor = UIColor.gray
           
           add = UIButton(frame: CGRect(x:  UIScreen.main.bounds.width-70, y: image.frame.height/2-10, width: 60, height: 20))
           add.layer.cornerRadius = 10
           add.layer.borderWidth = 1
           add.setTitle(NSLocalizedString("Add".localized(using: "Localizable"), comment: ""), for: .normal)
           add.backgroundColor = Constants.color_brand
           add.layer.borderColor = Constants.color_brand.cgColor
           add.setTitleColor(.white, for: .normal)
           add.clipsToBounds = true
           add.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 9.0)
           //add.addTarget(self, action: #selector(buttonClick_AddPlaylist), for: .touchUpInside)
           
           line = UIView(frame: CGRect(x: 10, y: image.frame.height+10, width: UIScreen.main.bounds.width-20 , height: 0.5))
           //line.backgroundColor = UIColor.gray
           
           let img : UIImage = UIImage(named:"logo_grayscale")!
           image = UIImageView(image: img)
           image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.width/6)
           image.layer.cornerRadius = 5
           image.clipsToBounds = true
           
           
           //lblTitle.isHidden = true
           lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
           lblTitle.textColor = Constants.color_brand
           //lblDescription.isHidden = true
           lblDescription.font = UIFont.systemFont(ofSize: 13)
           lblDescription.textColor = UIColor.white
           
           self.imageContainer.addSubview(image)
           self.imageContainer.addSubview(lblTitle)
           self.addSubview(imageContainer)
           self.addSubview(lblDescription)
           self.addSubview(duration)
           self.addSubview(year)
           self.addSubview(add)
           self.addSubview(line)
       }
       
       @objc func buttonClick_AddPlaylist(sender:PlaylistTapGesture) {
           
           if self.add.titleLabel?.text == NSLocalizedString("Add".localized(using: "Localizable"), comment: "") {
               self.add.setTitle("Added", for: .normal)
           } else {
               self.add.setTitle(NSLocalizedString("Add".localized(using: "Localizable"), comment: ""), for: .normal)
           }
       }

       func addToTempPlaylistSongs(session_id: String, ref_id: Int, type: String) {
           self.libraryDataModel.addToTempPlaylistSongs(session_id: session_id, ref_id: ref_id, type: type, addToTempPlaylistSongsCallFinished: { (status_r, error, userInfo) in
               if status_r {
                   DispatchQueue.main.async(execute: {})
               }
           })
       }
    
    
}
