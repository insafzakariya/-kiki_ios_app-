//
//  PlaylistDetailViewController.swift
//  SusilaMobile
//
//  Created by Kiroshan on 6/3/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class PlaylistDetailViewController: UIViewController {
    
    var id: String?
    var image: String?
    var name: String?
    var songs: String?
    var year: String?
    var homeDataModel = HomeDataModel()
    var playerView: PlayerView?
    
    var addAlertDialog = AddAlertDialog()
    var addToPlaylistAlertDialog = AddToPlaylistAlertDialog()
    var overLayView = UIView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.color_background
        getPlaylistSongs(id: id!)
        
        overLayView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        addAlertDialog = AddAlertDialog(frame: getCenteredFrameForOverlay(150))
        addAlertDialog.isHidden = true
        addAlertDialog.layer.zPosition = 1002
        addAlertDialog.btnCancel.addTarget(self, action: #selector(cancelClickAddAlertDialog), for: .touchUpInside)
            
        let tapAddToLibrary = PlaylistPlayGesture(target: self, action: #selector(buttonClick_AddToLibrary))
        addAlertDialog.lblAddToLibrary.isUserInteractionEnabled = true
        addAlertDialog.lblAddToLibrary.addGestureRecognizer(tapAddToLibrary)
            
        let tapAddToPlaylist = PlaylistPlayGesture(target: self, action: #selector(buttonClick_AddToPlaylist))
        //tapAddToPlaylist.id =
        addAlertDialog.lblAddToPlaylist.isUserInteractionEnabled = true
        addAlertDialog.lblAddToPlaylist.addGestureRecognizer(tapAddToPlaylist)
            
        addToPlaylistAlertDialog = AddToPlaylistAlertDialog(frame: getCenteredFrameForOverlay(300))
        addToPlaylistAlertDialog.isHidden = true
        addToPlaylistAlertDialog.layer.zPosition = 2002
        //addToPlaylistAlertDialog.scrollCollection = self
        addToPlaylistAlertDialog.btnCancel.addTarget(self, action: #selector(cancelClickAddToPlaylistAlertDialog), for: .touchUpInside)
            
        view.addSubview(addAlertDialog)
        view.addSubview(addToPlaylistAlertDialog)
    }
    
    @objc func buttonClickAddSongToPlaylist(sender: PlaylistTapGesture) {
        print("Title ", sender.title, " Id ", sender.id)
        showAddAlertDialog(title: sender.title, id: sender.id)
    }
    
    @objc func cancelClickAddAlertDialog(sender:PlaylistTapGesture) {
        addAlertDialog.isHidden = true
        addAlertDialog.removeFromSuperview()
        overLayView.removeFromSuperview()
    }
    
    @objc func buttonClick_AddToLibrary(sender:PlaylistPlayGesture) {
        addToLibrary(key: "S", songs: addAlertDialog.id)
    }
    
    @objc func buttonClick_AddToPlaylist(sender:PlaylistPlayGesture) {
        addToPlaylistAlertDialog.removeFromSuperview()
        loadPlaylistsList()
        showAddToPlaylistAlertDialog(title: "Select Playlist", id: String(sender.id))
    }
    
    var libraryAllPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var libraryDataModel = LibraryDataModel()
    func loadPlaylistsList() {
        self.libraryDataModel.getPlaylists(getPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async {
                    self.libraryAllPlaylists = self.libraryDataModel.playlists
                    if self.libraryAllPlaylists.count < 1 {
                        self.alert(message: NSLocalizedString("NoPlayListFound".localized(using: "Localizable"), comment: ""))
                    }
                    self.loadList(view: self.addToPlaylistAlertDialog.scrollList)
                }
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    var uiAlert = UIView(frame: CGRect.zero)
    func loadList(view: UIView) {
        uiAlert.removeFromSuperview()
        uiAlert = UIView(frame: CGRect(x: 0, y: 0, width: self.addToPlaylistAlertDialog.scrollList.frame.width, height: CGFloat(libraryAllPlaylists.count)*(UIScreen.main.bounds.width/6)+CGFloat(libraryAllPlaylists.count)*20))
        
        var xLength: CGFloat = 0
        for (_, tileData) in libraryAllPlaylists.enumerated(){
           
            
            let songTile = PlaylistTileAlertAllPlaylist(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickAddSongToPlaylists))
            tap.id = String(tileData.id)
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            xLength += UIScreen.main.bounds.width/6+20
            uiAlert.addSubview(songTile)
        }
        view.addSubview(uiAlert)
        
        self.addToPlaylistAlertDialog.scrollList.contentSize = CGSize(width: self.addToPlaylistAlertDialog.scrollList.frame.width, height: CGFloat(libraryAllPlaylists.count)*(UIScreen.main.bounds.width/6)+CGFloat(libraryAllPlaylists.count)*20)
    }
    
    @objc func buttonClickAddSongToPlaylists(recognizer: PlaylistTapGesture) {
        print("PlaylistId ", recognizer.id," SongId ", self.addAlertDialog.id)
        var songsid = [String]()
        songsid.append(String(self.addAlertDialog.id))
        addSongToPlaylist(playlistId: recognizer.id, songs: songsid)
        self.alert(message: NSLocalizedString("AddedToPlayList".localized(using: "Localizable"), comment: ""))
        self.addToPlaylistAlertDialog.isHidden = true
        self.addToPlaylistAlertDialog.removeFromSuperview()
        
        self.addAlertDialog.isHidden = true
        self.addAlertDialog.removeFromSuperview()
        self.overLayView.removeFromSuperview()
        
    }
    
    func addSongToPlaylist(playlistId: String, songs: [String]) {
        ProgressView.shared.show(addToPlaylistAlertDialog, mainText: nil, detailText: nil)
        self.libraryDataModel.addToPlaylist(playlistId: playlistId, songs: songs, addToPlaylistCallFinished: { (status, error, userInfo) in
            if status {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    @objc func cancelClickAddToPlaylistAlertDialog(sender:PlaylistTapGesture) {
        addToPlaylistAlertDialog.isHidden = true
        addToPlaylistAlertDialog.removeFromSuperview()
    }
    
    func showAddAlertDialog(title: String, id: String) {
        overLayView.removeFromSuperview()
        view.addSubview(overLayView)
        view.addSubview(addAlertDialog)
        addAlertDialog.lblTitle.text = title
        addAlertDialog.id = Int(id)!
        addAlertDialog.isHidden = false
    }
    
    func showAddToPlaylistAlertDialog(title: String, id: String) {
        view.addSubview(addToPlaylistAlertDialog)
        addToPlaylistAlertDialog.id = addAlertDialog.id
        addToPlaylistAlertDialog.isHidden = false
    }

    func getCenteredFrameForOverlay(_ height: CGFloat) -> CGRect {
        return CGRect(x: 15, y: (UIScreen.main.bounds.height - 250 - height)/2, width: UIScreen.main.bounds.width - 30 , height: height)
    }
    
    func getPlaylistSongs(id:String) {
        ProgressView.shared.show(view, mainText: "", detailText: "")
        self.homeDataModel.getLatestPlaylistSongs(id: id, getHomeLatestPlaylistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.createPlaylistDetails(id: id, url: self.image!, title: self.name!, songs_count: self.songs!, date: self.year!)
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {ProgressView.shared.hide()})
            }
        })
    }
    
    @objc func buttonClickedPlaylistPlay(recognizer: PlaylistPlayGesture) {
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            self.playerView?.radioStatus = "song"
            if currentPlayingListId != String(recognizer.id) {
                currentPlayingListId = String(recognizer.id)
                self.playerView!.pause()
                self.playerView!.currentPlayingList = homeDataModel.latestPlaylistSongsList
                self.playerView!.currentPlayingTime = 0
                self.playerView!.play()
            }
        }
    }
    
    var windows = UIApplication.shared.keyWindow!
    func getRootViewController() -> KYDrawerController{
        return windows.rootViewController as! KYDrawerController
    }
    func subscribeAlert() {
        let title = NSLocalizedString("SubscribeToListen".localized(using: "Localizable"), comment: "")
        let alert = UIAlertController(title: title, message: NSLocalizedString("PleaseActivateaPackageToUnlockAccess".localized(using: "Localizable"), comment: "")+NSLocalizedString("toExclusiveContentFromKiki".localized(using: "Localizable"), comment: ""), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("SubscribeNow".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: { action in
            let mainMenu = self.getRootViewController().drawerViewController as! SMMainMenuViewController
            mainMenu.navigateToPackagePage()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("CLOSE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    var currentPlayingListId = ""
    func createPlaylistDetails(id: String, url: String, title: String, songs_count: String, date: String) {
        currentPlayingListId = ""
        let viewLatestPlaylistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewLatestPlaylistDetails.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4+90+20))
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4+90))
        titleContainer.backgroundColor = Constants.color_background
        
          titleContainer.isUserInteractionEnabled = true
        var image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4))
        
        let img : UIImage = UIImage(named:"logo_grayscale")!
        image = UIImageView(image: img)
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4)
        
        var decodedImage = url.replacingOccurrences(of: "%3A", with: ":")
        decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
        image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
        //image.downloadImageHome(from: URL(string: url)!)
        print("Printer ", url)
        image.center.x = titleContainer.center.x
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
         
        let lblTitle = UILabel(frame: CGRect(x: 0, y: image.frame.height, width: UIScreen.main.bounds.width, height: 30))
        lblTitle.text = title
        lblTitle.textColor = UIColor.white
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont(name: "Roboto", size: 16.0)
         
        let songs = UILabel(frame: CGRect(x: 0, y: lblTitle.frame.height+image.frame.height, width: UIScreen.main.bounds.width/2-10, height: 20))
        songs.text = songs_count+" songs"
        songs.textColor = UIColor.gray
        songs.textAlignment = .right
        songs.font = UIFont(name: "Roboto", size: 11.0)
         
        let year = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2+10, y: lblTitle.frame.height+image.frame.height, width: UIScreen.main.bounds.width/2-10, height: 20))
        year.text = date
        year.textColor = UIColor.gray
        year.font = UIFont(name: "Roboto", size: 11.0)
        
        let labelPlaySong = UILabel()
        labelPlaySong.frame = CGRect(x: UIScreen.main.bounds.width/2-75, y: lblTitle.frame.height+image.frame.height+songs.frame.height+10, width: 70, height:20)
        
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named:"play")
        let imageOffsetY:CGFloat = -5.0;
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let  textAfterIcon = NSMutableAttributedString(string: NSLocalizedString("Play".localized(using: "Localizable"), comment: ""))
        completeText.append(textAfterIcon)
        labelPlaySong.textAlignment = .center
        labelPlaySong.attributedText = completeText
        
        labelPlaySong.textAlignment = .center
        labelPlaySong.font = UIFont(name: "Roboto", size: 13.0)
        labelPlaySong.layer.cornerRadius = 10
        labelPlaySong.textColor = UIColor.white
        labelPlaySong.layer.masksToBounds = true
        labelPlaySong.backgroundColor = Constants.color_brand
        let tap = PlaylistPlayGesture(target: self, action: #selector(buttonClickedPlaylistPlay))
        tap.id = Int(id)!
        labelPlaySong.isUserInteractionEnabled = true
        labelPlaySong.addGestureRecognizer(tap)
        
        let labelAddSong = UILabel()
        labelAddSong.frame = CGRect(x: UIScreen.main.bounds.width/2+5, y: lblTitle.frame.height+image.frame.height+songs.frame.height+10, width: 70, height:20)
        labelAddSong.text = NSLocalizedString("Add".localized(using: "Localizable"), comment: "")
        labelAddSong.textAlignment = .center
        labelAddSong.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelAddSong.layer.cornerRadius = 10
        labelAddSong.textColor = UIColor.white
        labelAddSong.layer.masksToBounds = true
        labelAddSong.backgroundColor = Constants.color_brand
        let tap2 = PlaylistPlayGesture(target: self, action: #selector(buttonClickedAddPlaylistToLibrary))
        tap2.id = Int(id)!
        labelAddSong.isUserInteractionEnabled = true
        labelAddSong.addGestureRecognizer(tap2)
         
        titleContainer.addSubview(image)
        titleContainer.addSubview(lblTitle)
        titleContainer.addSubview(songs)
        titleContainer.addSubview(year)
        titleContainer.addSubview(labelPlaySong)
        titleContainer.addSubview(labelAddSong)
        
        topBar.addSubview(titleContainer)
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height, width: view.frame.width, height: view.frame.height-topBar.frame.height))
        one.showsVerticalScrollIndicator = false
        one.showsHorizontalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height: CGFloat(homeDataModel.latestPlaylistSongsList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(homeDataModel.latestPlaylistSongsList.count)*20)+370+UIScreen.main.bounds.width/3+40))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height:CGFloat(homeDataModel.latestPlaylistSongsList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(homeDataModel.latestPlaylistSongsList.count)*20))
        
        one.isUserInteractionEnabled = true
        two.isUserInteractionEnabled = true
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in homeDataModel.latestPlaylistSongsList.enumerated(){
            let songTile = PlayListSongsTileAll(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            
            var decodedImage: String = ""
            decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            //songTile.styleType = self.styleType
            
            let tapPlay = PlaylistPlayGesture(target: self, action: #selector(buttonClickedPlaylistSongPlay))
            tapPlay.id = index
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tapPlay)
            
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickAddSongToPlaylist))
            tap.title = tileData.name
            tap.id = String(tileData.id)
            songTile.add.isUserInteractionEnabled = true
            songTile.add.addGestureRecognizer(tap)
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        
        viewLatestPlaylistDetails.addSubview(topBar)
        viewLatestPlaylistDetails.addSubview(one)
       
        view.addSubview(viewLatestPlaylistDetails)
    }
    
    @objc func buttonClickedPlaylistSongPlay(recognizer: PlaylistPlayGesture) {
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            self.playerView?.radioStatus = "song"
            self.playerView!.pause()
            self.playerView!.currentPlayingList = self.homeDataModel.latestPlaylistSongsList
            self.playerView!.currentPlayingIndex = recognizer.id
            self.playerView!.currentPlayingTime = 0
            self.playerView!.scrollCollection.changeSong(index: recognizer.id)
            self.playerView!.play()
        }
    }
    
    @objc func buttonClickedAddPlaylistToLibrary(recognizer: PlaylistPlayGesture) {
        addToLibrary(key: "P", songs: recognizer.id)
    }
    
    func addToLibrary(key: String, songs: Int) {
        
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        
        self.homeDataModel.addToLibrary(key: key, songs: songs, addToLibraryCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.alert(message: NSLocalizedString("AddedToLibrary".localized(using: "Localizable"), comment: ""))
                    self.addAlertDialog.isHidden = true
                    self.addAlertDialog.removeFromSuperview()
                    self.overLayView.removeFromSuperview()
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
          alert.dismiss(animated: true, completion: nil)
        }
    }
}
