//
//  PlayerView.swift
//  SusilaMobile
//
//  Created by MacBookSH on 12/17/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import UIKit
import AVKit
import Foundation
import AVFoundation

class PlayerView: UIView, AVAudioPlayerDelegate {
    // MARK: - Expanded slider elements
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    // MARK: - Button Box elements
    @IBOutlet weak var btnExpanPrevious: UIButton!
    @IBOutlet weak var btnExpanShuffle: UIButton!
    @IBOutlet weak var btnExpanPlayPause: UIButton!
    @IBOutlet weak var btnExpanRepeat: UIButton!
    @IBOutlet weak var btnExpanNext: UIButton!
    @IBOutlet weak var expandedView: UIView!
    // MARK: - Expand/Collapse elements
    @IBOutlet weak var btnCollapse: UIButton!
    @IBOutlet weak var btnClickExpand: UIButton!
    // MARK: - Minimized Player elements
    @IBOutlet weak var constPlayerProgress: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgSongThumb: UIImageView!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblSinger: UILabel!
    var addSongs = UIButton()
    
    @IBOutlet weak var viewCarousel: UIView!
    
    var dashboardVC = DashboardViewController(){
        didSet{
            dashboardVC.home?.playerView = self
        }
    }
    
    // MARK: - Variables Assigned
    var videoPlayer:AVPlayer!
    var timer:Timer?
    var isPlaying = false
    var isRepeat = false
    var isShuffle = false
    var totalDuration = 0//TODO-Change to max sent
    var scrollCollection = ScrollCollection(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-60, height: UIScreen.main.bounds.width))
    var radioStatus=""
    
    // MARK: - Variables with setters
    public  var songURLString: String = "" {
        willSet(newSongUrl) {
            videoPlayer.seek(to: CMTimeMake(value: 0,timescale: 1))
            videoPlayer.pause()
            if let accessToken = UserDefaultsManager.getAccessToken(){
                let fileURL = NSURL(string: newSongUrl+"?token=\(accessToken)")
                let avAsset = AVURLAsset(url: fileURL! as URL, options: nil)
                let playerItem = AVPlayerItem(asset: avAsset)
                NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)
                NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
                videoPlayer = AVPlayer(playerItem: playerItem)
                //            isPlaying = false
                currentPlayingTime = 0
                if isPlaying {
                    timer?.invalidate()
                    startTimer()
                }
                let totalDurationDbl: Double = avAsset.duration.seconds
                totalDuration = totalDurationDbl.isNaN || totalDurationDbl.isInfinite ? 0 : Int(totalDurationDbl)
                lblTotalTime.text = getTimeAsString(time: totalDuration)
                lblCurrentTime.text = "0:00"
            }
        }
        didSet {
            
        }
    }
    
    var currentPlayingTime = 0{
        willSet{
            
        }
        didSet{
            lblCurrentTime.text = getTimeAsString(time: currentPlayingTime)
            progressSlider.value = Float(currentPlayingTime)/Float(totalDuration)
        }
    }
    var originalPlayList:[Song] = [Song]()
    var currentPlayingList:[Song] = [Song](){
        willSet(newSongList) {
            self.totalSongsCount = newSongList.count
        }
        didSet {
            self.currentPlayingIndex = 0
            scrollCollection.currentPlayingList = currentPlayingList
            if (!isShuffle){
                originalPlayList = currentPlayingList
            }
        }
    }
    
    var currentPlayingIndex = 0{
        willSet(newIndex) {
            if (newIndex > 0){
                self.btnPrevious.isEnabled = true;
                self.btnPrevious.setBackgroundImage(UIImage(named: "previous"), for: UIControl.State.normal)
                self.btnExpanPrevious.isEnabled = true;
                self.btnExpanPrevious.setBackgroundImage(UIImage(named: "previous"), for: UIControl.State.normal)
                MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = true
            }
            else {
                self.btnPrevious.isEnabled = false;
                self.btnPrevious.setBackgroundImage(UIImage(named: "previous_gray"), for: UIControl.State.normal)
                self.btnExpanPrevious.isEnabled = false;
                self.btnExpanPrevious.setBackgroundImage(UIImage(named: "previous_gray"), for: UIControl.State.normal)
                MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = false
            }
            if (newIndex < totalSongsCount-1){
                self.btnNext.isEnabled = true;
                self.btnNext.setBackgroundImage(UIImage(named: "next"), for: UIControl.State.normal)
                self.btnExpanNext.isEnabled = true;
                self.btnExpanNext.setBackgroundImage(UIImage(named: "next"), for: UIControl.State.normal)
                MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = true
            }
            else {
                self.btnNext.isEnabled = false;
                self.btnNext.setBackgroundImage(UIImage(named: "next_gray"), for: UIControl.State.normal)
                self.btnExpanNext.isEnabled = false;
                self.btnExpanNext.setBackgroundImage(UIImage(named: "next_gray"), for: UIControl.State.normal)
                MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = false
            }
        }
        didSet {
            if (currentPlayingIndex < currentPlayingList.count) && (currentPlayingIndex >= 0){
                lblSongName.text = currentPlayingList[self.currentPlayingIndex].name
                lblSinger.text = currentPlayingList[self.currentPlayingIndex].description
                
                imgSongThumb.contentMode = .scaleAspectFit
                imgSongThumb.layer.cornerRadius = 5
                imgSongThumb.clipsToBounds = true
                
                var decodedImage = currentPlayingList[self.currentPlayingIndex].image ?? "".replacingOccurrences(of: "%3A", with: ":")
                decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                imgSongThumb.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                
                //if let url = URL(string: currentPlayingList[self.currentPlayingIndex].image ?? "") {
                // imgSongThumb.contentMode = .scaleAspectFit
                
                //imgSongThumb.downloadImage(from: url)
                // imgSongThumb.layer.cornerRadius = 5
                // imgSongThumb.clipsToBounds = true
                //   }
                songURLString = currentPlayingList[self.currentPlayingIndex].url ?? "" //"https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8"
            }
        }
    }
    var totalSongsCount = 0 {
        willSet(newTotal) {
            
        }
        didSet {
            
        }
    }
    
    let carousel : Carousel = {
        let carousel = Carousel()
        
        // Create as many slides as you'd like to show in the carousel
        let slide = CarouselSlide(image: UIImage(named: "pause_black") ?? UIImage(), title: "Hello There 👻", description: "Welcome to the ZKCarousel demo! Swipe left to view more slides!")
        let slide1 = CarouselSlide(image: UIImage(named: "pause_black2") ?? UIImage(), title: "A Demo Slide ☝🏼", description: "lorem ipsum devornum cora fusoa foen sdie ha odab ebakldf shjbesd ljkhf")
        let slide2 = CarouselSlide(image: UIImage(named: "pause_black") ?? UIImage(), title: "Another Demo Slide ✌🏼", description: "lorem ipsum devornum cora fusoa foen ebakldf shjbesd ljkhf")
        
        // Add the slides to the carousel
        carousel.slides = [slide, slide1, slide2]
        
        return carousel
    }()
    
    // MARK: - Progress update
    @objc func updateAudioProgressView()
    {
        if (isPlaying && (currentPlayingTime < totalDuration)) {
            currentPlayingTime = currentPlayingTime+1
        }
    }
    
    @objc func audioPlayerDidFinishPlaying(sender: Notification) {
        // Your code here
        if (isRepeat){
            videoPlayer.pause()
            currentPlayingTime = 0
            timer?.invalidate()
            videoPlayer.seek(to: CMTimeMake(value: 0,timescale: 1))
            startTimer()
            videoPlayer.play()
        }
        else if (currentPlayingIndex < currentPlayingList.count-1){
            self.actNext(UIButton())
        }
        else {
            currentPlayingIndex = 0
            scrollCollection.changeSong(index: self.currentPlayingIndex)
            self.actPlayPause(UIButton())
        }
    }
    
    // MARK: - Time
    func getTimeAsString(time:Int) -> String {
        var seconds = 0
        var minutes = 0
        
        seconds = time % 60
        minutes = (time / 60) % 60
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    
    func startTimer(){
        if ((timer) != nil){
            timer?.invalidate()
        }
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:  #selector(self.updateAudioProgressView), userInfo: nil, repeats: true)
    }
    
    // MARK: - Player actions
    func play() {
        if (currentPlayingIndex<currentPlayingList.count) && (currentPlayingIndex>=0) {
            if radioStatus=="radio" {
                sMPlayerViewModel.sendAnalytics(actionType: "audio_start", contendId: currentPlayingList[currentPlayingIndex].id, currentTime: stringFromTimeInterval(interval: currentPlayingTime))
            } else {
                sMPlayerViewModel.sendAnalytics(actionType: "song_start", contendId: currentPlayingList[currentPlayingIndex].id, currentTime: stringFromTimeInterval(interval: currentPlayingTime))
            }
            
            //updateAction(content_Id:9, screen_Id:16, screen_Action_Id:1, screen_Time:getTimeAsString(time: currentPlayingTime))
            
        }
        if mainInstance.subscribeStatus && radioStatus != "radio" {
            subscribeAlert()
        } else {
            if (songURLString != "") {
                
                isPlaying = true
                videoPlayer.play()
                startTimer()
                btnPlay.setBackgroundImage(UIImage(named: "pause_black"), for: UIControl.State.normal)
                btnExpanPlayPause.setBackgroundImage(UIImage(named: "pause_black2"), for: UIControl.State.normal)
                updateNowPlayingInfoCenter()
                
                if currentPlayingIndex == currentPlayingList.count-1 {
                    for (ind, val) in currentPlayingList.enumerated() {
                        if ind == currentPlayingIndex {
                            getSuggessionSongs(songID: val.id, cInd: currentPlayingIndex)
                        }
                    }
                }
            }
        }
        
    }
    
    func getSuggessionSongs(songID: Int, cInd: Int) {
        self.homeDataModel.getSuggessionSongs(songID: songID, getSuggessionSongsCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.currentPlayingList.append(contentsOf: self.homeDataModel.suggessionSongList)
                    self.currentPlayingIndex = cInd
                    self.scrollCollection.changeSong(index: self.currentPlayingIndex)
                    if (self.isPlaying){
                        self.play()
                    }
                })
            } else {
                DispatchQueue.main.async(execute: { ProgressView.shared.hide() })
            }
        })
    }
    
    var windows = UIApplication.shared.keyWindow!
    func getRootViewController() -> KYDrawerController{
        return windows.rootViewController as! KYDrawerController
    }
    
    func subscribeAlert() {
        if AppStoreManager.IS_ON_REVIEW{
            UIHelper.makeNoContentAlert(on: self.window!)
        }else{
            UIHelper.makeSubscribeToListenAlert(on: self.window!)
        }
    }
    
    private func updateNowPlayingInfoCenter() {
        if (currentPlayingIndex<currentPlayingList.count) && (currentPlayingIndex>=0) {
            let song: Song = currentPlayingList[currentPlayingIndex]
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle: song.name,
                MPMediaItemPropertyAlbumTitle: song.description ?? "",
                MPMediaItemPropertyPlaybackDuration: totalDuration,
                MPNowPlayingInfoPropertyElapsedPlaybackTime: (self.videoPlayer.currentItem?.currentTime().seconds ?? 0),
                MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: UIImage(named: "logo_grayscale")!),
            ]
            
            URLSession.shared.dataTask( with: NSURL(string:song.image ?? "")! as URL, completionHandler: {
                (data, response, error) -> Void in
                DispatchQueue.main.async(execute: {
                    guard let data = data, error == nil else { return }
                    if let img = UIImage(data: data) {
                        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: img)
                    }
                })
            }).resume()
        }
        
    }
    
    func stringFromTimeInterval(interval: Int) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func pause() {
        if (currentPlayingIndex<currentPlayingList.count) && (currentPlayingIndex>=0) {
            if radioStatus=="radio" {
                sMPlayerViewModel.sendAnalytics(actionType: "audio_pause", contendId: currentPlayingList[currentPlayingIndex].id, currentTime: stringFromTimeInterval(interval: currentPlayingTime))
            } else {
                sMPlayerViewModel.sendAnalytics(actionType: "song_pause", contendId: currentPlayingList[currentPlayingIndex].id, currentTime: stringFromTimeInterval(interval: currentPlayingTime))
            }
        }
        
        //updateAction(content_Id:9, screen_Id:16, screen_Action_Id:3, screen_Time:getTimeAsString(time: currentPlayingTime))
        if (songURLString != "" && isPlaying){
            isPlaying = false
            videoPlayer.pause()
            timer?.invalidate()
            btnPlay.setBackgroundImage(UIImage(named: "play"), for: UIControl.State.normal)
            btnExpanPlayPause.setBackgroundImage(UIImage(named: "play_black"), for: UIControl.State.normal)
        }
    }
    
    // MARK: - UI Element actions
    @IBAction func actPlayPause(_ sender: UIButton) {
        if (self.isPlaying){
            self.pause()
        }
        else {
            self.play()
        }
    }
    
    func next() {
        if (currentPlayingIndex < currentPlayingList.count-1) && (currentPlayingIndex >= 0) {
            sMPlayerViewModel.sendAnalytics(actionType: "song_stop", contendId: currentPlayingList[currentPlayingIndex].id, currentTime: stringFromTimeInterval(interval: currentPlayingTime))
            self.currentPlayingIndex = self.currentPlayingIndex+1
        }
        
        scrollCollection.changeSong(index: self.currentPlayingIndex)
        if (self.isPlaying){
            self.play()
        }
        
        for (index, listData) in currentPlayingList.enumerated() {
            if index == self.currentPlayingIndex {
                mainInstance.currentPlayingId = listData.id
                mainInstance.currentPlayingName = listData.name
            }
        }
        //updateAction(content_Id:9, screen_Id:16, screen_Action_Id:2, screen_Time:getTimeAsString(time: currentPlayingTime))
    }
    
    func prev() {
        if (currentPlayingIndex>=0) {
            self.currentPlayingIndex = self.currentPlayingIndex-1
            scrollCollection.changeSong(index: self.currentPlayingIndex)
            if (self.isPlaying){
                self.play()
            }
            
            for (index, listData) in currentPlayingList.enumerated() {
                if index == self.currentPlayingIndex {
                    mainInstance.currentPlayingId = listData.id
                    mainInstance.currentPlayingName = listData.name
                }
            }
        }
        
    }
    @IBAction func actNext(_ sender: UIButton) {
        self.next()
        
    }
    
    @IBAction func actPrevious(_ sender: UIButton) {
        self.prev()
    }
    
    var sfPlayList:[Song] = [Song]()
    @IBAction func btnActExpanShuffle(_ sender: UIButton) {
        sfPlayList.removeAll()
        isShuffle = !isShuffle
        //let ind = currentPlayingList[currentPlayingIndex]
        let song = Song(id: currentPlayingList[currentPlayingIndex].id, name: currentPlayingList[currentPlayingIndex].name, duration: currentPlayingList[currentPlayingIndex].duration, date: currentPlayingList[currentPlayingIndex].date!, description: currentPlayingList[currentPlayingIndex].description, image: currentPlayingList[currentPlayingIndex].image!, blocked: currentPlayingList[currentPlayingIndex].blocked!, url: currentPlayingList[currentPlayingIndex].url!, artist: currentPlayingList[currentPlayingIndex].artist)
        
        let tim = currentPlayingTime
        //btnExpanShuffle.backgroundColor = isShuffle ? UIColor.white : UIColor.clear
        let shuffle_white : UIImage = UIImage(named:"shuffle_white")!
        let shuffle_gray : UIImage = UIImage(named:"shuffle_gray")!
        //sfPlayList.append(currentPlayingList[currentPlayingIndex])
        videoPlayer.pause()
        if (isShuffle) {
            sfPlayList.append(song)
            currentPlayingList.shuffle()
            for (_, data) in currentPlayingList.enumerated() {
                sfPlayList.append(data)
            }
            currentPlayingList = sfPlayList
            btnExpanShuffle.setBackgroundImage(shuffle_white, for: .normal)
        } else {
            sfPlayList.append(song)
            for (_, data) in originalPlayList.enumerated() {
                sfPlayList.append(data)
            }
            currentPlayingList = sfPlayList
            btnExpanShuffle.setBackgroundImage(shuffle_gray, for: .normal)
        }
        //currentPlayingIndex = currentPlayingList[curre]
        currentPlayingIndex = 0
        currentPlayingTime = tim
        
        //currentPlayingTime = 0
        timer?.invalidate()
        if (isPlaying) {
            videoPlayer.seek(to: CMTimeMake(value: Int64(tim),timescale: 1))
            startTimer()
            videoPlayer.play()
        }
    }
    @IBAction func btnActExpanRepeat(_ sender: UIButton) {
        isRepeat = !isRepeat
        //btnExpanRepeat.backgroundColor = isRepeat ? UIColor.white : UIColor.clear
        
        let repeat_white : UIImage = UIImage(named:"repeat_white")!
        let repeat_gray : UIImage = UIImage(named:"repeat_gray")!
        
        if (isRepeat) {
            btnExpanRepeat.setBackgroundImage(repeat_white, for: .normal)
        } else {
            btnExpanRepeat.setBackgroundImage(repeat_gray, for: .normal)
        }
        
    }
    @IBAction func sliderActManual(_ sender: UISlider) {
        currentPlayingTime = Int(sender.value * Float(totalDuration))
        videoPlayer.seek(to: CMTimeMake(value: Int64(currentPlayingTime), timescale: 1))
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentPlayingTime
    }
    
    var addAlertDialog = AddAlertDialog()
    var addToPlaylistAlertDialog = AddToPlaylistAlertDialog()
    var overLayView = UIView(frame: UIScreen.main.bounds)
    var sMPlayerViewModel = SMPlayerViewModel()
    
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
        //btnExpanPlayPause.layer.cornerRadius = 0.5 * btnExpanPlayPause.bounds.size.width
        //btnExpanPlayPause.clipsToBounds = true
        Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        constPlayerProgress.constant = self.bounds.width - 4
        let fileURL = NSURL(string: songURLString)
        
        print("fileURL ", fileURL as Any)
        let avAsset = AVURLAsset(url: fileURL! as URL, options: nil)
        
        let playerItem = AVPlayerItem(asset: avAsset)
        videoPlayer = AVPlayer(playerItem: playerItem)
        self.btnPrevious.isEnabled = false;
        
        scrollCollection.backgroundColor = Constants.color_background
        viewCarousel.addSubview(scrollCollection)
        scrollCollection.playerView = self
        
        //        self.carousel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 200)
        //        self.viewCarousel.addSubview(self.carousel)
        
        dashboardVC.home?.playerView = self
        
        addSongs = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-70, y: 15, width: 50, height: 20))
        addSongs.setBackgroundImage(UIImage(named: "dots_gray"), for: .normal)
        addSongs.layer.cornerRadius = 10
        addSongs.clipsToBounds = true
        addSongs.setTitleColor(.white, for: .normal)
        addSongs.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        let tap = PlaylistTapGesture(target: self, action: #selector(buttonClick_Add))
        addSongs.isUserInteractionEnabled = true
        addSongs.addGestureRecognizer(tap)
        expandedView.addSubview(addSongs)
        
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
        
        self.addSubview(addAlertDialog)
        self.addSubview(addToPlaylistAlertDialog)
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
        //     ProgressView.shared.hide()
        //})
        
    }
    
    func getCenteredFrameForOverlay(_ height: CGFloat) -> CGRect {
        return CGRect(x: 15, y: (UIScreen.main.bounds.height - 250 - height)/2, width: UIScreen.main.bounds.width - 30 , height: height)
    }
    
    @objc func buttonClick_Add(sender:PlaylistTapGesture) {
        if mainInstance.currentPlayingId == 0 {
            for (index, listData) in currentPlayingList.enumerated() {
                if index == 0 {
                    mainInstance.currentPlayingId = listData.id
                    mainInstance.currentPlayingName = listData.name
                }
            }
        }
        showAddAlertDialog(title: mainInstance.currentPlayingName, id: mainInstance.currentPlayingId)
    }
    
    @objc func cancelClickAddAlertDialog(sender:PlaylistTapGesture) {
        addAlertDialog.isHidden = true
        addAlertDialog.removeFromSuperview()
        overLayView.removeFromSuperview()
    }
    
    func showAddAlertDialog(title: String, id: Int) {
        overLayView.removeFromSuperview()
        self.addSubview(overLayView)
        self.addSubview(addAlertDialog)
        addAlertDialog.lblTitle.text = title
        addAlertDialog.id = id
        addAlertDialog.isHidden = false
    }
    
    @objc func buttonClick_AddToLibrary(sender:PlaylistPlayGesture) {
        addToLibrary(key: "S", songs: addAlertDialog.id)
    }
    
    var homeDataModel = HomeDataModel()
    func addToLibrary(key: String, songs: Int) {
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        
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
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func cancelClickAddToPlaylistAlertDialog(sender:PlaylistTapGesture) {
        addToPlaylistAlertDialog.isHidden = true
        addToPlaylistAlertDialog.removeFromSuperview()
    }
    
    @objc func buttonClick_AddToPlaylist(sender:PlaylistPlayGesture) {
        addToPlaylistAlertDialog.removeFromSuperview()
        loadPlaylistsList()
        showAddToPlaylistAlertDialog(title: "Select Playlist", id: String(sender.id))
    }
    
    func showAddToPlaylistAlertDialog(title: String, id: String) {
        self.addSubview(addToPlaylistAlertDialog)
        addToPlaylistAlertDialog.id = addAlertDialog.id
        addToPlaylistAlertDialog.isHidden = false
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
    
    /*func updateAction(content_Id:Int, screen_Id:Int, screen_Action_Id:Int, screen_Time:String) {
     homeDataModel.updateAction(content_Id:content_Id, screen_Id:screen_Id, screen_Action_Id:screen_Action_Id, screen_Time:screen_Time, updateActionCallFinished: { (status, error, userInfo) in
     if status{
     DispatchQueue.main.async(execute: {
     print("Action Updated ", screen_Time)
     })
     }
     })
     }*/
    
}

extension UIImageView{
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async() {
                    self.image = UIImage(named: "logo_grayscale")
                }
                return }
            DispatchQueue.main.async() {
                if let img = UIImage(data: data) {
                    self.image = img
                } else {
                    self.image = UIImage(named: "logo_grayscale")
                }
            }
        }
    }
}
