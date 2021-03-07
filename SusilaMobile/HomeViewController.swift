//
//  HomeViewController.swift
//  SusilaMobile
//
//  Created by MacBookSH on 12/5/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import UIKit


class HomeViewController: UIView {
    
    var scrollView = UIScrollView(frame: CGRect.zero)
    var contentView = UIView(frame: CGRect.zero)
    var viewAllPopularSongs = UIView(frame: CGRect.zero)
    var viewAllLatestSongs = UIView(frame: CGRect.zero)
    var viewBrowseArtist = UIView(frame: CGRect.zero)
    var viewAllPopularArtists = UIView(frame: CGRect.zero)
    var viewAllLatestPlaylists = UIView(frame: CGRect.zero)
    var viewAllRadioDrama = UIView(frame: CGRect.zero)
    var viewLatestPlaylistDetails = UIView(frame: CGRect.zero)
    var viewAllPopularArtistSongs = UIView(frame: CGRect.zero)
    
    let homeDataModel = HomeDataModel()
    var parentVC: DashboardViewController!
    
    
    var currentPlayingList:[Song] = [Song]()
    var latestPlayList:[Song] = [Song]()
    var artistList:[Artist] = [Artist]()
    
    var playerView = PlayerView() {
        didSet{
            scrollCollectionMinimizedPopularSongs?.playerView = self.playerView
            scrollCollectionMinimizedLatestSinhalaSongs?.playerView = self.playerView
            scrollCollectionMinimizedRadioChannels?.playerView = self.playerView
            scrollCollectionMinimizedPopularArtists?.playerView = self.playerView
            scrollCollectionMinimizedSongsByArtist?.playerView = self.playerView
            
            scrollCollectionExapndedPopularSongs?.playerView = self.playerView
            scrollCollectionExapndedLatestSinhalaSongs?.playerView = self.playerView
            scrollCollectionExapndedRadioChannels?.playerView = self.playerView
            scrollCollectionExapndedPopularArtists?.playerView = self.playerView
            scrollCollectionExapndedPopularArtistSongs?.playerView = self.playerView
            scrollCollectionExapndedLatestPlaylistSongs?.playerView = self.playerView
            scrollCollectionExapndedSongsByArtist?.playerView = self.playerView
        }
    }
    
    var scrollCollectionMinimizedPopularSongs:ScrollCollection?
    var scrollCollectionMinimizedLatestSinhalaSongs:ScrollCollection?
    var scrollCollectionMinimizedRadioChannels:ScrollCollection?
    var scrollCollectionMinimizedPopularArtists:ScrollCollection?
    var scrollCollectionMinimizedSongsByArtist:ScrollCollection?
    
    var scrollCollectionExapndedPopularSongs:ScrollCollection?
    var scrollCollectionExapndedLatestSinhalaSongs:ScrollCollection?
    var scrollCollectionExapndedRadioChannels:ScrollCollection?
    var scrollCollectionExapndedPopularArtists:ScrollCollection?
    var scrollCollectionExapndedLatestPlaylistSongs:ScrollCollection?
    var scrollCollectionExapndedPopularArtistSongs:ScrollCollection?
    var scrollCollectionExapndedSongsByArtist:ScrollCollection?
    
    var tilesPopularSongs:[SongTileHomeListSquareSongs] = [SongTileHomeListSquareSongs]()
    var tilesSeeAllArtist:[SongTileSeeAllArtist] = [SongTileSeeAllArtist]()
    
    var styleType = 0{
        didSet{
            tilesPopularSongs.forEach{tile in
                tile.styleType = self.styleType
            }
        }
    }
    
    var selectedTileArtists:SongTileLibraryArtists?
    var tilesArtists:[SongTileLibraryArtists] = [SongTileLibraryArtists]()
    
    var globalBool: Bool = false {
        didSet {
            // This will get called
            //NSLog("Did Set" + globalBool.description)
            //setNeedsDisplay()
            //loadPopularArtistSongsList(id: 175)
            //createArtistDetails(id: 175, name: "Bhathiya  Jayakody,Sunthush", url: "https://cdn2.vectorstock.com/i/1000x1000/71/61/headphones-with-cord-and-word-music-vector-1807161.jpg", album: "11 albums", song: "Genre")
        }
    }
    
    var addAlertDialog = AddAlertDialog()
    var addToPlaylistAlertDialog = AddToPlaylistAlertDialog()
    var overLayView = UIView(frame: UIScreen.main.bounds)
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func commonInit() {
        AppDelegate.Home_Request_Count += 1
        self.backgroundColor = Constants.color_background
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: UIScreen.main.bounds.height-200))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        //scrollView.backgroundColor = UIColor.red
        
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ((UIScreen.main.bounds.width-40)*1/3+30)*3+440+(UIScreen.main.bounds.width-40)*1/3+UIScreen.main.bounds.width/2-10+150))
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: contentView.frame.height)
        
        scrollView.addSubview(contentView)
        
        createPopularSongsHeaderView(view: scrollView)
        loadPopularSongsView(view: scrollView)
        createPopularSongsSeeAllView(view: viewAllPopularSongs, title: "PopularSongs".localizedString)
        loadPopularSongsList()
        
        
        createLatestSongsHeaderView(view: scrollView)
        loadLatestSongsView(view: scrollView)
        createLatestSongsSeeAllView(view: viewAllLatestSongs, title: "LatestSongs".localizedString)
        loadLatestSongsList()
        
        
        createRadioHeaderView(view: scrollView)
        loadRadioView(view: scrollView)
        loadRadioList()
        
        
        viewAllPopularArtists = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        loadHomePopularArtistsList(view: scrollView)
        createArtistHeaderView(view: scrollView)
        
        createPlaylistHeaderView(view: scrollView)
        createLatestPlaylistSeeAllView(view: viewAllLatestPlaylists, title:"LastestPlaylist".localizedString)
        loadPlaylists()
        
        createRadioDramaHeaderView(view: scrollView)
        createRadioDramaSeeAllView(view: viewAllRadioDrama, title:"RadioDrama".localizedString)
        loadRadioDrama()
        
        
        self.addSubview(scrollView)
        
        self.addSubview(viewAllPopularSongs)
        viewAllPopularSongs.isHidden = true
        
        self.addSubview(viewAllLatestSongs)
        viewAllLatestSongs.isHidden = true
        
        self.addSubview(viewAllPopularArtists)
        
        self.addSubview(viewAllLatestPlaylists)
        viewAllLatestPlaylists.isHidden = true
        
        self.addSubview(viewAllRadioDrama)
        viewAllRadioDrama.isHidden = true
        
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
        
        if notifyInstance.status && notifyInstance.content_type == "artistid" {
            self.getArtistById(aid: notifyInstance.content_id)
        } else if notifyInstance.status && notifyInstance.content_type == "playlistid" {
            self.getPlaylistById(pid: notifyInstance.content_id)
        }
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
                        self.alert(message: "NoPlayListFound".localizedString)
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
    
    deinit {
        Log("Deinit Home VC")
        AppDelegate.Home_Request_Count = 0
    }
    
    @objc func buttonClickAddSongToPlaylists(recognizer: PlaylistTapGesture) {
        print("PlaylistId ", recognizer.id," SongId ", self.addAlertDialog.id)
        var songsid = [String]()
        songsid.append(String(self.addAlertDialog.id))
        addSongToPlaylist(playlistId: recognizer.id, songs: songsid)
        self.alert(message: "AddedToPlayList".localizedString)
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
        self.addSubview(overLayView)
        self.addSubview(addAlertDialog)
        addAlertDialog.lblTitle.text = title
        addAlertDialog.id = Int(id)!
        addAlertDialog.isHidden = false
    }
    
    func showAddToPlaylistAlertDialog(title: String, id: String) {
        self.addSubview(addToPlaylistAlertDialog)
        addToPlaylistAlertDialog.id = addAlertDialog.id
        addToPlaylistAlertDialog.isHidden = false
    }
    
    func getCenteredFrameForOverlay(_ height: CGFloat) -> CGRect {
        return CGRect(x: 15, y: (UIScreen.main.bounds.height - 250 - height)/2, width: UIScreen.main.bounds.width - 30 , height: height)
    }
    
    func addToLibrary(key: String, songs: Int) {
        if key=="A" || key=="P" {
            ProgressView.shared.show(self, mainText: nil, detailText: nil)
        } else {
            ProgressView.shared.show(addAlertDialog, mainText: nil, detailText: nil)
        }
        
        self.homeDataModel.addToLibrary(key: key, songs: songs, addToLibraryCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.alert(message: "AddedToLibrary".localizedString)
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
    
    //Popular Songs Header View
    func createPopularSongsHeaderView(view: UIView) {
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "PopularSongs".localizedString
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: topBar.frame.width-80, y: 15, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongsSeeAll.layer.cornerRadius = 10
        labelSongsSeeAll.textColor = UIColor.white
        labelSongsSeeAll.layer.masksToBounds = true
        labelSongsSeeAll.backgroundColor = Constants.color_brand
        let tap = HomeTapGesture(target: self, action: #selector(buttonClickedSeeAllPopularSongs))
        tap.lname = "Popular Songs"
        labelSongsSeeAll.isUserInteractionEnabled = true
        labelSongsSeeAll.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAll)
        
        view.addSubview(topBar)
        
    }
    
    func loadPopularSongsView(view: UIView) {
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width-40)*1/3+30))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        scrollCollectionMinimizedPopularSongs = ScrollCollection(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionMinimizedPopularSongs?.styleType = 1
        songsViewContent.addSubview(scrollCollectionMinimizedPopularSongs!)
        
        viewGenreSongs.addSubview(songsViewContent)
        
        view.addSubview(viewGenreSongs)
    }
    
    func loadPopularSongsList() {
        self.homeDataModel.getHomePopularSongs(getHomePopularSongsListCallFinished: { (status, error, userInfo) in
            if status{
                let minimizedArray = self.homeDataModel.popularSongsList.chunked(into: 10)
                self.scrollCollectionMinimizedPopularSongs?.currentPlayingList = (self.homeDataModel.popularSongsList.count) > 10 ? minimizedArray[0] : self.homeDataModel.popularSongsList
                self.scrollCollectionExapndedPopularSongs?.currentPlayingList = (self.homeDataModel.popularSongsList)
                if notifyInstance.status && notifyInstance.content_type == "songid" {
                    self.getSongById(sid: notifyInstance.content_id)
                } else {
                    self.playerView.currentPlayingList = (self.homeDataModel.popularSongsList)
                }
                //                                })
            } else {
                //                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func getSongById(sid: String) {
        self.homeDataModel.getSongById(sid: sid, getSongByIdCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.playerView.currentPlayingList = self.homeDataModel.songByIdList
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func getArtistById(aid: String) {
        self.homeDataModel.getArtistById(aid: aid, getArtistByIdCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    for data in self.homeDataModel.artistByIdList {
                        self.loadPopularArtistSongsList(id: data.id)
                        self.createArtistDetails(id: data.id, name: data.name, url: data.image!, album: "", song: data.songsCount!+" Songs")
                    }
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func getPlaylistById(pid: String) {
        self.homeDataModel.getPlaylistById(pid: pid, getPlaylistByIdCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    for data in self.homeDataModel.playlistByIdList {
                        var decodedImage = data.image!.replacingOccurrences(of: "%3A", with: ":")
                        decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                        decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
                        
                        self.loadAllLatestPlaylistSongsList(id: String(data.id), url: decodedImage, title: data.name, songs_count: String(data.number_of_songs), date: data.date!.components(separatedBy: "-")[0])
                    }
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    //Latest Songs Header View
    func createLatestSongsHeaderView(view: UIView) {
        
        let topBar = UIView(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width-40)*1/3+80, width: UIScreen.main.bounds.width, height: 50))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "LatestSongs".localizedString
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: topBar.frame.width-80, y: 15, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongsSeeAll.layer.cornerRadius = 10
        labelSongsSeeAll.textColor = UIColor.white
        labelSongsSeeAll.layer.masksToBounds = true
        labelSongsSeeAll.backgroundColor = Constants.color_brand
        let tap = HomeTapGesture(target: self, action: #selector(buttonClickedSeeAllLatestSongs))
        tap.lname = "Latest Songs"
        labelSongsSeeAll.isUserInteractionEnabled = true
        labelSongsSeeAll.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAll)
        
        view.addSubview(topBar)
    }
    
    func loadLatestSongsView(view: UIView) {
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width-40)*1/3+130, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width-40)*1/3+30))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        scrollCollectionMinimizedLatestSinhalaSongs = ScrollCollection(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionMinimizedLatestSinhalaSongs?.styleType = 1
        songsViewContent.addSubview(scrollCollectionMinimizedLatestSinhalaSongs!)
        
        viewGenreSongs.addSubview(songsViewContent)
        
        view.addSubview(viewGenreSongs)
    }
    
    func loadLatestSongsList() {
        self.homeDataModel.getHomeLatestSongs(getHomeLatestSongsListCallFinished: { (status, error, userInfo) in
            if status{
                //                DispatchQueue.main.async(execute: {
                let minimizedArray = self.homeDataModel.latestSongsList.chunked(into: 10)
                self.scrollCollectionMinimizedLatestSinhalaSongs?.currentPlayingList = self.homeDataModel.latestSongsList.count > 10 ? minimizedArray[0] : self.homeDataModel.latestSongsList
                self.scrollCollectionExapndedLatestSinhalaSongs?.currentPlayingList = self.homeDataModel.latestSongsList
                
                Log("homeDataModel.latestSongsList: \(self.homeDataModel.latestSongsList.count)")
                //                })
            } else {
                //                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    //Radio Songs Header View
    func createRadioHeaderView(view: UIView) {
        
        let topBar = UIView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3+30)*2+100, width: UIScreen.main.bounds.width, height: 50))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "RadioChannels".localizedString
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: topBar.frame.width-80, y: 15, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.layer.cornerRadius = 10
        labelSongsSeeAll.textColor = UIColor.white
        labelSongsSeeAll.layer.masksToBounds = true
        labelSongsSeeAll.backgroundColor = Constants.color_brand
        //let tap = UITapGestureRecognizer(target: self, action: #selector(buttonClickedSeeAllSongs))
        //labelSongsSeeAll.isUserInteractionEnabled = true
        //labelSongsSeeAll.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        //topBar.addSubview(labelSongsSeeAll)
        
        view.addSubview(topBar)
    }
    
    func loadRadioView(view: UIView) {
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3+30)*2+150, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width-40)*1/3+10))
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        scrollCollectionExapndedRadioChannels = ScrollCollection(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionExapndedRadioChannels?.styleType = 22
        songsViewContent.addSubview(scrollCollectionExapndedRadioChannels!)
        viewGenreSongs.addSubview(songsViewContent)
        view.addSubview(viewGenreSongs)
    }
    
    func loadRadioList() {
        self.homeDataModel.getRadioChannels(getRadioChannelsListCallFinished: { (status, error, userInfo) in
            if status{
                //                DispatchQueue.main.async(execute: {
                let minimizedArray = self.homeDataModel.radioChannelsList.chunked(into: 10)
                self.scrollCollectionExapndedRadioChannels?.currentPlayingList = self.homeDataModel.radioChannelsList.count > 10 ? minimizedArray[0] : self.homeDataModel.radioChannelsList
                //self.scrollCollectionExapndedPopularSongs?.currentPlayingList = self.homeDataModel.popularSongsList
                //                })
            } else {
                //                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    //Popular Artist Songs Header View
    func createArtistHeaderView(view: UIView) {
        
        let topBar = UIView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3+30)*3+130, width: UIScreen.main.bounds.width, height: 50))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "PopularArtist".localizedString
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        //labelAlbum.backgroundColor = UIColor.green
        
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: topBar.frame.width-80, y: 15, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongsSeeAll.lineBreakMode = .byWordWrapping
        labelSongsSeeAll.numberOfLines = 2
        labelSongsSeeAll.layer.cornerRadius = 10
        labelSongsSeeAll.textColor = UIColor.white
        labelSongsSeeAll.layer.masksToBounds = true
        labelSongsSeeAll.backgroundColor = Constants.color_brand
        let tap = HomeTapGesture(target: self, action: #selector(buttonClickedSeeAllArtist))
        tap.lname = "Popular Artists"
        labelSongsSeeAll.isUserInteractionEnabled = true
        labelSongsSeeAll.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAll)
        
        view.addSubview(topBar)
    }
    
    func createArtistSeeAllView(view: UIView, title: String) {
        
        
        viewAllPopularArtists.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(goPopularArtistBackButtonClicked), for: .touchUpInside)
        
        let text = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        text.text = "PopularArtist".localizedString
        text.textColor = UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(text)
        viewAllPopularArtists.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: self.frame.height))
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:  CGFloat(artistList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(artistList.count)*20)+340))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height: CGFloat(artistList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(artistList.count)*20)+340)
        
        var xLength: CGFloat = 10
        
        for (_, tileData) in artistList.enumerated() {
            let songTile = SongTileHomeAllArtists(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            if tileData.songsCount! > 0 {
                songTile.albums.text = String(tileData.songsCount!)+" songs"
            }
            if tileData.numberOfAlbums! > 0 {
                //songTile.albums.text = String (tileData.numberOfAlbums!)+" albums"
            }
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedArtist))
            tap.id = tileData.id
            tap.aname = tileData.name
            tap.url = decodedImage
            tap.songs = tileData.songsCount!
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            let tapAdd = PlaylistPlayGesture(target: self, action: #selector(buttonClickedAddArtistToLibrary))
            tapAdd.id = tileData.id
            songTile.add.isUserInteractionEnabled = true
            songTile.add.addGestureRecognizer(tapAdd)
            
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        viewAllPopularArtists.addSubview(one)
        viewAllPopularArtists.isHidden = true
    }
    
    @objc func goPopularArtistBackButtonClicked(sender:UIButton) {
        viewAllPopularArtists.isHidden = true
    }
    
    
    //Artists View
    func loadHomePopularArtistsViews(view: UIView) {
        
        let viewArtist = UIScrollView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3+30)*3+180, width: UIScreen.main.bounds.width , height: (UIScreen.main.bounds.width-40)*1/3+10))
        //viewGenreSongs.backgroundColor = UIColor.yellow
        viewArtist.showsHorizontalScrollIndicator = false
        viewArtist.showsVerticalScrollIndicator = false
        
        let artistContent = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(artistList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: viewArtist.frame.height))
        //artistContent.backgroundColor = UIColor.gray
        
        viewArtist.addSubview(artistContent)
        
        viewArtist.contentSize = CGSize(width: CGFloat(artistList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: viewArtist.frame.height)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in artistList.enumerated(){
            
            let songTile = SongTileHomeArtists(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
            //songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedArtist))
            tap.id = tileData.id
            tap.aname = tileData.name
            tap.url = decodedImage
            tap.songs = tileData.songsCount!
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            //songTile.styleType = self.styleType
            xLength += ((UIScreen.main.bounds.width-40)*1/3)
            artistContent.addSubview(songTile)
            if index == 0 {
                // selectedTileArtists = songTile
            }
            //tilesArtists.append(songTile)
        }
        //songsViewContent.addSubview(scrollCollectionSong!)
        
        
        
        view.addSubview(viewArtist)
        
    }
    
    func createArtistDetails(id: Int, name: String, url: String, album: String, song: String) {
        
        viewBrowseArtist = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewBrowseArtist.backgroundColor = Constants.color_background
        
        //vi.isUserInteractionEnabled = false
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(goArtistButtonClicked), for: .touchUpInside)
        
        topBar.addSubview(arrow)
        viewBrowseArtist.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height, width: viewBrowseArtist.frame.width , height: self.frame.height))
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:420+UIScreen.main.bounds.width/3+UIScreen.main.bounds.width/2+10+UIScreen.main.bounds.width*1/3))
        one.addSubview(two)
        //one.contentSize = CGSize(width: one.frame.width, height:two.frame.height)\
        
        
        one.contentSize = CGSize(width: one.frame.width, height:UIScreen.main.bounds.width/3+100)
        loadSongByArtistViews(view: one)
        let titleContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/3+70))
        titleContainer.backgroundColor = Constants.color_background
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3))
        var decodedImage = url.replacingOccurrences(of: "%3A", with: ":")
        decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
        image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
        image.center.x = titleContainer.center.x
        image.layer.cornerRadius = 5
        image.layer.cornerRadius = (UIScreen.main.bounds.width/3)/2
        image.clipsToBounds = true
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: image.frame.height, width: UIScreen.main.bounds.width, height: 20))
        lblTitle.text = name
        lblTitle.textColor = UIColor.white
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont(name: "Roboto", size: 14.0)
        
        let albums = UILabel(frame: CGRect(x: 0, y: lblTitle.frame.height+image.frame.height, width: UIScreen.main.bounds.width/2-10, height: 20))
        albums.text = album
        albums.textColor = UIColor.gray
        albums.textAlignment = .right
        albums.font = UIFont(name: "Roboto", size: 11.0)
        
        //let songs = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2+10, y: lblTitle.frame.height+image.frame.height, width: UIScreen.main.bounds.width/2-10, height: 20))
        let songs = UILabel(frame: CGRect(x: 0, y: lblTitle.frame.height+image.frame.height, width: UIScreen.main.bounds.width, height: 20))
        songs.textAlignment = .center
        songs.text = song
        songs.textColor = UIColor.gray
        songs.font = UIFont(name: "Roboto", size: 11.0)
        
        let labelAddArtist = UILabel()
        labelAddArtist.frame = CGRect(x: 0, y: lblTitle.frame.height+image.frame.height+albums.frame.height+5, width: 70, height:20)
        labelAddArtist.center.x = titleContainer.center.x
        labelAddArtist.text = "Add".localizedString
        labelAddArtist.textAlignment = .center
        labelAddArtist.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelAddArtist.layer.cornerRadius = 10
        labelAddArtist.textColor = UIColor.white
        labelAddArtist.layer.masksToBounds = true
        labelAddArtist.backgroundColor = Constants.color_brand
        let tap2 = PlaylistPlayGesture(target: self, action: #selector(buttonClickedAddArtistToLibrary))
        tap2.id = id
        labelAddArtist.isUserInteractionEnabled = true
        labelAddArtist.addGestureRecognizer(tap2)
        
        titleContainer.addSubview(image)
        titleContainer.addSubview(lblTitle)
        titleContainer.addSubview(albums)
        titleContainer.addSubview(songs)
        titleContainer.addSubview(labelAddArtist)
        
        let labelAlbum = UILabel()
        labelAlbum.frame = CGRect(x: 10, y: titleContainer.frame.height, width: UIScreen.main.bounds.width-10, height:40)
        labelAlbum.text = "Album"
        labelAlbum.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelAlbum.textColor = UIColor.white
        //labelAlbum.backgroundColor = UIColor.green
        
        let labelAlbumByArtistSeeAll = UILabel()
        labelAlbumByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10, width: 70, height:20)
        labelAlbumByArtistSeeAll.text = "ViewAll".localizedString
        labelAlbumByArtistSeeAll.textAlignment = .center
        labelAlbumByArtistSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelAlbumByArtistSeeAll.layer.cornerRadius = 10
        labelAlbumByArtistSeeAll.textColor = UIColor.white
        labelAlbumByArtistSeeAll.layer.masksToBounds = true
        labelAlbumByArtistSeeAll.backgroundColor = Constants.color_brand
        
        //loadAlbumByArtistList()
        two.addSubview(titleContainer)
        //two.addSubview(labelAlbum)
        //two.addSubview(labelAlbumByArtistSeeAll)
        
        //loadAlbumByArtistViews(view: one)
        
        let labelSong = UILabel()
        //labelSong.frame = CGRect(x: 10, y: titleContainer.frame.height+UIScreen.main.bounds.width/2+50, width: UIScreen.main.bounds.width-10, height:40)
        
        labelSong.frame = CGRect(x: 10, y: titleContainer.frame.height, width: UIScreen.main.bounds.width-10, height:40)
        
        labelSong.text = "Song".localizedString
        labelSong.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSong.textColor = UIColor.white
        //labelSong.backgroundColor = UIColor.green
        
        let labelSongByArtistSeeAll = UILabel()
        //labelSongByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10+UIScreen.main.bounds.width/2+50, width: 70, height:20)
        labelSongByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10, width: 70, height:20)
        labelSongByArtistSeeAll.text = "ViewAll".localizedString
        labelSongByArtistSeeAll.textAlignment = .center
        labelSongByArtistSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongByArtistSeeAll.layer.cornerRadius = 10
        labelSongByArtistSeeAll.textColor = UIColor.white
        labelSongByArtistSeeAll.layer.masksToBounds = true
        labelSongByArtistSeeAll.backgroundColor = Constants.color_brand
        let tap = PlaylistPlayGesture(target: self, action: #selector(buttonClickedSeeAllArtistBySongs))
        tap.id = id
        labelSongByArtistSeeAll.isUserInteractionEnabled = true
        labelSongByArtistSeeAll.addGestureRecognizer(tap)
        
        
        
        two.addSubview(labelSong)
        two.addSubview(labelSongByArtistSeeAll)
        
        //loadPopularArtistSongsList(id: id)
        
        viewBrowseArtist.addSubview(one)
        
        self.addSubview(viewBrowseArtist)
        //scrollView.addSubview(vi)
        
        
    }
    
    @objc func buttonClickedAddArtistToLibrary(recognizer: PlaylistPlayGesture) {
        addToLibrary(key: "A", songs: recognizer.id)
    }
    
    @objc func buttonClickedSeeAllArtistBySongs(recognizer: PlaylistPlayGesture) {
        createPopularArtistSongsView(view: viewAllPopularArtistSongs, title: "Song".localizedString)
        loadAllPopularArtistSongsList(id: recognizer.id)
    }
    
    func loadSongByArtistViews(view: UIView) {
        
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width/3+110, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width-40)*1/3+30))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        scrollCollectionMinimizedSongsByArtist = ScrollCollection(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionMinimizedSongsByArtist?.styleType = 1
        scrollCollectionMinimizedSongsByArtist?.playerView = self.playerView
        songsViewContent.addSubview(scrollCollectionMinimizedSongsByArtist!)
        
        viewGenreSongs.addSubview(songsViewContent)
        
        view.addSubview(viewGenreSongs)
        
    }
    
    @objc func goArtistButtonClicked(sender:UIButton) {
        viewBrowseArtist.isHidden = true
    }
    
    @objc func buttonClickedArtist(recognizer: MyTapGesture) {
        self.loadPopularArtistSongsList(id: recognizer.id)
        self.createArtistDetails(id: recognizer.id, name: recognizer.aname, url: recognizer.url, album: "", song: String(recognizer.songs)+" Songs")
    }
    
    func loadHomePopularArtistsList(view: UIView) {
        self.homeDataModel.getHomePopularArtists(getHomePopularArtistsListCallFinished: { (status, error, userInfo) in
            if status {
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.homeDataModel.popularArtistsList.chunked(into: 10)
                    self.artistList = self.homeDataModel.popularArtistsList.count > 10 ? minimizedArray[0] : self.homeDataModel.popularArtistsList
                    
                    self.loadHomePopularArtistsViews(view: view)
                    self.createArtistSeeAllView(view: self.viewAllPopularArtists, title: "Popular Artists")
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    //Latest Playlist Header View
    func createPlaylistHeaderView(view: UIView) {
        let topBar = UIView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3+30)*3+190+(UIScreen.main.bounds.width-40)*1/3, width: UIScreen.main.bounds.width, height: 50))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "LastestPlaylist".localizedString
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: topBar.frame.width-80, y: 15, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongsSeeAll.lineBreakMode = .byWordWrapping
        labelSongsSeeAll.numberOfLines = 2
        labelSongsSeeAll.layer.cornerRadius = 10
        labelSongsSeeAll.textColor = UIColor.white
        labelSongsSeeAll.layer.masksToBounds = true
        labelSongsSeeAll.backgroundColor = Constants.color_brand
        let tap = HomeTapGesture(target: self, action: #selector(buttonClickedSeeAllPlaylist))
        tap.lname = "Latest Playlist"
        labelSongsSeeAll.isUserInteractionEnabled = true
        labelSongsSeeAll.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAll)
        view.addSubview(topBar)
    }
    
    
    func createRadioDramaHeaderView(view: UIView) {
        let topBar = UIView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3+30)*3+440+(UIScreen.main.bounds.width-40)*1/3, width: UIScreen.main.bounds.width, height: 50))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "Radio Drama".localizedString
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: topBar.frame.width-80, y: 15, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongsSeeAll.lineBreakMode = .byWordWrapping
        labelSongsSeeAll.numberOfLines = 2
        labelSongsSeeAll.layer.cornerRadius = 10
        labelSongsSeeAll.textColor = UIColor.white
        labelSongsSeeAll.layer.masksToBounds = true
        labelSongsSeeAll.backgroundColor = Constants.color_brand
        let tap = HomeTapGesture(target: self, action: #selector(buttonClickedSeeAllRadioDrama))
        tap.lname = "Radio Drama"
        labelSongsSeeAll.isUserInteractionEnabled = true
        labelSongsSeeAll.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAll)
        view.addSubview(topBar)
    }
    
    var globalPlayLists = [GlobalPlaylistItem](){
        didSet{
            let scrollPlayList = UIScrollView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3+30)*3+240+(UIScreen.main.bounds.width-40)*1/3, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.width/2-10))
            scrollPlayList.showsHorizontalScrollIndicator = false
            scrollPlayList.showsVerticalScrollIndicator = false
            let playListContentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(globalPlayLists.count)*(UIScreen.main.bounds.width/2-20)+10, height: scrollPlayList.frame.height))
            scrollPlayList.addSubview(playListContentView)
            scrollPlayList.contentSize = CGSize(width: CGFloat(globalPlayLists.count)*(UIScreen.main.bounds.width/2-20)+10, height: scrollPlayList.frame.height)
            
            var xLength: CGFloat = 10
            for (index, tileData) in globalPlayLists.enumerated(){
                let playListTile = PlayListTile(frame: CGRect(x: xLength, y: 0, width: UIScreen.main.bounds.width/2-30, height: UIScreen.main.bounds.width/2-30))
                playListTile.lblTitle.text = tileData.name
                
                var decodedImage: String = ""
                decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
                
                if decodedImage == "" || decodedImage == "https://storage.googleapis.com/kiki_images/live/playlist/"  || decodedImage == "https://storage.googleapis.com/kiki_images/live/playlist/null" {
                    playListTile.imageURL = ""
                } else {
                    playListTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                }
                playListTile.index = index
                xLength += UIScreen.main.bounds.width/2-30+10
                
                let dateArr = tileData.date!.components(separatedBy: "-")
                
                let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickedPlaylistDetails))
                tap.id = String(tileData.id)
                tap.image = decodedImage
                tap.title = tileData.name
                tap.songs = String(tileData.number_of_songs)
                tap.year =  dateArr[0]
                playListTile.isUserInteractionEnabled = true
                playListTile.addGestureRecognizer(tap)
                
                playListContentView.addSubview(playListTile)
            }
            
            scrollView.addSubview(scrollPlayList)
        }
    }
    
    var radioDramas = [GlobalPlaylistItem](){
        didSet{
            let scrollPlayList = UIScrollView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3+30)*3+490+(UIScreen.main.bounds.width-40)*1/3, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.width/2-10))
            scrollPlayList.showsHorizontalScrollIndicator = false
            scrollPlayList.showsVerticalScrollIndicator = false
            let playListContentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(globalPlayLists.count)*(UIScreen.main.bounds.width/2-20)+10, height: scrollPlayList.frame.height))
            scrollPlayList.addSubview(playListContentView)
            scrollPlayList.contentSize = CGSize(width: CGFloat(globalPlayLists.count)*(UIScreen.main.bounds.width/2-20)+10, height: scrollPlayList.frame.height)
            
            var xLength: CGFloat = 10
            for (index, tileData) in radioDramas.enumerated(){
                let playListTile = PlayListTile(frame: CGRect(x: xLength, y: 0, width: UIScreen.main.bounds.width/2-30, height: UIScreen.main.bounds.width/2-30))
                playListTile.lblTitle.text = tileData.name
                
                var decodedImage: String = ""
                decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
                
                if decodedImage == "" || decodedImage == "https://storage.googleapis.com/kiki_images/live/playlist/"  || decodedImage == "https://storage.googleapis.com/kiki_images/live/playlist/null" {
                    playListTile.imageURL = ""
                } else {
                    playListTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                }
                playListTile.index = index
                xLength += UIScreen.main.bounds.width/2-30+10
                
                let dateArr = tileData.date!.components(separatedBy: "-")
                
                let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickedPlaylistDetails))
                tap.id = String(tileData.id)
                tap.image = decodedImage
                tap.title = tileData.name
                tap.songs = String(tileData.number_of_songs)
                tap.year =  dateArr[0]
                playListTile.isUserInteractionEnabled = true
                playListTile.addGestureRecognizer(tap)
                
                playListContentView.addSubview(playListTile)
            }
            
            scrollView.addSubview(scrollPlayList)
        }
    }
    
    
    
    @objc func buttonClickedPlaylistDetails(recognizer: PlaylistTapGesture) {
        print("Printer ", recognizer.id," ", recognizer.title," ", recognizer.image)
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        loadAllLatestPlaylistSongsList(id: recognizer.id, url: recognizer.image, title: recognizer.title, songs_count: recognizer.songs, date: recognizer.year)
        
    }
    
    var globalPlayListsAll = [GlobalPlaylistItem](){
        didSet{
            let scrollPlayList = UIScrollView(frame: CGRect(x: 10, y: 40, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-40))
            
            scrollPlayList.showsHorizontalScrollIndicator = false
            scrollPlayList.showsVerticalScrollIndicator = false
            
            let playListContentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollPlayList.frame.width, height: CGFloat(globalPlayListsAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(globalPlayListsAll.count)*20)+290))
            
            scrollPlayList.addSubview(playListContentView)
            
            scrollPlayList.contentSize = CGSize(width: scrollPlayList.frame.width, height: CGFloat(globalPlayListsAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(globalPlayListsAll.count)*20)+290)
            
            var xLength: CGFloat = 10
            
            for (index, tileData) in globalPlayListsAll.enumerated(){
                let playListTile = PlayListTileAll(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
                playListTile.lblTitle.text = tileData.name
                
                var decodedImage: String = ""
                decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
                
                if decodedImage == "" || decodedImage == "https://storage.googleapis.com/kiki_images/live/playlist/"  || decodedImage == "https://storage.googleapis.com/kiki_images/live/playlist/null" {
                    playListTile.imageURL = ""
                } else {
                    //playListTile.imageURL = decodedImage
                    playListTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                }
                
                playListTile.index = index
                playListTile.songs.text = String(tileData.number_of_songs)+" songs"
                
                let dateArr = tileData.date!.components(separatedBy: "-")
                playListTile.year.text = dateArr[0]
                
                let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickedPlaylistDetails))
                tap.id = String(tileData.id)
                tap.image = decodedImage
                tap.title = tileData.name
                tap.songs = String(tileData.number_of_songs)
                tap.year =  dateArr[0]
                playListTile.isUserInteractionEnabled = true
                playListTile.addGestureRecognizer(tap)
                
                let tapAdd = PlaylistPlayGesture(target: self, action: #selector(buttonClickedAddPlaylistToLibrary))
                tapAdd.id = tileData.id
                playListTile.add.isUserInteractionEnabled = true
                playListTile.add.addGestureRecognizer(tapAdd)
                
                xLength += UIScreen.main.bounds.width/6+20
                
                playListContentView.addSubview(playListTile)
            }
            viewAllLatestPlaylists.addSubview(scrollPlayList)
        }
    }
    
    
    var radioDramaAll = [GlobalPlaylistItem](){
        didSet{
            let scrollPlayList = UIScrollView(frame: CGRect(x: 10, y: 40, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-40))
            
            scrollPlayList.showsHorizontalScrollIndicator = false
            scrollPlayList.showsVerticalScrollIndicator = false
            
            let playListContentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollPlayList.frame.width, height: CGFloat(globalPlayListsAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(globalPlayListsAll.count)*20)+440))
            
            scrollPlayList.addSubview(playListContentView)
            
            scrollPlayList.contentSize = CGSize(width: scrollPlayList.frame.width, height: CGFloat(globalPlayListsAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(globalPlayListsAll.count)*20)+290)
            
            var xLength: CGFloat = 10
            
            for (index, tileData) in radioDramaAll.enumerated(){
                let playListTile = PlayListTileAll(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
                playListTile.lblTitle.text = tileData.name
                
                var decodedImage: String = ""
                decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
                
                if decodedImage == "" || decodedImage == "https://storage.googleapis.com/kiki_images/live/playlist/"  || decodedImage == "https://storage.googleapis.com/kiki_images/live/playlist/null" {
                    playListTile.imageURL = ""
                } else {
                    //playListTile.imageURL = decodedImage
                    playListTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                }
                
                playListTile.index = index
                playListTile.songs.text = String(tileData.number_of_songs)+" songs"
                
                let dateArr = tileData.date!.components(separatedBy: "-")
                playListTile.year.text = dateArr[0]
                
                let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickedPlaylistDetails))
                tap.id = String(tileData.id)
                tap.image = decodedImage
                tap.title = tileData.name
                tap.songs = String(tileData.number_of_songs)
                tap.year =  dateArr[0]
                playListTile.isUserInteractionEnabled = true
                playListTile.addGestureRecognizer(tap)
                
                let tapAdd = PlaylistPlayGesture(target: self, action: #selector(buttonClickedAddPlaylistToLibrary))
                tapAdd.id = tileData.id
                playListTile.add.isUserInteractionEnabled = true
                playListTile.add.addGestureRecognizer(tapAdd)
                
                xLength += UIScreen.main.bounds.width/6+20
                
                playListContentView.addSubview(playListTile)
            }
            viewAllRadioDrama.addSubview(scrollPlayList)
        }
    }
    
    
    /*var globalPlayListsAll = [GlobalPlaylistItem](){
     didSet{
     
     let scrollPlayListAll = UIScrollView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3+30)*3+240+(UIScreen.main.bounds.width-40)*1/3, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.width/2-10))
     
     let playListContentViewAll = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(globalPlayListsAll.count)*(UIScreen.main.bounds.width/2-20)+10, height: scrollPlayListAll.frame.height))
     
     scrollPlayListAll.addSubview(playListContentViewAll)
     
     scrollPlayListAll.contentSize = CGSize(width: CGFloat(globalPlayListsAll.count)*(UIScreen.main.bounds.width/2-20)+10, height: scrollPlayListAll.frame.height)
     
     var xLength: CGFloat = 10
     
     
     for (index, tileData) in globalPlayListsAll.enumerated(){
     let playListTile = PlayListTile(frame: CGRect(x: xLength, y: 0, width: UIScreen.main.bounds.width/2-30, height: UIScreen.main.bounds.width/2-30))
     playListTile.lblTitle.text = tileData.name
     playListTile.imageURL = tileData.image!
     playListTile.index = index
     
     xLength += UIScreen.main.bounds.width/2-30+10
     //playListTile.btnPlay!.addTarget(self, action: #selector(self.actPlayList(_:)), for: UIControl.Event.touchUpInside)
     playListContentViewAll.addSubview(playListTile)
     }
     
     viewAllLatestPlaylists.addSubview(scrollPlayListAll)
     
     }
     }*/
    
    func loadPlaylists() {
        
        self.homeDataModel.getPlaylists(getGlobalPlaylistCallFinished: { (status, error, userInfo) in
            if status {
                //self.parentVC.home?.
                let minimizedArray = self.homeDataModel.globalPlaylists.chunked(into: 10)
                self.globalPlayLists = self.homeDataModel.globalPlaylists.count > 10 ? minimizedArray[0] : self.homeDataModel.globalPlaylists
                
                //self.globalPlayLists = self.homeDataModel.globalPlaylists
                //self.parentVC.home?.
                self.globalPlayListsAll = self.homeDataModel.globalPlaylists
                
                
                //self.parentVC.home?.globalPlayListsAll = self.homeDataModel.globalPlaylists
            }
        })
    }
    
    func loadRadioDrama() {
        
        self.homeDataModel.getRadioDrama(getGlobalPlaylistCallFinished: { (status, error, userInfo) in
            if status {
                //self.parentVC.home?.
                let minimizedArray = self.homeDataModel.radioDramas.chunked(into: 10)
                self.radioDramas = self.homeDataModel.radioDramas.count > 10 ? minimizedArray[0] : self.homeDataModel.radioDramas
                
                
                //self.globalPlayLists = self.homeDataModel.globalPlaylists
                //self.parentVC.home?.
                self.radioDramaAll = self.homeDataModel.radioDramas
                
                //self.parentVC.home?.globalPlayListsAll = self.homeDataModel.globalPlaylists
            }
        })
    }
    
    @objc func buttonClickedSeeAllPopularSongs(recognizer: HomeTapGesture) {
        
        /*if(sender.tag == 5){
         
         var abc = "argOne" //Do something for tag 5
         }
         print("hello")*/
        //createSongsSeeAllView(view: viewAllSongs, title: recognizer.lname)
        
        viewAllPopularSongs.isHidden = false
        //
    }
    
    @objc func buttonClickedSeeAllLatestSongs(recognizer: HomeTapGesture) {
        
        /*if(sender.tag == 5){
         
         var abc = "argOne" //Do something for tag 5
         }
         print("hello")*/
        //createSongsSeeAllView(view: viewAllSongs, title: recognizer.lname)
        
        viewAllLatestSongs.isHidden = false
        //
    }
    
    @objc func buttonClickedSeeAllArtist(recognizer: HomeTapGesture) {
        
        viewAllPopularArtists.isHidden = false
    }
    
    @objc func buttonClickedSeeAllPlaylist(recognizer: HomeTapGesture) {
        
        viewAllLatestPlaylists.isHidden = false
    }
    
    @objc func buttonClickedSeeAllRadioDrama(recognizer: HomeTapGesture) {
        
        viewAllRadioDrama.isHidden = false
    }
    
    func createPopularSongsSeeAllView(view: UIView, title: String) {
        
        viewAllPopularSongs = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        viewAllPopularSongs.backgroundColor = Constants.color_background
        
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(viewAllSongsButtonClicked), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        label.text = String(title)
        label.textColor =  UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(label)
        
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-40))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        scrollCollectionExapndedPopularSongs = ScrollCollection(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionExapndedPopularSongs?.styleType = 13
        songsViewContent.addSubview(scrollCollectionExapndedPopularSongs!)
        
        viewGenreSongs.addSubview(songsViewContent)
        
        view.addSubview(viewGenreSongs)
        
        viewAllPopularSongs.addSubview(topBar)
        viewAllPopularSongs.addSubview(viewGenreSongs)
        
    }
    
    func createLatestSongsSeeAllView(view: UIView, title: String) {
        
        viewAllLatestSongs = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        viewAllLatestSongs.backgroundColor = Constants.color_background
        
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(viewAllSongsButtonClicked), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        label.text = String(title)
        label.textColor =  UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(label)
        
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-40))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        scrollCollectionExapndedLatestSinhalaSongs = ScrollCollection(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionExapndedLatestSinhalaSongs?.styleType = 132
        songsViewContent.addSubview(scrollCollectionExapndedLatestSinhalaSongs!)
        
        viewGenreSongs.addSubview(songsViewContent)
        view.addSubview(viewGenreSongs)
        
        viewAllLatestSongs.addSubview(topBar)
        viewAllLatestSongs.addSubview(viewGenreSongs)
        
    }
    
    func createPopularArtistSongsView(view: UIView, title: String) {
        
        viewAllPopularArtistSongs = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        viewAllPopularArtistSongs.backgroundColor = Constants.color_background
        
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(viewAllSongsButtonClicked), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        label.text = String(title)
        label.textColor =  UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(label)
        
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-40))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        viewGenreSongs.addSubview(songsViewContent)
        
        scrollCollectionExapndedSongsByArtist = ScrollCollection(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionExapndedSongsByArtist?.styleType = 13
        songsViewContent.addSubview(scrollCollectionExapndedSongsByArtist!)
        
        
        viewAllPopularArtistSongs.addSubview(viewGenreSongs)
        
        viewAllPopularArtistSongs.addSubview(topBar)
        viewAllPopularArtistSongs.addSubview(viewGenreSongs)
        //viewAllPopularArtistSongs.isHidden = true
        self.addSubview(viewAllPopularArtistSongs)
        //
    }
    
    func loadPopularArtistSongsList(id: Int) {
        
        self.homeDataModel.getHomePopularArtistSongs(id: id, getHomePopularArtistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.homeDataModel.popularArtistSongsList.chunked(into: 10)
                    self.scrollCollectionMinimizedSongsByArtist?.currentPlayingList = self.homeDataModel.popularArtistSongsList.count > 10 ? minimizedArray[0] : self.homeDataModel.popularArtistSongsList
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func loadAllPopularArtistSongsList(id: Int) {
        self.homeDataModel.getHomePopularArtistSongs(id: id, getHomePopularArtistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.scrollCollectionExapndedSongsByArtist?.currentPlayingList = self.homeDataModel.popularArtistSongsList
                    
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    
    func createLatestPlaylistSeeAllView(view: UIView, title: String) {
        
        viewAllLatestPlaylists = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        viewAllLatestPlaylists.backgroundColor = Constants.color_background
        
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(viewAllSongsButtonClicked), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        label.text = String(title)
        label.textColor =  UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(label)
        
        
        viewAllLatestPlaylists.addSubview(topBar)
        
    }
    
    func createRadioDramaSeeAllView(view: UIView, title: String) {
        
        viewAllRadioDrama = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        viewAllRadioDrama.backgroundColor = Constants.color_background
        
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(viewAllSongsButtonClicked), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        label.text = String(title)
        label.textColor =  UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(label)
        
        
        viewAllRadioDrama.addSubview(topBar)
        
    }
    
    
    @objc func viewAllSongsButtonClicked(sender: UIButton) {
        viewAllPopularSongs.isHidden = true
        viewAllLatestSongs.isHidden = true
        viewAllPopularArtists.isHidden = true
        viewAllLatestPlaylists.isHidden = true
        viewAllRadioDrama.isHidden = true
        viewAllPopularArtistSongs.isHidden = true
    }
    
    /*func loadAllPopularSongsList() {
     self.homeDataModel.getHomePopularSongs(getHomePopularSongsListCallFinished: { (status, error, userInfo) in
     if status{
     DispatchQueue.main.async(execute: {
     self.scrollCollectionExapndedPopularSongs?.currentPlayingList = self.homeDataModel.popularSongsList
     })
     } else {
     DispatchQueue.main.async(execute: {})
     }
     })
     }
     
     func loadAllLatestSongsList() {
     self.homeDataModel.getHomeLatestSongs(getHomeLatestSongsListCallFinished: { (status, error, userInfo) in
     if status{
     DispatchQueue.main.async(execute: {
     self.scrollCollectionExapndedLatestSinhalaSongs?.currentPlayingList = self.homeDataModel.latestSongsList
     })
     } else {
     DispatchQueue.main.async(execute: {})
     }
     })
     }
     
     func loadAllPopularArtistsList() {
     self.homeDataModel.getPopularSongs(getPopularSongsListCallFinished: { (status, error, userInfo) in
     if status{
     DispatchQueue.main.async(execute: {
     self.scrollCollectionExapndedPopularArtists?.currentPlayingList = self.homeDataModel.popularSongsList
     //self.parentVC.playerView.artistList = self.homeDataModel.popularSongsList
     //self.allSongs = self.allSongsModel.allSongsList
     //self.currentShowingSongs = self.allSongsModel.allSongsList
     })
     } else {
     DispatchQueue.main.async(execute: {})
     }
     })
     }*/
    
    func loadAllLatestPlaylistSongsList(id: String, url: String, title: String, songs_count: String, date: String) {
        
        self.homeDataModel.getLatestPlaylistSongs(id: id, getHomeLatestPlaylistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    //self.scrollCollectionExapndedLatestPlaylistSongs?.currentPlayingList = self.homeDataModel.latestPlaylistSongsList
                    self.latestPlayList = self.homeDataModel.latestPlaylistSongsList
                    
                    self.createPlaylistDetails(id: id, url: url, title: title, songs_count: songs_count, date: date)
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    var currentPlayingListId = ""
    func createPlaylistDetails(id: String, url: String, title: String, songs_count: String, date: String) {
        currentPlayingListId = ""
        viewLatestPlaylistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewLatestPlaylistDetails.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4+90+40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(goPlaylistButtonClicked), for: .touchUpInside)
        topBar.addSubview(arrow)
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: arrow.frame.height+20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4+90))
        titleContainer.backgroundColor = Constants.color_background
        
        titleContainer.isUserInteractionEnabled = true
        var image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4))
        
        let img : UIImage = UIImage(named:"logo_grayscale")!
        image = UIImageView(image: img)
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4)
        
        var decodedImage = url.replacingOccurrences(of: "%3A", with: ":")
        decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
        image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
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
        let  textAfterIcon = NSMutableAttributedString(string: "Play".localizedString)
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
        labelAddSong.text = "Add".localizedString
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
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height, width: self.frame.width, height: self.frame.height))
        one.showsVerticalScrollIndicator = false
        one.showsHorizontalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height: CGFloat(latestPlayList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(latestPlayList.count)*20)+370+UIScreen.main.bounds.width/3+40))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height:CGFloat(latestPlayList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(latestPlayList.count)*20)+370+UIScreen.main.bounds.width/4+40)
        
        one.isUserInteractionEnabled = true
        two.isUserInteractionEnabled = true
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in latestPlayList.enumerated(){
            let songTile = PlayListSongsTileAll(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblDescription.text = tileData.artist
            songTile.lblTitle.text = tileData.name
            
            var decodedImage: String = ""
            decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            songTile.styleType = self.styleType
            
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
        
        self.addSubview(viewLatestPlaylistDetails)
    }
    
    @objc func buttonClickedPlaylistSongPlay(recognizer: PlaylistPlayGesture) {
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            self.parentVC.playerView?.radioStatus = "song"
            self.parentVC.playerView.pause()
            self.parentVC.playerView.currentPlayingList = latestPlayList
            self.parentVC.playerView.currentPlayingIndex = recognizer.id
            self.parentVC.playerView.currentPlayingTime = 0
            self.parentVC.playerView.scrollCollection.changeSong(index: recognizer.id)
            self.parentVC.playerView.play()
        }
    }
    
    @objc func buttonClickedPlaylistPlay(recognizer: PlaylistPlayGesture) {
        loadSongsOfGlobalPlaylistGlobal(listID: recognizer.id)
    }
    
    @objc func buttonClickedAddPlaylistToLibrary(recognizer: PlaylistPlayGesture) {
        addToLibrary(key: "P", songs: recognizer.id)
    }
    
    let playlistModel = PlaylistModel()
    func loadSongsOfGlobalPlaylistGlobal(listID:Int) {
        
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            /*self.playlistModel.getSongsOfPlaylistGlobal(listID: listID, getSongsOfPlaylistCallFinished:{ (status, error, songs) in
             if (status) {
             if (songs == nil || (songs?.isEmpty)!) {
             let alert = UIAlertController(title: "Kiki", message: "No Songs Availabale", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.parentVC!.present(alert, animated: true, completion: nil)
             } else {
             self.parentVC.playerView.pause()
             self.parentVC.playerView.currentPlayingList = songs!
             self.parentVC.playerView.currentPlayingTime = 0
             self.parentVC.playerView.play()
             }
             } else {
             let alert = UIAlertController(title: "Kiki", message: "Unexpected error occured", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.parentVC!.present(alert, animated: true, completion: nil)
             }
             })*/
            self.parentVC.playerView?.radioStatus = "song"
            if currentPlayingListId != String(listID) {
                currentPlayingListId = String(listID)
                self.parentVC.playerView.pause()
                self.parentVC.playerView.currentPlayingList = latestPlayList
                self.parentVC.playerView.currentPlayingTime = 0
                self.parentVC.playerView.play()
            }
        }
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
    
    @objc func goPlaylistButtonClicked(sender:UIButton) {
        viewLatestPlaylistDetails.isHidden = true
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
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension UIImageView{
    func getDataHome(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImageHome(from url: URL) {
        getDataHome(from: url) { data, response, error in
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
