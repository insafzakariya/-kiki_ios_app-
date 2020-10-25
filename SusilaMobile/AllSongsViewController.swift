//
//  AllSongsViewController.swift
//  SusilaMobile
//
//  Created by MacBookSH on 12/5/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import UIKit
import Kingfisher

class AllSongsViewController: UIView {
    let allSongsModel = AllSongsModel()
    var parentVC: DashboardViewController!
    var genreTileWidth = CGFloat(100)
    var songTileHeight = CGFloat(100)
    var scrollGenres = UIScrollView(frame: CGRect.zero)
    var genreButtonContainer = UIView(frame: CGRect.zero)
    var addToPlayListPop:AddToPlayListPop!
    var addToExistingPlayListPop:AddToExistingPlayListPop!
    var addPlayListPop:AddPlayListPop!
    var playlistCreationSuccessPop: PlaylistCreationSuccessPop!
    var successAlert:SuccessAlert!
    var scrollSongs = UIScrollView(frame: CGRect.zero)
    var songsContainer = UIView(frame: CGRect.zero)
    
    var genreViewArray:[GenreTile] = [GenreTile]()
    var playAllCard = PlayAllCard(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 40))
    var songGenres:[SongGenre] = [SongGenre](){
        willSet{
            genreButtonContainer.removeFromSuperview()
            scrollGenres.removeFromSuperview()
        }
        didSet{
            
            if ( CGFloat(songGenres.count + 1) * genreTileWidth < UIScreen.main.bounds.width ){
                genreTileWidth = UIScreen.main.bounds.width / CGFloat(songGenres.count + 1)
            }
            loadGenreInitial(count: songGenres.count)
            
            for (index, genreData) in songGenres.enumerated(){
                let genreTileFetched = GenreTile(frame: CGRect(x: CGFloat(index+1) * genreTileWidth, y: 0, width: genreTileWidth, height: 50))
                genreTileFetched.btnTransparent.setTitle(genreData.genreName, for: UIControl.State.normal)
                genreTileFetched.btnTransparent.addTarget(self, action: #selector(self.actGenreClick(_:)), for: UIControl.Event.touchUpInside)
                genreTileFetched.btnTransparent.tag = (index+1)
                genreTileFetched.isSelected = false
                genreTileFetched.index = index+1
                genreViewArray.append(genreTileFetched)
                
                genreButtonContainer.addSubview(genreTileFetched)
            }
            
            scrollGenres.scrollRectToVisible(genreViewArray[0].frame, animated: true)
        }
    }
    var genreTile:GenreTile!
    func loadGenreInitial(count:Int){
        scrollGenres = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        scrollGenres.showsHorizontalScrollIndicator = false
        scrollGenres.showsVerticalScrollIndicator = false
        genreButtonContainer = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(count+1) * genreTileWidth, height: 50))
        scrollGenres.addSubview(genreButtonContainer)
        scrollGenres.contentSize = CGSize(width: CGFloat(count+1) * genreTileWidth, height: 50)
        self.addSubview(scrollGenres)
        genreTile = GenreTile(frame: CGRect(x: 0, y: 0, width: genreTileWidth, height: 50))
        genreTile.btnTransparent.setTitle("All Songs", for: UIControl.State.normal)
        genreTile.btnTransparent.addTarget(self, action: #selector(self.actGenreClick(_:)), for: UIControl.Event.touchUpInside)
        genreTile.btnTransparent.tag = 0
        genreTile.isSelected = true
        genreTile.index = 0
        
        genreViewArray.append(genreTile)
        genreButtonContainer.addSubview(genreTile)
    }
    var selectedSongToAdd:Song!
    var allSongs:[Song] = [Song]()
    var isOnAllSongsTab = true
    var scrollHeight: CGFloat = 0
    
    var currentShowingSongs:[Song] = [Song](){
        willSet{
            songsContainer.removeFromSuperview()
            scrollSongs.removeFromSuperview()
        }
        didSet{
            scrollSongs = UIScrollView(frame: CGRect(x: 0, y: 92, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 90 - 207.5))
            scrollSongs.showsHorizontalScrollIndicator = false
            scrollSongs.showsVerticalScrollIndicator = false
            songsContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: CGFloat(currentShowingSongs.count) * songTileHeight))
            scrollSongs.addSubview(songsContainer)
            scrollSongs.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(currentShowingSongs.count) * songTileHeight)
            scrollSongs.delegate = self
            scrollSongs.contentOffset = CGPoint(x: 0, y: scrollHeight)
            
            //            SongCard
            
            for (index, songData) in currentShowingSongs.enumerated(){
                let songTile = SongCard(frame: CGRect(x: 0, y: CGFloat(index) * songTileHeight, width: UIScreen.main.bounds.width, height: songTileHeight))
                songTile.songData = songData
                //                genreTileFetched.btnTransparent.setTitle(genreData.genreName, for: UIControlState.normal)
                songTile.btnPlay.addTarget(self, action: #selector(self.actPlaySingleSong(_:)), for: UIControl.Event.touchUpInside)
                songTile.btnMore.addTarget(self, action: #selector(self.actMoreClicked(_:)), for: UIControl.Event.touchUpInside)
                songsContainer.addSubview(songTile)
            }
            
            self.addSubview(scrollSongs)
        }
    }
    var overLayView = UIView(frame: UIScreen.main.bounds)
    
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
        loadAllSongsGenres()
        loadGenreInitial(count: 1)
        playAllCard.btnPlayAll.addTarget(self, action: #selector(self.actPlayAll(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(playAllCard)
        overLayView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        addToPlayListPop = AddToPlayListPop(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 390, width: UIScreen.main.bounds.width, height: 200))
        addToPlayListPop.isHidden = true
        addToPlayListPop.layer.zPosition = 1000
        addToPlayListPop.btnClose.addTarget(self, action: #selector(self.actMoreClose(_:)), for: UIControl.Event.touchUpInside)
        addToPlayListPop.btnAddPlayList.addTarget(self, action: #selector(self.actAddPlayListNew(_:)), for: UIControl.Event.touchUpInside)
        addToPlayListPop.btnAddSongToPlaylist.addTarget(self, action: #selector(self.actAddToExistingPlayListShow(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(addToPlayListPop)
        
        addPlayListPop = AddPlayListPop(frame: getCenteredFrameForOverlay(200))
        addPlayListPop.isHidden = true
        addPlayListPop.layer.zPosition = 1001
        addPlayListPop.btnCreate.addTarget(self, action: #selector(self.actCreatePlaylist(_:)), for: UIControl.Event.touchUpInside)
        addPlayListPop.btnCancel.addTarget(self, action: #selector(self.actCancelAddPlayList(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(addPlayListPop)
        
        playlistCreationSuccessPop = PlaylistCreationSuccessPop(frame: getCenteredFrameForOverlay(200))
        playlistCreationSuccessPop.isHidden = true
        playlistCreationSuccessPop.layer.zPosition = 1001
        playlistCreationSuccessPop.btnCancel.addTarget(self, action: #selector(self.actCancelPlaylistCreationSucessPop(_:)), for: UIControl.Event.touchUpInside)
        playlistCreationSuccessPop.btnAdd.addTarget(self, action: #selector(self.actAddPlaylistCreationSucessPop(_:)), for: UIControl.Event.touchUpInside)
        playlistCreationSuccessPop.btnList.addTarget(self, action: #selector(self.actListPlaylistCreationSucessPop(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(playlistCreationSuccessPop)
        
        addToExistingPlayListPop = AddToExistingPlayListPop(frame: getCenteredFrameForOverlay(300))
        addToExistingPlayListPop.isHidden = true
        addToExistingPlayListPop.layer.zPosition = 1002
        addToExistingPlayListPop.btnCancel.addTarget(self, action: #selector(self.actCancelExistingPlaylists(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(addToExistingPlayListPop)
        
        successAlert = SuccessAlert(frame: getCenteredFrameForOverlay(120))
        successAlert.isHidden = true
        successAlert.layer.zPosition = 1003
        successAlert.btnOk.addTarget(self, action: #selector(self.actSuccessClose(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(successAlert)
        
        
    }
    
    var playlistItems:[GlobalPlaylistItem] = [GlobalPlaylistItem](){
        didSet{
            addToExistingPlayListPop.containerButtons.subviews.forEach{viewItem in
                viewItem.removeFromSuperview()
            }
            addToExistingPlayListPop.containerButtons.removeFromSuperview()
            addToExistingPlayListPop.containerButtons = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20, height: CGFloat(playlistItems.count * 50)))
            addToExistingPlayListPop.scrollList.contentSize = CGSize(width: UIScreen.main.bounds.width-20, height: CGFloat(playlistItems.count * 50))
            addToExistingPlayListPop.scrollList.addSubview(addToExistingPlayListPop.containerButtons)
            for (index, playlistItem) in playlistItems.enumerated(){
                let playListButton = UIButton(frame: CGRect(x: Int(UIScreen.main.bounds.width/2 - 110), y: index * 50, width: 200, height: 40))
                playListButton.setTitle(playlistItem.name, for: UIControl.State.normal)
                playListButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
                playListButton.layer.cornerRadius = 5
                playListButton.clipsToBounds = true
                playListButton.layer.borderWidth = 0.5
                playListButton.layer.borderColor = UIColor.gray.cgColor
                playListButton.tag = playlistItem.id
                playListButton.addTarget(self, action: #selector(self.actAddToExistingPlaylist(_:)), for: UIControl.Event.touchUpInside)
                addToExistingPlayListPop.containerButtons.addSubview(playListButton)
            }
            
        }
    }
    
    func getCenteredFrameForOverlay(_ height: CGFloat) -> CGRect {
        return CGRect(x: 15, y: (UIScreen.main.bounds.height - 250 - height)/2, width: UIScreen.main.bounds.width - 30 , height: height)
    }
    
    func getSongsOfGenre(genre:String){
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        self.allSongsModel.getSongsOfGenre(genre:genre,getSongsOfGenreCallFinished: { (status, error, songs) in
            if status {
                self.currentShowingSongs = songs ?? [Song]()
                ProgressView.shared.hide()
            } else {
                self.currentShowingSongs = [Song]()
                ProgressView.shared.hide()
            }
        })
    }
    
    func getRecentSongs(){
        
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        
        self.allSongsModel.getRecentSongs(getRecentSongsListCallFinished: { (status, error, userInfo) in
            if status{
                
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }else{
                
                
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func loadAllSongsGenres(){
        
        //        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        
        self.allSongsModel.getAllSongsGenreList(getAllSongsGenreListCallFinished: { (status, error, userInfo) in
            if status{
                
                DispatchQueue.main.async(execute: {
                    //                    ProgressView.shared.hide()
                    self.songGenres = self.allSongsModel.allGenreList
                })
            }else{
                
                
                DispatchQueue.main.async(execute: {
                    //                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func loadAllSongs(){
        
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        
        self.allSongsModel.getAllSongsList(offset: self.allSongs.count, getAllSongsListCallFinished: { (status, error, userInfo) in
            if status{
                
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                    self.parentVC.playerView.currentPlayingList = self.allSongsModel.allSongsList
                    self.allSongs = self.allSongsModel.allSongsList
                    self.currentShowingSongs = self.allSongsModel.allSongsList
                })
            } else {
                
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func fetchRemainingSongs() {
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        self.allSongsModel.getAllSongsList(offset: self.allSongs.count, getAllSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async{
                    ProgressView.shared.hide()
                }
                self.allSongs = self.allSongsModel.allSongsList
                self.currentShowingSongs = self.allSongsModel.allSongsList
            }else{
                DispatchQueue.main.async{
                    ProgressView.shared.hide()
                }
            }
        })
    }
    @IBAction func actPlaySingleSong(_ sender: UIButton) {
        let parentVw = sender.superview as! SongCard
        parentVC.playerView.pause()
        parentVC.playerView.currentPlayingList = [parentVw.songData]
        parentVC.playerView.currentPlayingIndex = 0
        parentVC.playerView.currentPlayingTime = 0
        if (parentVC.playerView.currentPlayingList.count > 0){
            parentVC.playerView.play()
        }
    }
    @IBAction func actMoreClicked(_ sender: UIButton) {
        overLayView.removeFromSuperview()
        self.addSubview(overLayView)
        self.addSubview(addToPlayListPop)
        let parentVw = sender.superview as! SongCard
        selectedSongToAdd = parentVw.songData
        addToPlayListPop.songData = selectedSongToAdd
        addToPlayListPop.isHidden = false
        scrollSongs.isUserInteractionEnabled = false
        
    }
    @IBAction func actMoreClose(_ sender: UIButton) {
        addToPlayListPop.isHidden = true
        scrollSongs.isUserInteractionEnabled = true
        addToPlayListPop.removeFromSuperview()
        overLayView.removeFromSuperview()
    }
    @IBAction func actSuccessClose(_ sender: UIButton) {
        successAlert.isHidden = true
        scrollSongs.isUserInteractionEnabled = true
        successAlert.removeFromSuperview()
        overLayView.removeFromSuperview()
    }
    
    func showAddToPlaylistOverlay() {
        overLayView.removeFromSuperview()
        self.addSubview(overLayView)
        self.addSubview(addToExistingPlayListPop)
        addToExistingPlayListPop.isHidden = false
    }
    
    @IBAction func actAddToExistingPlayListShow(_ sender: UIButton) {
        showAddToPlaylistOverlay()
    }
    
    @IBAction func actCancelExistingPlaylists(_ sender: UIButton) {
        addToExistingPlayListPop.isHidden = true
        //        scrollSongs.isUserInteractionEnabled = true
        addToExistingPlayListPop.removeFromSuperview()
        overLayView.removeFromSuperview()
    }
    
    func addSongToPlaylist(playlistId: Int, songId: Int) {
        self.parentVC.playlist?.addToPlaylist(playlistId: playlistId, songId: songId, addToPlayListCallFinished: { (status) in
            if (status) {
                self.addSubview(self.successAlert)
                self.successAlert.isHidden = false
                self.parentVC.playlist?.playlistModel.loadAllPlaylistData()
            } else {
                let alert = UIAlertController(title: "Kiki", message: "Unexpected error occured when creating the playlist", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK_BUTTON_TITLE".localizedString, style: UIAlertAction.Style.default, handler: nil))
                self.parentViewController!.present(alert, animated: true, completion: nil)
                self.scrollSongs.isUserInteractionEnabled = true
                self.overLayView.removeFromSuperview()
            }
        })
    }
    
    @IBAction func actAddToExistingPlaylist(_ sender: UIButton) {
        addSongToPlaylist(playlistId: sender.tag, songId: addToPlayListPop.songData.id)
        addToExistingPlayListPop.isHidden = true
        addToPlayListPop.isHidden = true
        addToExistingPlayListPop.removeFromSuperview()
        addToPlayListPop.removeFromSuperview()
    }
    @IBAction func actAddPlayListNew(_ sender: UIButton) {
        overLayView.removeFromSuperview()
        self.addSubview(overLayView)
        self.addSubview(addPlayListPop)
        addPlayListPop.tfName.text = ""
        addPlayListPop.isHidden = false
        //        scrollSongs.isUserInteractionEnabled = false
    }
    
    @IBAction func actCancelAddPlayList(_ sender: UIButton) {
        addPlayListPop.isHidden = true
        //        scrollSongs.isUserInteractionEnabled = true
        addPlayListPop.removeFromSuperview()
        overLayView.removeFromSuperview()
    }
    @IBAction func actCreatePlaylist(_ sender: UIButton) {
        let plalistName = addPlayListPop.tfName.text!
        if (plalistName.isEmpty) {
            let alert = UIAlertController(title: "Kiki", message: "Please enter the playlist name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK_BUTTON_TITLE".localizedString, style: UIAlertAction.Style.default, handler: nil))
            self.parentViewController!.present(alert, animated: true, completion: nil)
            return
        }
        addPlayListPop.isHidden = true
        self.parentVC.playlist?.createPlaylist(playlistName: plalistName, createPlaylistCallFinished: { (status, playlist) in
            if (status) {
                self.playlistCreationSuccessPop.playlist = playlist!
                self.addSubview(self.playlistCreationSuccessPop)
                self.playlistCreationSuccessPop.isHidden = false
                self.playlistItems.append(playlist!)
            } else {
                let alert = UIAlertController(title: "Kiki", message: "Unexpected error occured when creating the playlist", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK_BUTTON_TITLE".localizedString, style: UIAlertAction.Style.default, handler: nil))
                self.parentViewController!.present(alert, animated: true, completion: nil)
                return
            }
        })
        //        scrollSongs.isUserInteractionEnabled = true
        addPlayListPop.removeFromSuperview()
        overLayView.removeFromSuperview()
    }
    
    
    
    @IBAction func actCancelPlaylistCreationSucessPop(_ sender: UIButton) {
        playlistCreationSuccessPop.isHidden = true
        playlistCreationSuccessPop.removeFromSuperview()
    }
    
    @IBAction func actAddPlaylistCreationSucessPop(_ sender: UIButton) {
        addSongToPlaylist(playlistId: self.playlistCreationSuccessPop.playlist.id, songId: addToPlayListPop.songData.id)
        playlistCreationSuccessPop.isHidden = true
        playlistCreationSuccessPop.removeFromSuperview()
    }
    
    @IBAction func actListPlaylistCreationSucessPop(_ sender: UIButton) {
        playlistCreationSuccessPop.isHidden = true
        playlistCreationSuccessPop.removeFromSuperview()
        showAddToPlaylistOverlay()
    }
    
    @IBAction func actGenreClick(_ sender: UIButton) {
        genreButtonContainer.isUserInteractionEnabled = false
        let index = sender.tag
        genreViewArray.forEach{genreView in
            if (genreView.index == index){
                genreView.isSelected = true
                scrollGenres.scrollRectToVisible(genreView.frame, animated: true)
            }
            else{
                genreView.isSelected = false
            }
        }
        
        isOnAllSongsTab = index == 0
        if (isOnAllSongsTab){
            currentShowingSongs = allSongs
        } else {
            getSongsOfGenre(genre: songGenres[index-1].genreName ?? "")
        }
        self.scrollHeight = 0
        playAllCard.didSetOnce = false
        
        addToPlayListPop.isHidden = true
        addPlayListPop.isHidden = true
        addToPlayListPop.removeFromSuperview()
        addPlayListPop.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
            self.genreButtonContainer.isUserInteractionEnabled = true
        })
    }
    @IBAction func actPlayAll(_ sender: UIButton) {
        //TODO: load genre songs
        parentVC.playerView.pause()
        if (!playAllCard.didSetOnce && currentShowingSongs.count > 0){
            playAllCard.didSetOnce = true
            parentVC.playerView.currentPlayingList = currentShowingSongs
            if (currentShowingSongs.count > 0){
                parentVC.playerView.currentPlayingIndex = 0
                parentVC.playerView.currentPlayingTime = 0
            }
            
        }
        
        if (currentShowingSongs.count > 0){
            playAllCard.didSetOnce = true
            parentVC.playerView.currentPlayingList = currentShowingSongs
            parentVC.playerView.currentPlayingIndex = 0
            parentVC.playerView.currentPlayingTime = 0
            parentVC.playerView.play()
        }
        /*parentVC.playerView.pause()
         if (!playAllCard.didSetOnce && currentShowingSongs.count > 0){
         parentVC.playerView.currentPlayingList = currentShowingSongs
         if (currentShowingSongs.count > 0){
         parentVC.playerView.currentPlayingIndex = 0
         parentVC.playerView.currentPlayingTime = 0
         }
         playAllCard.didSetOnce = true
         }
         if (currentShowingSongs.count > 0){
         parentVC.playerView.play()
         }*/
        
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

class GenreTile: UIView {
    var lblLine:UILabel!
    var btnTransparent:UIButton!
    var index = 0
    var isSelected = false{
        willSet{
            lblLine.removeFromSuperview()
            lblLine = UILabel(frame: CGRect(x: 0, y: 47, width: self.frame.width, height: 3))
            lblLine.backgroundColor = UIColor.gray
            btnTransparent.setTitleColor(UIColor.gray, for: UIControl.State.normal)
            self.addSubview(lblLine)
        }
        didSet{
            if (isSelected == true){
                lblLine.removeFromSuperview()
                lblLine = UILabel(frame: CGRect(x: 0, y: 47, width: self.frame.width, height: 3))
                lblLine.backgroundColor = UIColor.white
                btnTransparent.setTitleColor(UIColor.white, for: UIControl.State.normal)
                self.addSubview(lblLine)
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
    private func commonInit(){
        lblLine = UILabel(frame: CGRect(x: 0, y: 47, width: self.frame.width, height: 3))
        btnTransparent = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        btnTransparent.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        lblLine.backgroundColor = UIColor.gray
        self.addSubview(lblLine)
        self.addSubview(btnTransparent)
    }
}

class PlayAllCard: UIView {
    
    var didSetOnce = false
    
    var lblPlayAll:UILabel!
    var btnPlayAll:UIButton!
    
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
        lblPlayAll = UILabel(frame: CGRect(x: self.frame.width - 160, y: 0, width: 80, height: 40))
        btnPlayAll = UIButton(frame: CGRect(x: self.frame.width - 70, y: 0, width: 40, height: 40))
        btnPlayAll.setBackgroundImage(UIImage(named: "play_green"), for: UIControl.State.normal)
        lblPlayAll.text = "Play All"
        lblPlayAll.textColor = UIColor.white
        self.addSubview(lblPlayAll)
        self.addSubview(btnPlayAll)
    }
}

class SongCard: UIView {
    
    var imgVw:UIImageView!
    var lblTitle:UILabel!
    var lblArtist:UILabel!
    var btnPlay:UIButton!
    var btnMore:UIButton!
    
    var imageURL = "" {
        willSet{
            
        }
        didSet{
            
            if (imageURL != ""){
                imgVw.kf.setImage(with: URL(string: imageURL)!)
//                imgVw.downloadImage(from: URL(string: imageURL)!)
            } 
        }
        
    }
    
    var songData = Song(id: 0, name: "", duration: 0, date: "", description: "", image: "", blocked: false, url: "", artist: ""){
        didSet{
            imageURL = songData.image!
            lblTitle.text = songData.name
            lblArtist.text = songData.description
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
    private func commonInit(){
        var x = CGFloat(15)
        
        imgVw = UIImageView(frame: CGRect(x: x, y: CGFloat(15), width: self.frame.height - 30, height: self.frame.height - 30))
        imgVw.layer.cornerRadius = 5
        imgVw.clipsToBounds = true
        x = x + self.frame.height - 30 + 10
        
        lblTitle = UILabel(frame: CGRect(x: x, y: self.frame.height/2 - 25, width: self.frame.width - x - 100, height: 25))
        lblTitle.textColor = UIColor.white
        lblTitle.font = UIFont.boldSystemFont(ofSize: 16)
        lblArtist = UILabel(frame: CGRect(x: x, y: self.frame.height/2, width: self.frame.width - x - 100, height: 25))
        lblArtist.textColor = UIColor.gray
        lblArtist.font = UIFont.systemFont(ofSize: 13)
        
        x = self.frame.width - 95
        btnPlay = UIButton(frame: CGRect(x: x, y: self.frame.height/2 - 35/2, width: 35, height: 35))
        btnPlay.setBackgroundImage(UIImage(named: "play_green"), for: UIControl.State.normal)
        btnPlay.layer.cornerRadius = 17.5
        btnPlay.clipsToBounds = true
        btnPlay.layer.borderWidth = 1
        btnPlay.layer.borderColor = UIColor.gray.cgColor
        x = self.frame.width - 50
        
        btnMore = UIButton(frame: CGRect(x: x, y: self.frame.height/2 - 35/2, width: 35, height: 35))
        btnMore.setBackgroundImage(UIImage(named: "dots"), for: UIControl.State.normal)
        
        self.addSubview(imgVw)
        self.addSubview(lblTitle)
        self.addSubview(lblArtist)
        self.addSubview(btnPlay)
        self.addSubview(btnMore)
    }
}

class AddToPlayListPop: UIView {
    
    var imgVw:UIImageView!
    var lblTitle:UILabel!
    var lblArtist:UILabel!
    var btnClose:UIButton!
    var btnAddPlayList:UIButton!
    var btnAddSongToPlaylist:UIButton!
    
    var imageURL = "" {
        willSet{
            
        }
        didSet{
            if (imageURL != ""){
                imgVw.kf.setImage(with: URL(string: imageURL)!)
//                imgVw.downloadImage(from: URL(string: imageURL)!)
            }
        }
    }
    
    var songData = Song(id: 0, name: "", duration: 0, date: "", description: "", image: "", blocked: false, url: "", artist: ""){
        didSet{
            imageURL = songData.image!
            lblTitle.text = songData.name
            lblArtist.text = songData.description
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
    private func commonInit(){
        self.backgroundColor = UIColor(red: 81/255, green: 136/255, blue: 137/255, alpha: 1.0)
        var x = CGFloat(15)
        
        imgVw = UIImageView(frame: CGRect(x: x, y: CGFloat(15), width: self.frame.height - 130, height: self.frame.height - 130))
        imgVw.layer.cornerRadius = 5
        imgVw.clipsToBounds = true
        x = x + self.frame.height - 130 + 10
        
        lblTitle = UILabel(frame: CGRect(x: x, y: self.frame.height/2 - 25 - 50, width: self.frame.width - x - 100, height: 25))
        lblTitle.textColor = UIColor.black
        lblTitle.font = UIFont.boldSystemFont(ofSize: 17)
        lblArtist = UILabel(frame: CGRect(x: x, y: self.frame.height/2 - 50, width: self.frame.width - x - 100, height: 25))
        lblArtist.textColor = UIColor.white
        lblArtist.font = UIFont.systemFont(ofSize: 14)
        
        btnClose = UIButton(frame: CGRect(x: self.frame.width - 40, y: 10, width: 30, height: 30))
        btnClose.setBackgroundImage(UIImage(named: "close_white"), for: UIControl.State.normal)
        btnClose.layer.cornerRadius = 15
        btnClose.clipsToBounds = true
        btnClose.layer.borderWidth = 1
        btnClose.layer.borderColor = UIColor.white.cgColor
        
        //add_playlist_white
        //Add to Playlist
        btnAddPlayList = UIButton(frame: CGRect(x: 20, y: self.frame.height/2 + 10, width: 40, height: 40))
        btnAddPlayList.setBackgroundImage(UIImage(named: "add_playlist_white"), for: UIControl.State.normal)
        
        btnAddSongToPlaylist = UIButton(frame: CGRect(x: 80, y: self.frame.height/2 + 10, width: 150, height: 40))
        btnAddSongToPlaylist.setTitle("AddtoPlaylist".localizedString, for: UIControl.State.normal)
        btnAddSongToPlaylist.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        self.addSubview(imgVw)
        self.addSubview(lblTitle)
        self.addSubview(lblArtist)
        self.addSubview(btnClose)
        self.addSubview(btnAddPlayList)
        self.addSubview(btnAddSongToPlaylist)
    }
}

class AddPlayListPop: UIView {
    
    var lblTitle:UILabel!
    var lblSubtitle:UILabel!
    var btnCreate:UIButton!
    var btnCancel:UIButton!
    var tfName:UITextField!
    
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
        
        lblTitle = UILabel(frame: CGRect(x: 10, y: 10, width: self.frame.width - 20, height: 22))
        lblTitle.text = "Create playlist"
        lblTitle.textAlignment = NSTextAlignment.left
        lblTitle.font = UIFont.boldSystemFont(ofSize: 17)
        lblTitle.textColor = UIColor.black
        
        lblSubtitle = UILabel(frame: CGRect(x: 10, y: 40, width: self.frame.width - 20, height: 40))
        lblSubtitle.text = "Please enter the playlist which you want to create"
        lblSubtitle.textAlignment = NSTextAlignment.left
        lblSubtitle.font = UIFont.systemFont(ofSize: 14)
        lblSubtitle.textColor = UIColor.gray
        lblSubtitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblSubtitle.numberOfLines = 2
        
        tfName = UITextField(frame: CGRect(x: 10, y: 90, width: self.frame.width - 20, height: 40))
        tfName.placeholder = "Playlist Name"
        
        btnCancel = UIButton(frame: CGRect(x: self.frame.width - 180, y: 140, width: 80, height: 40))
        btnCancel.setTitleColor(UIColor.red, for: UIControl.State.normal)
        btnCancel.layer.cornerRadius = 5
        btnCancel.clipsToBounds = true
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor.red.cgColor
        btnCancel.setTitle("CANCEL_BUTTON_TITLE".localizedString, for: UIControl.State.normal)
        
        btnCreate = UIButton(frame: CGRect(x: self.frame.width - 90, y: 140, width: 80, height: 40))
        btnCreate.setTitleColor(UIColor(red: 68/255, green: 137/255, blue: 136/255, alpha: 1.0), for: UIControl.State.normal)
        btnCreate.layer.cornerRadius = 5
        btnCreate.clipsToBounds = true
        btnCreate.layer.borderWidth = 1
        btnCreate.layer.borderColor = UIColor(red: 68/255, green: 137/255, blue: 136/255, alpha: 1.0).cgColor
        btnCreate.setTitle("Create", for: UIControl.State.normal)
        
        self.addSubview(lblTitle)
        self.addSubview(lblSubtitle)
        self.addSubview(btnCreate)
        self.addSubview(btnCancel)
        self.addSubview(tfName)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

func constructOverlayButton(x: CGFloat, overlayHeight: CGFloat, title: String, color: UIColor) -> UIButton {
    let button = UIButton(frame: CGRect(x: x, y: overlayHeight - 40 - 10 , width: 80, height: 40))
    button.setTitleColor(color, for: UIControl.State.normal)
    button.layer.cornerRadius = 5
    button.clipsToBounds = true
    button.layer.borderWidth = 1
    button.layer.borderColor = color.cgColor
    button.setTitle(title, for: UIControl.State.normal)
    return button;
}

class PlaylistCreationSuccessPop: UIView {
    
    var lblTitle:UILabel!
    var lblSubtitle:UILabel!
    var btnCancel:UIButton!
    var btnList:UIButton!
    var btnAdd:UIButton!
    var playlist: GlobalPlaylistItem = GlobalPlaylistItem(id: 0, order: 0, name: "", date: "", image: "", number_of_songs: 0){
        didSet{
            self.lblSubtitle.text = "Your Playlist \(playlist.name) have created. Do you want add this song to this playlist or select from playlist?"
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
    private func commonInit(){
        
        lblTitle = UILabel(frame: CGRect(x: 10, y: 10, width: self.frame.width - 20, height: 22))
        lblTitle.text = "Successfully Created"
        lblTitle.textAlignment = NSTextAlignment.left
        lblTitle.font = UIFont.boldSystemFont(ofSize: 17)
        lblTitle.textColor = UIColor.black
        
        lblSubtitle = UILabel(frame: CGRect(x: 10, y: 40, width: self.frame.width - 20, height: 40))
        lblSubtitle.text = "Your Playlist \(playlist.name) have created. Do you want add this song to this playlist or select from playlist?"
        lblSubtitle.textAlignment = NSTextAlignment.left
        lblSubtitle.font = UIFont.systemFont(ofSize: 14)
        lblSubtitle.textColor = UIColor.gray
        lblSubtitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblSubtitle.numberOfLines = 2
        
        btnCancel = constructOverlayButton(x: 10, overlayHeight: self.frame.height, title: "CANCEL_BUTTON_TITLE".localizedString, color: UIColor.red)
        btnAdd = constructOverlayButton(x: self.frame.width - 90, overlayHeight: self.frame.height, title: "Add", color: Constants.kikiBlueColor)
        btnList = constructOverlayButton(x: self.frame.width - 180, overlayHeight: self.frame.height, title: "List", color: Constants.kikiBlueColor)
        
        self.addSubview(lblTitle)
        self.addSubview(lblSubtitle)
        self.addSubview(btnCancel)
        self.addSubview(btnAdd)
        self.addSubview(btnList)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

class AddToExistingPlayListPop: UIView {
    
    var lblTitle:UILabel!
    var lblSubtitle:UILabel!
    var btnCancel:UIButton!
    
    var scrollList:UIScrollView!
    var containerButtons:UIView!
    
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
        
        lblTitle = UILabel(frame: CGRect(x: 10, y: 10, width: self.frame.width - 20, height: 22))
        lblTitle.text = "Select playlist"
        lblTitle.textAlignment = NSTextAlignment.left
        lblTitle.font = UIFont.boldSystemFont(ofSize: 17)
        lblTitle.textColor = UIColor.black
        
        lblSubtitle = UILabel(frame: CGRect(x: 10, y: 40, width: self.frame.width - 20, height: 40))
        lblSubtitle.text = "Please select a playlist below which you want to add the song"
        lblSubtitle.textAlignment = NSTextAlignment.left
        lblSubtitle.font = UIFont.systemFont(ofSize: 14)
        lblSubtitle.textColor = UIColor.gray
        lblSubtitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblSubtitle.numberOfLines = 2
        
        scrollList = UIScrollView(frame: CGRect(x: 0, y: 90, width: self.frame.width, height: self.frame.height - 150))
        containerButtons = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 150))
        scrollList.addSubview(containerButtons)
        scrollList.contentSize = CGSize(width: self.frame.width, height: self.frame.height - 150)
        
        btnCancel = UIButton(frame: CGRect(x: self.frame.width - 90, y: self.frame.height - 60, width: 80, height: 40))
        btnCancel.setTitleColor(UIColor(red: 68/255, green: 137/255, blue: 136/255, alpha: 1.0), for: UIControl.State.normal)
        btnCancel.layer.cornerRadius = 5
        btnCancel.clipsToBounds = true
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor(red: 68/255, green: 137/255, blue: 136/255, alpha: 1.0).cgColor
        btnCancel.setTitle("CANCEL_BUTTON_TITLE".localizedString, for: UIControl.State.normal)
        
        self.addSubview(lblTitle)
        self.addSubview(lblSubtitle)
        self.addSubview(btnCancel)
        self.addSubview(scrollList)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

class SuccessAlert: UIView {
    
    var lblTitle:UILabel!
    var lblSubtitle:UILabel!
    var btnOk:UIButton!
    
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
        
        lblTitle = UILabel(frame: CGRect(x: 10, y: 10, width: self.frame.width - 20, height: 22))
        lblTitle.text = "Successfully Added"
        lblTitle.textAlignment = NSTextAlignment.left
        lblTitle.font = UIFont.boldSystemFont(ofSize: 17)
        lblTitle.textColor = UIColor.black
        
        lblSubtitle = UILabel(frame: CGRect(x: 10, y: 40, width: self.frame.width - 20, height: 40))
        lblSubtitle.text = "Song successfully added to playlist"
        lblSubtitle.textAlignment = NSTextAlignment.left
        lblSubtitle.font = UIFont.systemFont(ofSize: 14)
        lblSubtitle.textColor = UIColor.gray
        lblSubtitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblSubtitle.numberOfLines = 2
        
        btnOk = UIButton(frame: CGRect(x: self.frame.width - 90, y: self.frame.height - 60, width: 80, height: 40))
        btnOk.setTitleColor(UIColor(red: 68/255, green: 137/255, blue: 136/255, alpha: 1.0), for: UIControl.State.normal)
        btnOk.layer.cornerRadius = 5
        btnOk.clipsToBounds = true
        btnOk.layer.borderWidth = 1
        btnOk.layer.borderColor = UIColor(red: 68/255, green: 137/255, blue: 136/255, alpha: 1.0).cgColor
        btnOk.setTitle("OK_BUTTON_TITLE".localizedString, for: UIControl.State.normal)
        
        self.addSubview(lblTitle)
        self.addSubview(lblSubtitle)
        self.addSubview(btnOk)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

extension AllSongsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let shouldRequestForRemaingEpisodes = offsetY + 100 > contentHeight - scrollView.frame.size.height
        if (shouldRequestForRemaingEpisodes && self.isOnAllSongsTab) {
            self.fetchRemainingSongs()
            self.scrollHeight = scrollSongs.contentSize.height - scrollSongs.frame.size.height
        }
    }
}
