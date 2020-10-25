//
//  HomeController.swift
//  SusilaMobile
//
//  Created by Kiroshan on 3/5/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Kingfisher

class LibraryController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate {
    
    // MARK: - Properties
    var homeDataModel = HomeDataModel()
    var libraryDataModel = LibraryDataModel()
    var playlistModel = PlaylistModel()
    var playerView: PlayerView!
    var parentVC: DashboardViewController!
    
    var libraryArtistsList:[Artist] = [Artist]()
    var libraryArtistsListAll:[Artist] = [Artist]()
    var libraryPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var libraryAllPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var libraryKiKiPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var libraryKiKiAllPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var UserPlaylistSongs: [Song] = [Song]()
    var tempPlaylistSongs: [Song] = [Song]()
    var returnPlaylistData: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var allPlaylist: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var allPlaylistSeeAll: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var allSong: [Song] = [Song]()
    var allSongSeeAll: [Song] = [Song]()
    var allArtist: [Artist] = [Artist]()
    var allArtistSeeAll: [Artist] = [Artist]()
    var allArtistSongs: [Song] = [Song]()
    var allArtistSongsSeeAll: [Song] = [Song]()
    var playlistDetailsSongs: [Song] = [Song]()
    var arry:[Int] = []
    //var songArray:[Int] = []
    
    var image = UIImageView()
    var playlistImage = UIImage()
    var imgGlobal=""
    var newPlaylist = UITextField()
    var edit = UIButton()
    var done = UIButton()
    var playlistStatus = false
    var noSongLabel = UILabel()
    var noArtistLabel = UILabel()
    var noPlaylistLabel = UILabel()
    var globalImage = UIImage(named:"play")
    var editStatus = false
    var editImage = ""
    
    var songCount = 0
    var artistCount = 0
    var kikiPlaylistCount = 0
    var userPlaylistCount = 0
    var playlistYear = ""
    
    // MARK: - Views
    var scrollView = UIScrollView(frame: CGRect.zero)
    var librarySongsSeeAllView = UIView(frame: CGRect.zero)
    var viewLibrarySongs = UIView(frame: CGRect.zero)
    var libraryArtistsView = UIScrollView(frame: CGRect.zero)
    var libraryArtistsSeeAllView = UIView(frame: CGRect.zero)
    var viewAllLibraryArtistDetails = UIView(frame: CGRect.zero)
    var viewAllBrowseArtistSongs = UIView(frame: CGRect.zero)
    var viewAllSongs = UIView(frame: CGRect.zero)
    var viewLibraryPlaylists = UIScrollView(frame: CGRect.zero)
    var viewAllLibraryPlaylists = UIView(frame: CGRect.zero)
    var viewUserPlaylistDetails = UIView(frame: CGRect.zero)
    var createPlaylistView = UIView(frame: CGRect.zero)
    var viewSelectPlaylistDetails = UIView(frame: CGRect.zero)
    var createSelectSongsView = UIView(frame: CGRect.zero)
    var viewAllSelectSongs = UIView(frame: CGRect.zero)
    var viewAllSelectArtists = UIView(frame: CGRect.zero)
    var viewAllSelectPlaylists = UIView(frame: CGRect.zero)
    var viewSelectArtistDetails = UIView(frame: CGRect.zero)
    var viewAllSelectArtistDetails = UIView(frame: CGRect.zero)
    var libraryUserPlaylistView = UIScrollView(frame: CGRect.zero)
    var libraryUserPlaylistSeeAllView = UIScrollView(frame: CGRect.zero)
    
    // MARK: - Sub views
    var scrollCollectionLibrarySongs:ScrollCollectionBrowse?
    var scrollCollectionExapndedLibrarySongs:ScrollCollectionBrowse?
    
    var scrollCollectionMinimizedSongsByArtist:ScrollCollection?
    var scrollCollectionExapndedSongsByArtist:ScrollCollection?
    
    var confirmAlertDialog = ConfirmAlertDialog()
    var addToPlaylistAlertDialog = AddToPlaylistAlertDialog()
    var overLayView = UIView(frame: UIScreen.main.bounds)
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.color_background
        
        scrollCollectionLibrarySongs?.playerView = playerView
        scrollCollectionExapndedLibrarySongs?.playerView = playerView
        
        scrollCollectionMinimizedSongsByArtist?.playerView = playerView
        scrollCollectionExapndedSongsByArtist?.playerView = playerView
        
        initViews(view: view) // init main view
        
        createLibrarySongHeaderView(view: scrollView) // Library songs header view
        createLibrarySongFrontView(view: scrollView) // Library songs front view
        createLibrarySongSeeAllView(view: view, title: "Song".localizedString) // Library songs see all view
        loadLibrarySongList() //Load songs for Library
        
        createLibraryArtistHeaderView(view: scrollView) // Library artist header view
        loadLibraryArtistsList(view: scrollView)  //Load artists for Library
        
        createKiKiPlaylistHeaderView(view: scrollView) // Library kiki playlist header view
        loadLibraryKiKiPlaylistsList() //Load kiki playlist for Library
        
        createUserPlaylistHeaderView(view: scrollView) // Library user playlist header view
        loadLibraryUserPlaylistsList() //Load user playlist for Library
        
        overLayView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        confirmAlertDialog = ConfirmAlertDialog(frame: getCenteredFrameForOverlay(130))
        confirmAlertDialog.isHidden = true
        confirmAlertDialog.layer.zPosition = 1002
        
        let tapYes = GenreTapGesture(target: self, action: #selector(buttonClick_Yes))
        confirmAlertDialog.btnYes.isUserInteractionEnabled = true
        confirmAlertDialog.btnYes.addGestureRecognizer(tapYes)
        
        let tapNo = PlaylistPlayGesture(target: self, action: #selector(buttonClick_No))
        confirmAlertDialog.btnNo.isUserInteractionEnabled = true
        confirmAlertDialog.btnNo.addGestureRecognizer(tapNo)
        
        addToPlaylistAlertDialog = AddToPlaylistAlertDialog(frame: getCenteredFrameForOverlay2(300))
        addToPlaylistAlertDialog.isHidden = true
        addToPlaylistAlertDialog.layer.zPosition = 2002
        addToPlaylistAlertDialog.btnCancel.addTarget(self, action: #selector(cancelClickAddToPlaylistAlertDialog), for: .touchUpInside)
        
        view.addSubview(confirmAlertDialog)
        view.addSubview(addToPlaylistAlertDialog)
    }
    
    func getCenteredFrameForOverlay(_ height: CGFloat) -> CGRect {
        return CGRect(x: UIScreen.main.bounds.width/4, y: (UIScreen.main.bounds.height - 250 - height)/2, width: UIScreen.main.bounds.width/2 , height: height)
    }
    
    func getCenteredFrameForOverlay2(_ height: CGFloat) -> CGRect {
        return CGRect(x: 15, y: (UIScreen.main.bounds.height - 250 - height)/2, width: UIScreen.main.bounds.width - 30 , height: height)
    }
    
    @objc func cancelClickAddToPlaylistAlertDialog(sender:PlaylistTapGesture) {
        addToPlaylistAlertDialog.isHidden = true
        addToPlaylistAlertDialog.removeFromSuperview()
    }
    
    var libraryAllPlaylist: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    func loadPlaylistsList() {
        self.libraryDataModel.getPlaylists(getPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async {
                    self.libraryAllPlaylist = self.libraryDataModel.playlists
                    if self.libraryAllPlaylist.count < 1 {
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
        uiAlert = UIView(frame: CGRect(x: 0, y: 0, width: self.addToPlaylistAlertDialog.scrollList.frame.width, height: CGFloat(libraryAllPlaylist.count)*(UIScreen.main.bounds.width/6)+CGFloat(libraryAllPlaylist.count)*20))
        
        var xLength: CGFloat = 0
        for (_, tileData) in libraryAllPlaylist.enumerated(){
            
            
            let songTile = PlaylistTileAlertAllPlaylist(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickAddSongToPlaylist))
            tap.id = String(tileData.id)
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            xLength += UIScreen.main.bounds.width/6+20
            uiAlert.addSubview(songTile)
        }
        view.addSubview(uiAlert)
        
        self.addToPlaylistAlertDialog.scrollList.contentSize = CGSize(width: self.addToPlaylistAlertDialog.scrollList.frame.width, height: CGFloat(libraryAllPlaylist.count)*(UIScreen.main.bounds.width/6)+CGFloat(libraryAllPlaylist.count)*20)
    }
    
    @objc func buttonClickAddSongToPlaylist(recognizer: PlaylistTapGesture) {
        print("PlaylistId ", recognizer.id," SongId ", addToPlaylistAlertDialog.id)
        var songsid = [String]()
        songsid.append(String(addToPlaylistAlertDialog.id))
        addSongToPlaylist(playlistId: recognizer.id, songs: songsid)
        self.alert(message: "AddedToPlayList".localizedString)
        self.addToPlaylistAlertDialog.isHidden = true
        self.addToPlaylistAlertDialog.removeFromSuperview()
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
    
    @objc func buttonClick_Yes(sender:GenreTapGesture) {
        if confirmAlertDialog.key=="A" {
            removeFromLibrary(key: confirmAlertDialog.key, id: confirmAlertDialog.id)
        } else if (confirmAlertDialog.key=="P") {
            removeFromLibrary(key: confirmAlertDialog.key, id: confirmAlertDialog.id)
        } else {
            removePlaylistFromLibrary(id: confirmAlertDialog.id)
        }
    }
    
    @objc func buttonClick_No(sender:PlaylistPlayGesture) {
        confirmAlertDialog.isHidden = true
        confirmAlertDialog.removeFromSuperview()
        overLayView.removeFromSuperview()
    }
    
    func showConfirmAlertDialog(title: String, id: Int, key: String) {
        overLayView.removeFromSuperview()
        view.addSubview(overLayView)
        view.addSubview(confirmAlertDialog)
        confirmAlertDialog.lblTitle.text = title
        confirmAlertDialog.id = id
        confirmAlertDialog.key = key
        confirmAlertDialog.isHidden = false
    }
    
    // MARK: - Init views
    func initViews(view: UIView) {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-200))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: ((UIScreen.main.bounds.width-40)*1/3)*2+260+UIScreen.main.bounds.width+30)
    }
    
    
    // MARK: - Create views
    // Library song view header
    var labelSongsSeeAllSong = UILabel()
    func createLibrarySongHeaderView(view: UIView) {
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "Song".localizedString
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        
        labelSongsSeeAllSong.frame = CGRect(x: topBar.frame.width-80, y: 10, width: 70, height:20)
        labelSongsSeeAllSong.text = "ViewAll".localizedString
        labelSongsSeeAllSong.textAlignment = .center
        labelSongsSeeAllSong.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongsSeeAllSong.layer.cornerRadius = 10
        labelSongsSeeAllSong.textColor = UIColor.white
        labelSongsSeeAllSong.layer.masksToBounds = true
        labelSongsSeeAllSong.backgroundColor = Constants.color_brand
        let tap = LibraryTapGesture(target: self, action: #selector(buttonClickSeeAllLibrarySongs))
        labelSongsSeeAllSong.isUserInteractionEnabled = true
        labelSongsSeeAllSong.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAllSong)
        view.addSubview(topBar)
    }
    
    //Library songs view front
    func createLibrarySongFrontView(view: UIView) {
        viewLibrarySongs.removeFromSuperview()
        viewLibrarySongs = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width , height: (UIScreen.main.bounds.width-40)*1/3+30))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewLibrarySongs.frame.width, height: viewLibrarySongs.frame.height))
        
        viewLibrarySongs.addSubview(songsViewContent)
        noSongLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: (UIScreen.main.bounds.width-40)*1/3+30))
        noSongLabel.textAlignment = .center
        noSongLabel.textColor = .white
        noSongLabel.text = "NoSongsAddedToLibrary".localizedString
        viewLibrarySongs.addSubview(noSongLabel)
        noSongLabel.isHidden = true
        
        scrollCollectionLibrarySongs = ScrollCollectionBrowse(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionLibrarySongs?.styleType = 15
        scrollCollectionLibrarySongs?.playerView = playerView
        songsViewContent.addSubview(scrollCollectionLibrarySongs!)
        view.addSubview(viewLibrarySongs)
    }
    
    //Library songs view see all
    func createLibrarySongSeeAllView(view: UIView, title: String) {
        librarySongsSeeAllView.removeFromSuperview()
        librarySongsSeeAllView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height))
        librarySongsSeeAllView.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClickBackLibrarySongsSeeAllView), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        label.text = String(title)
        label.textColor =  UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(label)
        
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-40))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        scrollCollectionExapndedLibrarySongs = ScrollCollectionBrowse(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionExapndedLibrarySongs?.styleType = 20
        scrollCollectionExapndedLibrarySongs?.playerView = playerView
        songsViewContent.addSubview(scrollCollectionExapndedLibrarySongs!)
        
        viewGenreSongs.addSubview(songsViewContent)
        view.addSubview(viewGenreSongs)
        
        librarySongsSeeAllView.addSubview(topBar)
        librarySongsSeeAllView.addSubview(viewGenreSongs)
        
        view.addSubview(librarySongsSeeAllView)
        librarySongsSeeAllView.isHidden = true
    }
    
    //Library artists view header
    var labelSongsSeeAllArtist = UILabel()
    func createLibraryArtistHeaderView(view: UIView) {
        let topBar = UIView(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width-40)*1/3+70, width: UIScreen.main.bounds.width, height: 40))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "Artist".localizedString
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        
        labelSongsSeeAllArtist.frame = CGRect(x: topBar.frame.width-80, y: 10, width: 70, height:20)
        labelSongsSeeAllArtist.text = "ViewAll".localizedString
        labelSongsSeeAllArtist.textAlignment = .center
        labelSongsSeeAllArtist.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongsSeeAllArtist.layer.cornerRadius = 10
        labelSongsSeeAllArtist.textColor = UIColor.white
        labelSongsSeeAllArtist.layer.masksToBounds = true
        labelSongsSeeAllArtist.backgroundColor = Constants.color_brand
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonClickSeeAllLibraryArtists))
        labelSongsSeeAllArtist.isUserInteractionEnabled = true
        labelSongsSeeAllArtist.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAllArtist)
        view.addSubview(topBar)
    }
    
    //Library artists view front
    func createLibraryArtistFrontView(view: UIView) {
        libraryArtistsView.removeFromSuperview()
        libraryArtistsView = UIScrollView(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width-40)*1/3+110, width: UIScreen.main.bounds.width , height: (UIScreen.main.bounds.width-40)*1/3+10))
        libraryArtistsView.showsHorizontalScrollIndicator = false
        libraryArtistsView.showsVerticalScrollIndicator = false
        
        let artistContent = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(libraryArtistsList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: libraryArtistsView.frame.height))
        libraryArtistsView.addSubview(artistContent)
        
        noArtistLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: artistContent.frame.height))
        noArtistLabel.textAlignment = .center
        noArtistLabel.text = "NoArtistAddedToLibrary".localizedString
        noArtistLabel.textColor = .white
        artistContent.addSubview(noArtistLabel)
        if libraryArtistsList.count>0 {
            self.noArtistLabel.isHidden=true
        }
        
        libraryArtistsView.contentSize = CGSize(width: CGFloat(libraryArtistsList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: libraryArtistsView.frame.height)
        
        var xLength: CGFloat = 10
        for (index, tileData) in libraryArtistsList.enumerated(){
            
            let songTile = SongTileLibraryArtists(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedOnArtist))
            tap.id = tileData.id
            tap.aname = tileData.name
            tap.url = decodedImage
            tap.songs = tileData.songsCount!
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            xLength += ((UIScreen.main.bounds.width-40)*1/3)
            artistContent.addSubview(songTile)
        }
        view.addSubview(libraryArtistsView)
    }
    
    //Library artists view see all
    func createLibraryArtistSeeAllView(view: UIView, title: String) {
        libraryArtistsSeeAllView.removeFromSuperview()
        libraryArtistsSeeAllView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height))
        libraryArtistsSeeAllView.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClickBackLibraryArtistsSeeAllView), for: .touchUpInside)
        
        let text = UILabel(frame: CGRect(x: 40, y: 10, width: 100, height: 20))
        text.text = title
        text.textColor = UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(text)
        libraryArtistsSeeAllView.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: view.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:  CGFloat(libraryArtistsListAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(libraryArtistsListAll.count)*20)+340))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height: CGFloat(libraryArtistsListAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(libraryArtistsListAll.count)*20)+340)
        
        var xLength: CGFloat = 10
        
        for (_, tileData) in libraryArtistsListAll.enumerated(){
            let songTile = SongTileLibraryAllArtists(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblTitle.text = tileData.name
            songTile.image.sd_setImage(with: URL(string: tileData.image!), placeholderImage: UIImage(named: "logo_grayscale"))
            if tileData.songsCount! > 0 {
                songTile.albums.text = String(tileData.songsCount!)+" songs"
            }
            if tileData.numberOfAlbums! > 0 {
                //songTile.albums.text = String (tileData.numberOfAlbums!)+" albums"
            }
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedOnArtist))
            tap.id = tileData.id
            tap.aname = tileData.name
            tap.url = tileData.image!
            tap.songs = tileData.songsCount!
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            let tapRemove = GenreTapGesture(target: self, action: #selector(buttonClickedRemoveArtistFromLibrary))
            tapRemove.id = String(tileData.id)
            tapRemove.title = tileData.name
            songTile.remove.isUserInteractionEnabled = true
            songTile.remove.addGestureRecognizer(tapRemove)
            
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        libraryArtistsSeeAllView.addSubview(one)
        view.addSubview(libraryArtistsSeeAllView)
    }
    
    //Library artists details view
    func createLibraryArtistDetails(id: Int, name: String, url: String, album: String, song: String) {
        
        viewAllLibraryArtistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewAllLibraryArtistDetails.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(backButtonClickLibraryArtistDetails), for: .touchUpInside)
        
        topBar.addSubview(arrow)
        viewAllLibraryArtistDetails.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height, width: viewAllLibraryArtistDetails.frame.width , height: view.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:420+UIScreen.main.bounds.width/3+UIScreen.main.bounds.width/2+10+UIScreen.main.bounds.width*1/3))
        one.addSubview(two)
        
        one.contentSize = CGSize(width: one.frame.width, height:UIScreen.main.bounds.width/3+100)
        
        createLibrarySongByArtistFrontView(view: one)
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/3+40))
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
        
        titleContainer.addSubview(image)
        titleContainer.addSubview(lblTitle)
        titleContainer.addSubview(albums)
        titleContainer.addSubview(songs)
        
        let labelAlbum = UILabel()
        labelAlbum.frame = CGRect(x: 10, y: titleContainer.frame.height, width: UIScreen.main.bounds.width-10, height:40)
        labelAlbum.text = "Album"
        labelAlbum.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelAlbum.textColor = UIColor.white
        
        let labelAlbumByArtistSeeAll = UILabel()
        labelAlbumByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10, width: 70, height:20)
        labelAlbumByArtistSeeAll.text = "ViewAll".localizedString
        labelAlbumByArtistSeeAll.textAlignment = .center
        labelAlbumByArtistSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelAlbumByArtistSeeAll.layer.cornerRadius = 10
        labelAlbumByArtistSeeAll.textColor = UIColor.white
        labelAlbumByArtistSeeAll.layer.masksToBounds = true
        labelAlbumByArtistSeeAll.backgroundColor = Constants.color_brand
        
        two.addSubview(titleContainer)
        let labelSong = UILabel()
        labelSong.frame = CGRect(x: 10, y: titleContainer.frame.height, width: UIScreen.main.bounds.width-10, height:40)
        
        labelSong.text = "Song".localizedString
        labelSong.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSong.textColor = UIColor.white
        
        let labelSongByArtistSeeAll = UILabel()
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
        viewAllLibraryArtistDetails.addSubview(one)
        view.addSubview(viewAllLibraryArtistDetails)
    }
    
    //Library song by artist view front
    func createLibrarySongByArtistFrontView(view: UIView) {
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width/3+80, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width-40)*1/3+30))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        scrollCollectionMinimizedSongsByArtist = ScrollCollection(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionMinimizedSongsByArtist?.styleType = 1
        scrollCollectionMinimizedSongsByArtist?.playerView = self.playerView
        songsViewContent.addSubview(scrollCollectionMinimizedSongsByArtist!)
        
        viewGenreSongs.addSubview(songsViewContent)
        view.addSubview(viewGenreSongs)
    }
    
    //Library song by artist view see all
    func createLibrarySongByArtistSeeAllView(view: UIView, title: String) {
        
        viewAllBrowseArtistSongs = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height))
        viewAllBrowseArtistSongs.backgroundColor = Constants.color_background
        
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
        scrollCollectionExapndedSongsByArtist?.styleType = 15
        scrollCollectionExapndedSongsByArtist?.playerView = self.playerView
        songsViewContent.addSubview(scrollCollectionExapndedSongsByArtist!)
        
        viewAllBrowseArtistSongs.addSubview(viewGenreSongs)
        viewAllBrowseArtistSongs.addSubview(topBar)
        viewAllBrowseArtistSongs.addSubview(viewGenreSongs)
        view.addSubview(viewAllBrowseArtistSongs)
    }
    
    //Library kiki playlist view header
    var labelSongsSeeAllKikiPlaylist = UILabel()
    func createKiKiPlaylistHeaderView(view: UIView) {
        let topBar = UIView(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width-40)*1/3+(UIScreen.main.bounds.width-40)*1/3+120, width: UIScreen.main.bounds.width, height: 40))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "KikiPlaylist".localizedString
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        
        labelSongsSeeAllKikiPlaylist.frame = CGRect(x: topBar.frame.width-80, y: 10, width: 70, height:20)
        labelSongsSeeAllKikiPlaylist.text = "ViewAll".localizedString
        labelSongsSeeAllKikiPlaylist.textAlignment = .center
        labelSongsSeeAllKikiPlaylist.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongsSeeAllKikiPlaylist.layer.cornerRadius = 10
        labelSongsSeeAllKikiPlaylist.textColor = UIColor.white
        labelSongsSeeAllKikiPlaylist.layer.masksToBounds = true
        labelSongsSeeAllKikiPlaylist.backgroundColor = Constants.color_brand
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonClickSeeAllLibraryKiKiPlaylists))
        labelSongsSeeAllKikiPlaylist.isUserInteractionEnabled = true
        labelSongsSeeAllKikiPlaylist.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAllKikiPlaylist)
        view.addSubview(topBar)
    }
    
    //Library kiki playlist view front
    func createKiKiPlaylistFrontView(view: UIView) {
        viewLibraryPlaylists.removeFromSuperview()
        viewLibraryPlaylists = UIScrollView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3)*2+160, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width/2))
        viewLibraryPlaylists.showsHorizontalScrollIndicator = false
        viewLibraryPlaylists.showsVerticalScrollIndicator = false
        
        let playlistContent = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(self.libraryKiKiPlaylists.count)*(UIScreen.main.bounds.width/2-30)+(CGFloat(self.libraryKiKiPlaylists.count)*10)+10, height: UIScreen.main.bounds.width/2))
        viewLibraryPlaylists.addSubview(playlistContent)
        
        noPlaylistLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: playlistContent.frame.height))
        noPlaylistLabel.textAlignment = .center
        noPlaylistLabel.text = "NoPlayListAddedToLibrary".localizedString
        playlistContent.addSubview(noPlaylistLabel)
        noPlaylistLabel.textColor = .white
        if libraryKiKiPlaylists.count>0 {
            self.noPlaylistLabel.isHidden = true
        }
        
        viewLibraryPlaylists.contentSize = CGSize(width: CGFloat(libraryKiKiPlaylists.count)*(UIScreen.main.bounds.width/2-30)+(CGFloat(libraryKiKiPlaylists.count)*10)+10, height: viewLibraryPlaylists.frame.height)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in libraryKiKiPlaylists.enumerated(){
            let songTile = SongTileLibraryPlaylist(frame: CGRect(x: xLength, y: 0, width: UIScreen.main.bounds.width/2-30, height: UIScreen.main.bounds.width/2-30))
            songTile.lblTitle.text = tileData.name
            songTile.index = index
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            
            xLength += UIScreen.main.bounds.width/2-30+10
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickLibraryKiKiPlaylist))
            tap.id = String(tileData.id)
            tap.image = decodedImage
            tap.title = tileData.name
            tap.songs = String(tileData.number_of_songs)
            
            let dateArr = tileData.date!.components(separatedBy: "-")
            tap.year =  dateArr[0]
            
            songTile.image.isUserInteractionEnabled = true
            songTile.image.addGestureRecognizer(tap)
            
            playlistContent.addSubview(songTile)
        }
        view.addSubview(viewLibraryPlaylists)
    }
    
    //Library kiki playlist view see all
    func createKiKiPlaylistSeeAllViews(view: UIView, title: String) {
        viewAllLibraryPlaylists.removeFromSuperview()
        viewAllLibraryPlaylists = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height))
        viewAllLibraryPlaylists.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClickBackLibraryKiKiPlaylistSeeAllView), for: .touchUpInside)
        
        let text = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        text.text = title
        text.textColor = UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(text)
        viewAllLibraryPlaylists.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: view.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:  CGFloat(libraryKiKiAllPlaylists.count)*(UIScreen.main.bounds.width/6)+(CGFloat(libraryKiKiAllPlaylists.count)*20)+360))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height: CGFloat(libraryKiKiAllPlaylists.count)*(UIScreen.main.bounds.width/6)+(CGFloat(libraryKiKiAllPlaylists.count)*20)+360)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in libraryKiKiAllPlaylists.enumerated(){
            let songTile = SongTileLibraryAllPlaylist(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            
            songTile.lblTitle.text = tileData.name
            songTile.index = index
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.songs.text = String(tileData.number_of_songs)+" songs"
            let dateArr = tileData.date!.components(separatedBy: "-")
            songTile.year.text = dateArr[0]
            
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickLibraryKiKiPlaylist))
            tap.id = String(tileData.id)
            tap.title = tileData.name
            tap.songs = String(tileData.number_of_songs)
            tap.year =  dateArr[0]
            tap.image = decodedImage
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            let tapRemove = GenreTapGesture(target: self, action: #selector(buttonClickedRemovePlaylistFromLibrary))
            tapRemove.id = String(tileData.id)
            tapRemove.title = tileData.name
            songTile.remove.isUserInteractionEnabled = true
            songTile.remove.addGestureRecognizer(tapRemove)
            
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        viewAllLibraryPlaylists.addSubview(one)
        view.addSubview(viewAllLibraryPlaylists)
    }
    
    var currentPlayingListId = ""
    //Library kiki playlist details view
    func createKiKiPlaylistDetailsView(id: String, url: String, title: String, songs_count: String, date: String) {
        currentPlayingListId = ""
        viewUserPlaylistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewUserPlaylistDetails.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClickBackLibraryViewAllUserPlaylistsDetails), for: .touchUpInside)
        topBar.addSubview(arrow)
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4+90))
        titleContainer.backgroundColor = Constants.color_background
        titleContainer.isUserInteractionEnabled = true
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height+titleContainer.frame.height, width: view.frame.width, height: view.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height: CGFloat(UserPlaylistSongs.count)*(UIScreen.main.bounds.width/6)+(CGFloat(UserPlaylistSongs.count)*20)+370+UIScreen.main.bounds.width/3+40))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height:CGFloat(UserPlaylistSongs.count)*(UIScreen.main.bounds.width/6)+(CGFloat(UserPlaylistSongs.count)*20)+370+UIScreen.main.bounds.width/3+40)
        one.isUserInteractionEnabled = true
        two.isUserInteractionEnabled = true
        
        var image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4))
        let img : UIImage = UIImage(named:"logo_grayscale")!
        image = UIImageView(image: img)
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4)
        
        if url != "" {
            var decodedImage = url.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
        }
        
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
        labelPlaySong.frame = CGRect(x: 0, y: lblTitle.frame.height+image.frame.height+songs.frame.height+10, width: 70, height:20)
        
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
        
        labelPlaySong.center.x = titleContainer.center.x
        labelPlaySong.textAlignment = .center
        labelPlaySong.font = UIFont(name: "Roboto", size: 13.0)
        labelPlaySong.layer.cornerRadius = 10
        labelPlaySong.textColor = UIColor.white
        labelPlaySong.layer.masksToBounds = true
        labelPlaySong.backgroundColor = Constants.color_brand
        let tap = PlaylistPlayGesture(target: self, action: #selector(buttonClickedLibraryKiKiPlaylistPlay))
        tap.id = Int(id)!
        labelPlaySong.isUserInteractionEnabled = true
        labelPlaySong.addGestureRecognizer(tap)
        
        let labelAddSong = UILabel()
        labelAddSong.frame = CGRect(x: UIScreen.main.bounds.width/2+5, y: lblTitle.frame.height+image.frame.height+songs.frame.height+10, width: 70, height:20)
        labelAddSong.text = "Add".localizedString
        labelAddSong.textAlignment = .center
        labelAddSong.font = UIFont(name: "Roboto-Bold", size: 9.0)
        labelAddSong.layer.cornerRadius = 10
        labelAddSong.textColor = UIColor.white
        labelAddSong.layer.masksToBounds = true
        labelAddSong.backgroundColor = Constants.color_brand
        
        titleContainer.addSubview(image)
        titleContainer.addSubview(lblTitle)
        titleContainer.addSubview(songs)
        titleContainer.addSubview(year)
        titleContainer.addSubview(labelPlaySong)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in UserPlaylistSongs.enumerated(){
            let songTile = SongTileLibraryListSquareSongsAdd(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblDescription.text = tileData.artist
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            let tapPlay = PlaylistPlayGesture(target: self, action: #selector(buttonClickedPlaylistSongPlay))
            tapPlay.id = index
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tapPlay)
            
            let tapAdd = PlaylistTapGesture(target: self, action: #selector(buttonClick_AddSongToPlaylist))
            tapAdd.id = String(tileData.id)
            songTile.add.isUserInteractionEnabled = true
            songTile.add.addGestureRecognizer(tapAdd)
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        
        viewUserPlaylistDetails.addSubview(topBar)
        viewUserPlaylistDetails.addSubview(titleContainer)
        viewUserPlaylistDetails.addSubview(one)
        view.addSubview(viewUserPlaylistDetails)
    }
    
    @objc func buttonClick_AddSongToPlaylist(sender:PlaylistTapGesture) {
        loadPlaylistsList()
        showAddToPlaylistAlertDialog(title: "Select Playlist", id: Int(sender.id)!)
    }
    
    func showAddToPlaylistAlertDialog(title: String, id: Int) {
        view.addSubview(addToPlaylistAlertDialog)
        addToPlaylistAlertDialog.id = id
        addToPlaylistAlertDialog.isHidden = false
    }
    
    //Library user playlist view header
    var labelSongsSeeAllUserPlaylist = UILabel()
    func createUserPlaylistHeaderView(view: UIView) {
        let topBar = UIView(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width-40)*1/3+(UIScreen.main.bounds.width-40)*1/3+150+UIScreen.main.bounds.width/2, width: UIScreen.main.bounds.width, height: 40))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "YourPlaylist".localizedString
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        
        labelSongsSeeAllUserPlaylist.frame = CGRect(x: topBar.frame.width-80, y: 10, width: 70, height:20)
        labelSongsSeeAllUserPlaylist.text = "ViewAll".localizedString
        labelSongsSeeAllUserPlaylist.textAlignment = .center
        labelSongsSeeAllUserPlaylist.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongsSeeAllUserPlaylist.layer.cornerRadius = 10
        labelSongsSeeAllUserPlaylist.textColor = UIColor.white
        labelSongsSeeAllUserPlaylist.layer.masksToBounds = true
        labelSongsSeeAllUserPlaylist.backgroundColor = Constants.color_brand
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonClickSeeAllLibraryUserPlaylists))
        labelSongsSeeAllUserPlaylist.isUserInteractionEnabled = true
        labelSongsSeeAllUserPlaylist.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAllUserPlaylist)
        view.addSubview(topBar)
    }
    
    //Library user playlist view front
    func createUserPlaylistFrontView(view: UIView) {
        libraryUserPlaylistView.removeFromSuperview()
        libraryUserPlaylistView = UIScrollView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3)*2+190+UIScreen.main.bounds.width/2, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width/2))
        libraryUserPlaylistView.showsHorizontalScrollIndicator = false
        libraryUserPlaylistView.showsVerticalScrollIndicator = false
        
        let playlistContent = UIView(frame: CGRect(x: 0, y: 0, width: (CGFloat(self.libraryPlaylists.count)+1)*(UIScreen.main.bounds.width/2-30)+(CGFloat(self.libraryPlaylists.count)*10)+20, height: UIScreen.main.bounds.width/2))
        libraryUserPlaylistView.addSubview(playlistContent)
        
        let b_image = UIImage(named: "plus-green") as UIImage?
        let plusButton = UIButton()
        plusButton.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width/2-30, height:UIScreen.main.bounds.width/2-30)
        plusButton.setImage(b_image, for: .normal)
        plusButton.contentVerticalAlignment = .fill
        plusButton.contentHorizontalAlignment = .fill
        plusButton.imageEdgeInsets = UIEdgeInsets(top: (UIScreen.main.bounds.width/2)/3, left: (UIScreen.main.bounds.width/2)/3, bottom: (UIScreen.main.bounds.width/2)/3, right: (UIScreen.main.bounds.width/2)/3)
        plusButton.layer.cornerRadius = 5
        plusButton.backgroundColor = .darkGray
        plusButton.addTarget(self, action: #selector(buttonClickedPlaylistPlus), for: .touchUpInside)
        
        playlistContent.addSubview(plusButton)
        
        libraryUserPlaylistView.contentSize = CGSize(width: (CGFloat(libraryPlaylists.count)+1)*(UIScreen.main.bounds.width/2-30)+(CGFloat(libraryPlaylists.count)*10)+20, height: libraryUserPlaylistView.frame.height)
        
        var xLength: CGFloat = UIScreen.main.bounds.width/2-30+20
        
        for (index, tileData) in libraryPlaylists.enumerated(){
            let songTile = SongTileLibraryPlaylist(frame: CGRect(x: xLength, y: 0, width: UIScreen.main.bounds.width/2-30, height: UIScreen.main.bounds.width/2-30))
            songTile.lblTitle.text = tileData.name
            songTile.index = index
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            
            xLength += UIScreen.main.bounds.width/2-30+10
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickLibraryPlaylist))
            tap.id = String(tileData.id)
            tap.image = decodedImage
            tap.title = tileData.name
            tap.songs = String(tileData.number_of_songs)
            let dateArr = tileData.date!.components(separatedBy: "-")
            tap.year =  dateArr[0]
            
            songTile.image.isUserInteractionEnabled = true
            songTile.image.addGestureRecognizer(tap)
            
            playlistContent.addSubview(songTile)
        }
        view.addSubview(libraryUserPlaylistView)
    }
    
    //Library user playlist view see all
    func createUserPlaylistSeeAllViews(view: UIView, title: String) {
        viewAllLibraryPlaylists.removeFromSuperview()
        viewAllLibraryPlaylists = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height))
        viewAllLibraryPlaylists.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClickBackLibraryUserPlaylistSeeAllView), for: .touchUpInside)
        
        let text = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        text.text = title
        text.textColor = UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(text)
        viewAllLibraryPlaylists.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: view.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:  CGFloat(libraryAllPlaylists.count)*(UIScreen.main.bounds.width/6)+(CGFloat(libraryAllPlaylists.count)*20)+360+UIScreen.main.bounds.width/6))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height: CGFloat(libraryAllPlaylists.count)*(UIScreen.main.bounds.width/6)+(CGFloat(libraryAllPlaylists.count)*20)+360+UIScreen.main.bounds.width/6)
        
        let b_image = UIImage(named: "plus-green") as UIImage?
        let plusButton = UIButton()
        plusButton.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.width/6)
        plusButton.setImage(b_image, for: .normal)
        plusButton.contentVerticalAlignment = .fill
        plusButton.contentHorizontalAlignment = .fill
        plusButton.imageEdgeInsets = UIEdgeInsets(top: (UIScreen.main.bounds.width/6)/3, left: (UIScreen.main.bounds.width/6)/3, bottom: (UIScreen.main.bounds.width/6)/3, right: (UIScreen.main.bounds.width/6)/3)
        plusButton.layer.cornerRadius = 5
        plusButton.backgroundColor = .darkGray
        plusButton.addTarget(self, action: #selector(buttonClickedPlaylistPlus), for: .touchUpInside)
        two.addSubview(plusButton)
        
        let addMorePlaylist = UILabel()
        addMorePlaylist.frame = CGRect(x: UIScreen.main.bounds.width/6+10, y: 10, width: UIScreen.main.bounds.width-UIScreen.main.bounds.width/6+10, height: UIScreen.main.bounds.width/6)
        addMorePlaylist.text = "CREATE_NEW_PLAYLIST".localizedString
        addMorePlaylist.font = UIFont.boldSystemFont(ofSize: 14)
        addMorePlaylist.textColor = Constants.color_brand
        two.addSubview(addMorePlaylist)
        
        let line = UIView(frame: CGRect(x: 0, y: plusButton.frame.height+20, width: UIScreen.main.bounds.width-20 , height: 0.5))
        line.backgroundColor = UIColor.gray
        two.addSubview(line)
        
        var xLength: CGFloat = 30+UIScreen.main.bounds.width/6
        
        for (index, tileData) in libraryAllPlaylists.enumerated(){
            let songTile = SongTileLibraryAllPlaylist(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblTitle.text = tileData.name
            songTile.index = index
            
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            
            let dateArr = tileData.date!.components(separatedBy: "-")
            songTile.year.text = dateArr[0]
            songTile.songs.text = String(tileData.number_of_songs)+" songs"
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickLibraryPlaylist))
            tap.id = String(tileData.id)
            tap.image = decodedImage
            tap.title = tileData.name
            tap.songs = String(tileData.number_of_songs)
            tap.year =  dateArr[0]
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            let tapRemove = GenreTapGesture(target: self, action: #selector(buttonClickedRemoveUserPlaylistFromLibrary))
            tapRemove.title = tileData.name
            tapRemove.id = String(tileData.id)
            songTile.remove.isUserInteractionEnabled = true
            songTile.remove.addGestureRecognizer(tapRemove)
            
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        viewAllLibraryPlaylists.addSubview(one)
        view.addSubview(viewAllLibraryPlaylists)
    }
    
    //Library user playlist details view
    func createUserPlaylistDetailsView(id: String, url: String, title: String, songs_count: String, date: String) {
        viewUserPlaylistDetails.removeFromSuperview()
        currentPlayingListId = ""
        viewUserPlaylistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewUserPlaylistDetails.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClickBackLibraryViewAllUserPlaylistsDetails), for: .touchUpInside)
        topBar.addSubview(arrow)
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4+90))
        titleContainer.backgroundColor = Constants.color_background
        titleContainer.isUserInteractionEnabled = true
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height+titleContainer.frame.height, width: view.frame.width, height: view.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height: CGFloat(UserPlaylistSongs.count)*(UIScreen.main.bounds.width/6)+(CGFloat(UserPlaylistSongs.count)*20)+370+UIScreen.main.bounds.width/3+40))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height:CGFloat(UserPlaylistSongs.count)*(UIScreen.main.bounds.width/6)+(CGFloat(UserPlaylistSongs.count)*20)+370+UIScreen.main.bounds.width/3+40)
        one.isUserInteractionEnabled = true
        two.isUserInteractionEnabled = true
        
        var image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4))
        let img : UIImage = UIImage(named:"logo_grayscale")!
        image = UIImageView(image: img)
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4)
        
        if url != "" {
            var decodedImage = url.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
        }
        
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
        let tap = PlaylistPlayGesture(target: self, action: #selector(buttonClickedLibraryUserPlaylistPlay))
        tap.id = Int(id)!
        labelPlaySong.isUserInteractionEnabled = true
        labelPlaySong.addGestureRecognizer(tap)
        
        let labelEditList = UILabel()
        labelEditList.frame = CGRect(x: UIScreen.main.bounds.width/2+5, y: lblTitle.frame.height+image.frame.height+songs.frame.height+10, width: 70, height:20)
        
        let imageAttachment2 =  NSTextAttachment()
        imageAttachment2.image = UIImage(named:"pencil")
        let imageOffsetY2:CGFloat = -5.0;
        imageAttachment2.bounds = CGRect(x: 0, y: imageOffsetY2, width: imageAttachment2.image!.size.width, height: imageAttachment2.image!.size.height)
        let attachmentString2 = NSAttributedString(attachment: imageAttachment2)
        let completeText2 = NSMutableAttributedString(string: "")
        completeText2.append(attachmentString2)
        let  textAfterIcon2 = NSMutableAttributedString(string: "Edit".localizedString)
        completeText2.append(textAfterIcon2)
        labelEditList.textAlignment = .center
        labelEditList.attributedText = completeText2
        
        labelEditList.textAlignment = .center
        labelEditList.font = UIFont(name: "Roboto", size: 8.0)
        labelEditList.layer.cornerRadius = 10
        labelEditList.textColor = UIColor.white
        labelEditList.layer.masksToBounds = true
        labelEditList.backgroundColor = Constants.color_brand
        let tap2 = EditPlaylistTapGesture(target: self, action: #selector(buttonClickedLibraryUserPlaylistEdit))
        tap2.pid = Int(id)!
        tap2.title = title
        tap2.image = url
        labelEditList.isUserInteractionEnabled = true
        labelEditList.addGestureRecognizer(tap2)
        
        let labelAddSong = UILabel()
        labelAddSong.frame = CGRect(x: UIScreen.main.bounds.width/2+5, y: lblTitle.frame.height+image.frame.height+songs.frame.height+10, width: 70, height:20)
        labelAddSong.text = "Add".localizedString
        labelAddSong.textAlignment = .center
        labelAddSong.font = UIFont(name: "Roboto-Bold", size: 9.0)
        labelAddSong.layer.cornerRadius = 10
        labelAddSong.textColor = UIColor.white
        labelAddSong.layer.masksToBounds = true
        labelAddSong.backgroundColor = Constants.color_brand
        
        titleContainer.addSubview(image)
        titleContainer.addSubview(lblTitle)
        titleContainer.addSubview(songs)
        titleContainer.addSubview(year)
        titleContainer.addSubview(labelPlaySong)
        titleContainer.addSubview(labelEditList)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in UserPlaylistSongs.enumerated() {
            
            let songTile = SongTileLibraryListSquareSongs(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblDescription.text = tileData.artist
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            let tapPlay = PlaylistPlayGesture(target: self, action: #selector(buttonClickedPlaylistSongPlay))
            tapPlay.id = index
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tapPlay)
            
            if arry.contains(tileData.id) {
                songTile.add.setTitle("Added", for: .normal)
            }
            
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        
        viewUserPlaylistDetails.addSubview(topBar)
        viewUserPlaylistDetails.addSubview(titleContainer)
        viewUserPlaylistDetails.addSubview(one)
        view.addSubview(viewUserPlaylistDetails)
    }
    
    //New Playlist
    func createNewPlaylistView(view: UIView, status: String) {
        createPlaylistView.removeFromSuperview()
        createPlaylistView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height))
        createPlaylistView.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100+UIScreen.main.bounds.width/4))
        
        let cancel = UIButton(frame: CGRect(x: 0, y: 10, width: 90, height: 20))
        cancel.setTitle("CANCEL_BUTTON_TITLE".localizedString, for: .normal)
        cancel.setTitleColor(Constants.color_red, for: .normal)
        cancel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        cancel.addTarget(self, action: #selector(buttonClick_HideCreatedPlaylistView), for: .touchUpInside)
        topBar.addSubview(cancel)
        
        let confirm = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-90, y: 10, width: 75, height: 20))
        confirm.setTitle("Confirm".localizedString, for: .normal)
        confirm.backgroundColor = Constants.color_brand
        confirm.layer.cornerRadius = 10
        confirm.clipsToBounds = true
        confirm.setTitleColor(.white, for: .normal)
        confirm.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        confirm.addTarget(self, action: #selector(buttonClick_ConfirmCreatedPlaylistView), for: .touchUpInside)
        topBar.addSubview(confirm)
        
        let iconContainer = UIButton(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4))
        iconContainer.backgroundColor = .darkGray
        iconContainer.layer.cornerRadius = 5
        iconContainer.center.x = topBar.center.x
        topBar.addSubview(iconContainer)
        
        let img : UIImage = UIImage(named:"camera_icon")!
        print("camera_icon: "+mainInstance.playlistImage)
        if mainInstance.playlistImage == "" {
            image = UIImageView(image: img)
            image.frame = CGRect(x: 0, y: 40+UIScreen.main.bounds.width/15, width: UIScreen.main.bounds.width/10, height: UIScreen.main.bounds.width/10)
        } else {
            image = UIImageView(image: playlistImage)
            image.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4)
        }
        
        image.center.x = topBar.center.x
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickAddImage))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tap)
        topBar.addSubview(image)
        
        newPlaylist.frame = CGRect(x: UIScreen.main.bounds.width/2-60, y: 50+UIScreen.main.bounds.width/4, width: 120, height: 30)
        newPlaylist.textAlignment = .center
        if mainInstance.playlistName == "" {
            newPlaylist.text = "NEW_PLAYLIST".localizedString
        } else {
            newPlaylist.text = mainInstance.playlistName
        }
        
        newPlaylist.font = UIFont.boldSystemFont(ofSize: 14)
        newPlaylist.textColor = .white
        newPlaylist.autocorrectionType = UITextAutocorrectionType.no
        newPlaylist.keyboardType = UIKeyboardType.default
        newPlaylist.returnKeyType = UIReturnKeyType.done
        newPlaylist.clearButtonMode = UITextField.ViewMode.whileEditing
        newPlaylist.isEnabled = false
        newPlaylist.layer.masksToBounds = true
        topBar.addSubview(newPlaylist)
        
        edit = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2+60, y: 50+UIScreen.main.bounds.width/4, width: 110, height: 30))
        edit.setTitle("(" + "Edit".localizedString + ")", for: .normal)
        edit.setTitleColor(Constants.color_brand, for: .normal)
        edit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        edit.addTarget(self, action: #selector(buttonClick_EditPlaylistName), for: .touchUpInside)
        topBar.addSubview(edit)
        
        done = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2+60, y: 50+UIScreen.main.bounds.width/4, width: 60, height: 30))
        done.setTitle("(Done)", for: .normal)
        done.setTitleColor(Constants.color_brand, for: .normal)
        done.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        done.addTarget(self, action: #selector(buttonClick_DonePlaylistName), for: .touchUpInside)
        done.isHidden = true
        topBar.addSubview(done)
        
        let line = UIView(frame: CGRect(x: 10, y: 90+UIScreen.main.bounds.width/4, width: UIScreen.main.bounds.width-20 , height: 0.5))
        line.backgroundColor = UIColor.gray
        topBar.addSubview(line)
        
        let libraryAddSongsScrollView = UIScrollView(frame: CGRect(x: 0, y: 90+UIScreen.main.bounds.width/4, width: UIScreen.main.bounds.width , height: view.frame.height))
        libraryAddSongsScrollView.showsHorizontalScrollIndicator = false
        libraryAddSongsScrollView.showsVerticalScrollIndicator = false
        
        libraryAddSongsScrollView.contentSize = CGSize(width: libraryAddSongsScrollView.frame.width, height:CGFloat(tempPlaylistSongs.count+3)*(UIScreen.main.bounds.width/6)+(CGFloat(tempPlaylistSongs.count)*20)+350)
        
        if status != "" {
            var xLength: CGFloat = 40
            
            for (_, tileData) in tempPlaylistSongs.enumerated() {
                let songTile = SongsTileAddedPlaylistDetails(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
                songTile.lblDescription.text = tileData.description
                songTile.lblTitle.text = tileData.name
                var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                xLength += UIScreen.main.bounds.width/6+20
                songTile.id = tileData.id
                let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickRemoveSongFromPlaylist))
                tap.id = String(tileData.id)
                songTile.add.isUserInteractionEnabled = true
                songTile.add.addGestureRecognizer(tap)
                
                libraryAddSongsScrollView.addSubview(songTile)
            }
        }
        
        let addSongs = UIButton(frame: CGRect(x: 0, y: 10, width: 100, height: 20))
        addSongs.setTitle("+ Add Songs", for: .normal)
        addSongs.center.x = libraryAddSongsScrollView.center.x
        addSongs.backgroundColor = Constants.color_brand
        addSongs.layer.cornerRadius = 10
        addSongs.clipsToBounds = true
        addSongs.setTitleColor(.white, for: .normal)
        addSongs.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 9.0)
        addSongs.addTarget(self, action: #selector(buttonClick_AddSongs), for: .touchUpInside)
        libraryAddSongsScrollView.addSubview(addSongs)
        
        createPlaylistView.addSubview(topBar)
        createPlaylistView.addSubview(libraryAddSongsScrollView)
        view.addSubview(createPlaylistView)
    }
    
    //Edit Playlist
    func createEditPlaylistView(view: UIView, status: String) {
        createPlaylistView.removeFromSuperview()
        createPlaylistView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height))
        createPlaylistView.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100+UIScreen.main.bounds.width/4))
        
        let cancel = UIButton(frame: CGRect(x: 0, y: 10, width: 90, height: 20))
        cancel.setTitle("CANCEL_BUTTON_TITLE".localizedString, for: .normal)
        cancel.setTitleColor(Constants.color_red, for: .normal)
        cancel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        cancel.addTarget(self, action: #selector(buttonClick_HideCreatedPlaylistView), for: .touchUpInside)
        topBar.addSubview(cancel)
        
        let confirm = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-90, y: 10, width: 75, height: 20))
        confirm.setTitle("Confirm".localizedString, for: .normal)
        confirm.backgroundColor = Constants.color_brand
        confirm.layer.cornerRadius = 10
        confirm.clipsToBounds = true
        confirm.setTitleColor(.white, for: .normal)
        confirm.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        confirm.addTarget(self, action: #selector(buttonClick_ConfirmEditPlaylistView), for: .touchUpInside)
        topBar.addSubview(confirm)
        
        let iconContainer = UIButton(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4))
        iconContainer.backgroundColor = .darkGray
        iconContainer.layer.cornerRadius = 5
        iconContainer.center.x = topBar.center.x
        topBar.addSubview(iconContainer)
        
        let img : UIImage = UIImage(named:"camera_icon")!
        
        if mainInstance.playlistImage == "" {
            image = UIImageView(image: img)
            image.frame = CGRect(x: 0, y: 40+UIScreen.main.bounds.width/15, width: UIScreen.main.bounds.width/10, height: UIScreen.main.bounds.width/10)
        } else {
            //image = UIImageView(image: playlistImage)
            print("editImage: "+editImage)
            image.kf.setImage(with: URL(string: editImage)!)
//            image.downloadImageBrowse(from: URL(string: editImage)!)
            image.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4)
        }
        
        image.center.x = topBar.center.x
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickAddImage))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tap)
        topBar.addSubview(image)
        
        newPlaylist.frame = CGRect(x: UIScreen.main.bounds.width/2-60, y: 50+UIScreen.main.bounds.width/4, width: 120, height: 30)
        newPlaylist.textAlignment = .center
        if mainInstance.playlistName == "" {
            newPlaylist.text = "NEW_PLAYLIST".localizedString
        } else {
            newPlaylist.text = mainInstance.playlistName
        }
        
        newPlaylist.font = UIFont.boldSystemFont(ofSize: 14)
        newPlaylist.textColor = .white
        newPlaylist.autocorrectionType = UITextAutocorrectionType.no
        newPlaylist.keyboardType = UIKeyboardType.default
        newPlaylist.returnKeyType = UIReturnKeyType.done
        newPlaylist.clearButtonMode = UITextField.ViewMode.whileEditing
        newPlaylist.isEnabled = false
        newPlaylist.layer.masksToBounds = true
        topBar.addSubview(newPlaylist)
        
        edit = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2+60, y: 50+UIScreen.main.bounds.width/4, width: 110, height: 30))
        edit.setTitle("(" + "Edit".localizedString + ")", for: .normal)
        edit.setTitleColor(Constants.color_brand, for: .normal)
        edit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        edit.addTarget(self, action: #selector(buttonClick_EditPlaylistName), for: .touchUpInside)
        topBar.addSubview(edit)
        
        done = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2+60, y: 50+UIScreen.main.bounds.width/4, width: 60, height: 30))
        done.setTitle("(Done)", for: .normal)
        done.setTitleColor(Constants.color_brand, for: .normal)
        done.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        done.addTarget(self, action: #selector(buttonClick_DonePlaylistName), for: .touchUpInside)
        done.isHidden = true
        topBar.addSubview(done)
        
        let line = UIView(frame: CGRect(x: 10, y: 90+UIScreen.main.bounds.width/4, width: UIScreen.main.bounds.width-20 , height: 0.5))
        line.backgroundColor = UIColor.gray
        topBar.addSubview(line)
        
        let libraryAddSongsScrollView = UIScrollView(frame: CGRect(x: 0, y: 90+UIScreen.main.bounds.width/4, width: UIScreen.main.bounds.width , height: view.frame.height))
        libraryAddSongsScrollView.showsHorizontalScrollIndicator = false
        libraryAddSongsScrollView.showsVerticalScrollIndicator = false
        
        libraryAddSongsScrollView.contentSize = CGSize(width: libraryAddSongsScrollView.frame.width, height:CGFloat(tempPlaylistSongs.count+3)*(UIScreen.main.bounds.width/6)+(CGFloat(tempPlaylistSongs.count)*20)+350)
        
        if status != "" {
            var xLength: CGFloat = 40
            
            for (_, tileData) in tempPlaylistSongs.enumerated() {
                let songTile = SongsTileAddedPlaylistDetails(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
                songTile.lblDescription.text = tileData.description
                songTile.lblTitle.text = tileData.name
                var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                xLength += UIScreen.main.bounds.width/6+20
                songTile.id = tileData.id
                let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickRemoveSongFromPlaylist2))
                tap.id = String(tileData.id)
                songTile.add.isUserInteractionEnabled = true
                songTile.add.addGestureRecognizer(tap)
                
                libraryAddSongsScrollView.addSubview(songTile)
            }
        }
        
        let addSongs = UIButton(frame: CGRect(x: 0, y: 10, width: 100, height: 20))
        addSongs.setTitle("+ Add Songs", for: .normal)
        addSongs.center.x = libraryAddSongsScrollView.center.x
        addSongs.backgroundColor = Constants.color_brand
        addSongs.layer.cornerRadius = 10
        addSongs.clipsToBounds = true
        addSongs.setTitleColor(.white, for: .normal)
        addSongs.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 9.0)
        addSongs.addTarget(self, action: #selector(buttonClick_AddEditSongs), for: .touchUpInside)
        libraryAddSongsScrollView.addSubview(addSongs)
        
        createPlaylistView.addSubview(topBar)
        createPlaylistView.addSubview(libraryAddSongsScrollView)
        view.addSubview(createPlaylistView)
    }
    
    func createSelectSongsView(view: UIView) {
        createSelectSongsView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height))
        createSelectSongsView.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100+UIScreen.main.bounds.width/4))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClick_HideSelectSongsView), for: .touchUpInside)
        topBar.addSubview(arrow)
        
        let confirm = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-90, y: 10, width: 75, height: 20))
        confirm.setTitle("Confirm".localizedString, for: .normal)
        confirm.backgroundColor = Constants.color_brand
        confirm.layer.cornerRadius = 10
        confirm.clipsToBounds = true
        confirm.setTitleColor(.white, for: .normal)
        confirm.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        confirm.addTarget(self, action: #selector(buttonClick_ConfirmPlaylist), for: .touchUpInside)
        topBar.addSubview(confirm)
        
        let selectSongsScrollView = UIScrollView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width , height: view.frame.height))
        selectSongsScrollView.showsHorizontalScrollIndicator = false
        selectSongsScrollView.showsVerticalScrollIndicator = false
        //selectSongsScrollView.backgroundColor = .blue
        
        selectSongsScrollView.contentSize = CGSize(width: selectSongsScrollView.frame.width, height:(UIScreen.main.bounds.width/2)*3+120+((UIScreen.main.bounds.width-40)*1/3-10)+80+(UIScreen.main.bounds.width-40)*1/3)
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56))
        searchBar.placeholder = "Search by Songs, Playlist and Artists"
        searchBar.backgroundColor = .white
        searchBar.tintColor = .gray
        searchBar.barTintColor = Constants.color_transparent
        searchBar.delegate = self
        selectSongsScrollView.addSubview(searchBar)
        
        let labelPlayList = UILabel()
        labelPlayList.frame = CGRect(x: 10, y: 60, width: view.frame.width, height:40)
        labelPlayList.text = "Add Songs from Playlists"
        labelPlayList.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelPlayList.textColor = UIColor.white
        selectSongsScrollView.addSubview(labelPlayList)
        
        let labelPlayListSeeAll = UILabel()
        labelPlayListSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: 70, width: 70, height:20)
        labelPlayListSeeAll.text = "ViewAll".localizedString
        labelPlayListSeeAll.textAlignment = .center
        labelPlayListSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelPlayListSeeAll.layer.cornerRadius = 10
        labelPlayListSeeAll.textColor = UIColor.white
        labelPlayListSeeAll.layer.masksToBounds = true
        labelPlayListSeeAll.backgroundColor = Constants.color_brand
        let tapPlayList = HomeTapGesture(target: self, action: #selector(buttonClickedAddSongsFromPlayLists))
        tapPlayList.lname = "Add Songs from Playlists"
        labelPlayListSeeAll.isUserInteractionEnabled = true
        labelPlayListSeeAll.addGestureRecognizer(tapPlayList)
        selectSongsScrollView.addSubview(labelPlayListSeeAll)
        
        loadAllPlaylists(view: selectSongsScrollView)
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: UIScreen.main.bounds.width/2+100, width: view.frame.width, height:40)
        labelSongs.text = "Add Songs"
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        selectSongsScrollView.addSubview(labelSongs)
        
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: UIScreen.main.bounds.width/2+110, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongsSeeAll.layer.cornerRadius = 10
        labelSongsSeeAll.textColor = UIColor.white
        labelSongsSeeAll.layer.masksToBounds = true
        labelSongsSeeAll.backgroundColor = Constants.color_brand
        let tapSong = HomeTapGesture(target: self, action: #selector(buttonClickedAddSongsFromSongs))
        tapSong.lname = "Add Songs"
        labelSongsSeeAll.isUserInteractionEnabled = true
        labelSongsSeeAll.addGestureRecognizer(tapSong)
        selectSongsScrollView.addSubview(labelSongsSeeAll)
        
        loadAllSongs(view: selectSongsScrollView, offset: 1)
        
        let labelArtists = UILabel()
        labelArtists.frame = CGRect(x: 10, y: UIScreen.main.bounds.width/2+140+((UIScreen.main.bounds.width-40)*1/3-10)+40, width: view.frame.width, height:40)
        labelArtists.text = "Add Songs from Artists"
        labelArtists.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelArtists.textColor = UIColor.white
        selectSongsScrollView.addSubview(labelArtists)
        
        let labelByArtistsSeeAll = UILabel()
        labelByArtistsSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: UIScreen.main.bounds.width/2+150+((UIScreen.main.bounds.width-40)*1/3-10)+40, width: 70, height:20)
        labelByArtistsSeeAll.text = "ViewAll".localizedString
        labelByArtistsSeeAll.textAlignment = .center
        labelByArtistsSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelByArtistsSeeAll.layer.cornerRadius = 10
        labelByArtistsSeeAll.textColor = UIColor.white
        labelByArtistsSeeAll.layer.masksToBounds = true
        labelByArtistsSeeAll.backgroundColor = Constants.color_brand
        let tapArtist = HomeTapGesture(target: self, action: #selector(buttonClickedAddSongsFromArtists))
        tapArtist.lname = "Add Songs from Artists"
        labelByArtistsSeeAll.isUserInteractionEnabled = true
        labelByArtistsSeeAll.addGestureRecognizer(tapArtist)
        selectSongsScrollView.addSubview(labelByArtistsSeeAll)
        
        loadAllArtists(view: selectSongsScrollView)
        
        createSelectSongsView.addSubview(topBar)
        createSelectSongsView.addSubview(selectSongsScrollView)
        view.addSubview(createSelectSongsView)
    }
    
    //All Playlists View
    func loadAllPlaylistViews(view: UIView) {
        
        let viewAllPlaylist = UIScrollView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width/2))
        viewAllPlaylist.showsHorizontalScrollIndicator = false
        viewAllPlaylist.showsVerticalScrollIndicator = false
        
        let allPlaylistContent = UIView(frame: CGRect(x: 0, y: 0, width: (CGFloat(allPlaylist.count))*(UIScreen.main.bounds.width/2-30)+(CGFloat(allPlaylist.count)*10)+20, height: viewAllPlaylist.frame.height))
        
        viewAllPlaylist.addSubview(allPlaylistContent)
        
        viewAllPlaylist.contentSize = CGSize(width: (CGFloat(allPlaylist.count))*(UIScreen.main.bounds.width/2-30)+(CGFloat(allPlaylist.count)*10)+20, height: viewAllPlaylist.frame.height)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in allPlaylist.enumerated(){
            let songTile = SongTileLibraryPlaylist(frame: CGRect(x: xLength, y: 0, width: UIScreen.main.bounds.width/2-30, height: UIScreen.main.bounds.width/2-30))
            songTile.lblTitle.text = tileData.name
            songTile.index = index
            xLength += UIScreen.main.bounds.width/2-30+10
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickedCreateSelectPlaylistDetails))
            tap.id = String(tileData.id)
            
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            tap.image = decodedImage
            tap.title = tileData.name
            tap.songs = String(tileData.number_of_songs)
            
            let dateArr = tileData.date!.components(separatedBy: "-")
            tap.year =  dateArr[0]
            
            songTile.image.isUserInteractionEnabled = true
            songTile.image.addGestureRecognizer(tap)
            
            allPlaylistContent.addSubview(songTile)
        }
        view.addSubview(viewAllPlaylist)
    }
    
    //All Songs View
    func loadAllSongViews(view: UIView) {
        
        let viewAllSongs = UIScrollView(frame: CGRect(x: 0, y: 140+UIScreen.main.bounds.width/2, width: UIScreen.main.bounds.width , height: ((UIScreen.main.bounds.width-40)*1/3-10)+40))
        viewAllSongs.showsHorizontalScrollIndicator = false
        viewAllSongs.showsVerticalScrollIndicator = false
        
        let allSongContent = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(allSong.count) * (view.frame.height-20), height: viewAllSongs.frame.height))
        
        viewAllSongs.addSubview(allSongContent)
        
        viewAllSongs.contentSize = CGSize(width: CGFloat(allSong.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: viewAllSongs.frame.height)
        
        var xLength: CGFloat = 10
        
        for (_, tileData) in allSong.enumerated(){
            let songTile = SongTileSelectSong(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
            songTile.lblDescription.text = tileData.artist
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            xLength += ((UIScreen.main.bounds.width-40)*1/3)
            songTile.id = tileData.id
            allSongContent.addSubview(songTile)
            songTile.unselectText.text = ""
            if arry.contains(tileData.id) || mainInstance.songArray.contains(tileData.id) {
                songTile.backgroundColor = Constants.color_selectedSong
                songTile.unselectText.text = "Added"
            }
        }
        view.addSubview(viewAllSongs)
    }
    
    func loadAllArtistViews(view: UIView) {
        
        let viewAllArtist = UIScrollView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width/2+140+((UIScreen.main.bounds.width-40)*1/3-10)+80, width: UIScreen.main.bounds.width , height: (UIScreen.main.bounds.width-40)*1/3+10))
        viewAllArtist.showsHorizontalScrollIndicator = false
        viewAllArtist.showsVerticalScrollIndicator = false
        
        let allArtistContent = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(allArtist.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: viewAllArtist.frame.height))
        
        viewAllArtist.addSubview(allArtistContent)
        
        viewAllArtist.contentSize = CGSize(width: CGFloat(allArtist.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: viewAllArtist.frame.height)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in allArtist.enumerated(){
            let songTile = SongTileHomeArtists(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
            songTile.lblTitle.text = tileData.name
            songTile.index = index
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            xLength += ((UIScreen.main.bounds.width-40)*1/3)
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedSelectArtist))
            tap.id = tileData.id
            tap.aname = tileData.name
            tap.songs = tileData.songsCount!
            tap.url = decodedImage
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            allArtistContent.addSubview(songTile)
        }
        view.addSubview(viewAllArtist)
    }
    
    //Select Playlists See All View
    func loadSelectPlaylistsSeeAllViews(view: UIView, title: String) {
        viewAllSelectPlaylists = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height))
        viewAllSelectPlaylists.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClick_HideSelectPlaylistsSeeAllView), for: .touchUpInside)
        
        let text = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-40, height: 20))
        text.text = title
        text.font = UIFont(name: "Roboto", size: 16.0)
        text.textColor = UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(text)
        viewAllSelectPlaylists.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: view.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:  CGFloat(allPlaylistSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allPlaylistSeeAll.count)*20)+330))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height: CGFloat(allPlaylistSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allPlaylistSeeAll.count)*20)+330)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in allPlaylistSeeAll.enumerated(){
            let songTile = PlaylistTileSelectPlaylistSeeAll(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            //songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            songTile.index = index
            songTile.songs.text = String(tileData.number_of_songs) + " Songs"
            
            let dateArr = tileData.date!.components(separatedBy: "-")
            songTile.year.text = dateArr[0]
            
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickedCreateSelectPlaylistDetails))
            tap.id = String(tileData.id)
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            tap.image = decodedImage
            tap.title = tileData.name
            tap.songs = String(tileData.number_of_songs)
            tap.year =  dateArr[0]
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        viewAllSelectPlaylists.addSubview(one)
        view.addSubview(viewAllSelectPlaylists)
    }
    
    //Select Songs See All View
    var on = UIScrollView(frame: CGRect.zero)
    var tw = UIView(frame: CGRect.zero)
    var contOffset = 0
    func loadSelectSongsSeeAllViews(view: UIView, title: String) {
        viewAllSelectSongs.removeFromSuperview()
        viewAllSelectSongs = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height))
        viewAllSelectSongs.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClick_HideSelectSongsSeeAllView), for: .touchUpInside)
        
        let text = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-40, height: 20))
        text.text = title
        text.font = UIFont(name: "Roboto", size: 16.0)
        text.textColor = UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(text)
        viewAllSelectSongs.addSubview(topBar)
        
        on = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: view.frame.height))
        on.showsHorizontalScrollIndicator = false
        on.showsVerticalScrollIndicator = false
        
        tw = UIView(frame: CGRect(x: 0, y: 0, width: on.frame.width, height:   CGFloat(allSongSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allSongSeeAll.count)*20)+290))
        on.addSubview(tw)
        on.contentSize = CGSize(width: on.frame.width, height: CGFloat(allSongSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allSongSeeAll.count)*20)+290)
        on.contentOffset = CGPoint(x: 0, y: contOffset)
        var xLength: CGFloat = 10
        
        for (_, tileData) in allSongSeeAll.enumerated() {
            let songTile = SongTileSelectSongSeeAll(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblDescription.text = tileData.artist
            songTile.lblTitle.text = tileData.name
            songTile.time.text = timeString(time: TimeInterval(tileData.duration!))
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.id = tileData.id
            songTile.add.setTitle("Add".localizedString, for: .normal)
            songTile.add.layer.borderColor = Constants.color_brand.cgColor
            songTile.add.setTitleColor(Constants.color_brand, for: .normal)
            xLength += UIScreen.main.bounds.width/6+20
            
            if arry.contains(tileData.id) || mainInstance.songArray.contains(tileData.id) {
                songTile.add.setTitle("Added", for: .normal)
                songTile.add.backgroundColor = Constants.color_brand
                songTile.add.layer.borderColor = Constants.color_brand.cgColor
                songTile.add.setTitleColor(.white, for: .normal)
            }
            tw.addSubview(songTile)
        }
        viewAllSelectSongs.addSubview(on)
        view.addSubview(viewAllSelectSongs)
        on.delegate = self
    }
    
    //Select Artists See All View
    func loadSelectArtistsSeeAllViews(view: UIView, title: String) {
        viewAllSelectArtists = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        viewAllSelectArtists.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClick_HideSelectArtistSeeAllView), for: .touchUpInside)
        
        let text = UILabel(frame: CGRect(x: 40, y: 10, width: 100, height: 20))
        text.text = "Artist"
        text.textColor = UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(text)
        viewAllSelectArtists.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: view.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height: CGFloat(allArtistSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allArtistSeeAll.count)*20)+370))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height: CGFloat(allArtistSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allArtistSeeAll.count)*20)+370)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in allArtistSeeAll.enumerated(){
            let songTile = SongTileSeeAllArtist(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            //songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            songTile.albums.text = "\(tileData.songsCount ?? 0)"+" Songs"
            songTile.add.isHidden = true
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedSelectArtist))
            tap.id = tileData.id
            tap.aname = tileData.name
            tap.songs = tileData.songsCount!
            tap.url = decodedImage
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        viewAllSelectArtists.addSubview(one)
        view.addSubview(viewAllSelectArtists)
    }
    
    func createSelectPlaylistDetails(id: String, url: String, title: String, songs_count: String, date: String, status: Bool) {
        
        viewSelectPlaylistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewSelectPlaylistDetails.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClick_HideSelectPlaylistDetailsView), for: .touchUpInside)
        topBar.addSubview(arrow)
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: topBar.frame.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4+90))
        titleContainer.backgroundColor = Constants.color_background
        titleContainer.isUserInteractionEnabled = true
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height+titleContainer.frame.height, width: view.frame.width, height: view.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height: CGFloat(playlistDetailsSongs.count)*(UIScreen.main.bounds.width/6)+(CGFloat(playlistDetailsSongs.count)*20)+370+UIScreen.main.bounds.width/3+40))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height:CGFloat(playlistDetailsSongs.count)*(UIScreen.main.bounds.width/6)+(CGFloat(playlistDetailsSongs.count)*20)+370+UIScreen.main.bounds.width/3+40)
        
        one.isUserInteractionEnabled = true
        two.isUserInteractionEnabled = true
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4))
        image.kf.setImage(with:  URL(string: url)!)
//        image.downloadImageBrowse(from: URL(string: url)!)
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
        
        let labelAddSong = UILabel()
        labelAddSong.frame = CGRect(x: 0, y: lblTitle.frame.height+image.frame.height+songs.frame.height+10, width: 70, height:20)
        labelAddSong.center.x = topBar.center.x
        labelAddSong.text = "ADD_ALL".localizedString
        labelAddSong.textAlignment = .center
        labelAddSong.font = UIFont(name: "Roboto-Bold", size: 9.0)
        labelAddSong.layer.cornerRadius = 10
        labelAddSong.layer.borderWidth = 1
        labelAddSong.layer.borderColor = Constants.color_brand.cgColor
        labelAddSong.textColor = Constants.color_brand
        labelAddSong.clipsToBounds = true
        let tapSelectAllPlaylistSongs = PlaylistTapGesture(target: self, action: #selector(buttonClickedSelectAllPlaylistSongs))
        tapSelectAllPlaylistSongs.id = id
        tapSelectAllPlaylistSongs.image = url
        tapSelectAllPlaylistSongs.title = title
        tapSelectAllPlaylistSongs.songs = songs_count
        tapSelectAllPlaylistSongs.year = date
        labelAddSong.isUserInteractionEnabled = true
        labelAddSong.addGestureRecognizer(tapSelectAllPlaylistSongs)
        
        titleContainer.addSubview(image)
        titleContainer.addSubview(lblTitle)
        titleContainer.addSubview(songs)
        titleContainer.addSubview(year)
        //titleContainer.addSubview(labelPlaySong)
        titleContainer.addSubview(labelAddSong)
        
        var xLength: CGFloat = 10
        for (_, tileData) in playlistDetailsSongs.enumerated(){
            let songTile = SongsTileSelectPlaylistDetails(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblDescription.text = tileData.artist
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            
            if status || mainInstance.songArray.contains(tileData.id) {
                songTile.add.setTitle("AddedToPlayList".localizedString, for: .normal)
                songTile.add.backgroundColor = Constants.color_brand
                songTile.add.layer.borderColor = Constants.color_brand.cgColor
                songTile.add.setTitleColor(.white, for: .normal)
            }
            xLength += UIScreen.main.bounds.width/6+20
            songTile.id = tileData.id
            songTile.lblTime.text = timeString(time: TimeInterval(tileData.duration!))
            two.addSubview(songTile)
        }
        
        viewSelectPlaylistDetails.addSubview(topBar)
        viewSelectPlaylistDetails.addSubview(titleContainer)
        viewSelectPlaylistDetails.addSubview(one)
        
        view.addSubview(viewSelectPlaylistDetails)
        
        if playlistStatus {
            playlistStatus = false
        } else {
            playlistStatus = true
        }
    }
    
    
    func createSelectArtistDetails(id: Int, name: String, url: String, album: String, song: String) {
        viewSelectArtistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewSelectArtistDetails.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClick_HideSelectArtistDetailsView), for: .touchUpInside)
        
        topBar.addSubview(arrow)
        viewSelectArtistDetails.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height, width: viewSelectArtistDetails.frame.width , height: view.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:420+UIScreen.main.bounds.width/3+UIScreen.main.bounds.width/2+10+UIScreen.main.bounds.width*1/3))
        one.addSubview(two)
        
        one.contentSize = CGSize(width: one.frame.width, height:UIScreen.main.bounds.width/3+100)
        
        loadSelectSongByArtistDetailsViews(view: one)
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/3+40))
        titleContainer.backgroundColor = Constants.color_background
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3))
        image.kf.setImage(with: URL(string: url)!)
        
//        image.downloadImageBrowse(from: URL(string: url)!)
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
        
        let songs = UILabel(frame: CGRect(x: 0, y: lblTitle.frame.height+image.frame.height, width: UIScreen.main.bounds.width/2-10, height: 20))
        songs.text = song + " Songs"
        songs.textAlignment = .center
        songs.center.x = titleContainer.center.x
        songs.textColor = UIColor.gray
        songs.font = UIFont(name: "Roboto", size: 11.0)
        
        titleContainer.addSubview(image)
        titleContainer.addSubview(lblTitle)
        //titleContainer.addSubview(albums)
        titleContainer.addSubview(songs)
        
        let labelAlbum = UILabel()
        labelAlbum.frame = CGRect(x: 10, y: titleContainer.frame.height, width: UIScreen.main.bounds.width-10, height:40)
        labelAlbum.text = "Album"
        labelAlbum.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelAlbum.textColor = UIColor.white
        
        let labelAlbumByArtistSeeAll = UILabel()
        labelAlbumByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10, width: 70, height:20)
        labelAlbumByArtistSeeAll.text = "ViewAll".localizedString
        labelAlbumByArtistSeeAll.textAlignment = .center
        labelAlbumByArtistSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelAlbumByArtistSeeAll.layer.cornerRadius = 10
        labelAlbumByArtistSeeAll.textColor = UIColor.white
        labelAlbumByArtistSeeAll.layer.masksToBounds = true
        labelAlbumByArtistSeeAll.backgroundColor = Constants.color_brand
        
        two.addSubview(titleContainer)
        let labelSong = UILabel()
        labelSong.frame = CGRect(x: 10, y: titleContainer.frame.height, width: UIScreen.main.bounds.width-10, height:40)
        
        labelSong.text = "Songs"
        labelSong.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSong.textColor = UIColor.white
        
        let labelSongByArtistSeeAll = UILabel()
        labelSongByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10, width: 70, height:20)
        labelSongByArtistSeeAll.text = "ViewAll".localizedString
        labelSongByArtistSeeAll.textAlignment = .center
        labelSongByArtistSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongByArtistSeeAll.layer.cornerRadius = 10
        labelSongByArtistSeeAll.textColor = UIColor.white
        labelSongByArtistSeeAll.layer.masksToBounds = true
        labelSongByArtistSeeAll.backgroundColor = Constants.color_brand
        let tap = PlaylistPlayGesture(target: self, action: #selector(buttonClickedSelectSeeAllArtistBySongs))
        tap.id = id
        labelSongByArtistSeeAll.isUserInteractionEnabled = true
        labelSongByArtistSeeAll.addGestureRecognizer(tap)
        
        two.addSubview(labelSong)
        two.addSubview(labelSongByArtistSeeAll)
        viewSelectArtistDetails.addSubview(one)
        view.addSubview(viewSelectArtistDetails)
    }
    
    //View of Songs By Artist for Add to Playlist
    func loadSelectSongByArtistDetailsViews(view: UIView) {
        
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width/3+80, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width-40)*1/3+30))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        viewGenreSongs.addSubview(songsViewContent)
        
        var xLength: CGFloat = 10
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        songsViewContent.addSubview(scrollView)
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(allArtistSongs.count) * (view.frame.height - 20 ), height: scrollView.frame.height))
        scrollView.addSubview(contentView)
        
        scrollView.contentSize = CGSize(width: CGFloat(allArtistSongs.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: scrollView.frame.height)
        for (_, tileData) in allArtistSongs.enumerated() {
            let songTile = SongsTileSelectArtistDetails(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
            songTile.lblDescription.text = tileData.artist
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.id = tileData.id
            songTile.unselectText.text = ""
            xLength += ((UIScreen.main.bounds.width-40)*1/3)
            
            if arry.contains(tileData.id) || mainInstance.songArray.contains(tileData.id){
                songTile.selectedFrame.backgroundColor = Constants.color_selectedSong
                songTile.unselectText.text = "Added"
            }
            contentView.addSubview(songTile)
        }
        view.addSubview(viewGenreSongs)
    }
    
    func timeString(time: TimeInterval) -> String {
        /*let hour = Int(time) / 3600
         let minute = Int(time) / 60 % 60
         let second = Int(time) % 60*/
        
        let t = time*60
        
        let minute = Int(t) / 60
        let second = Int(t) % 60
        
        // return formated string
        return String(format: "%02i:%02i", minute, second)
    }
    
    func createSelectArtistAllSongsView(view: UIView, title: String) {
        viewAllSelectArtistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height))
        viewAllSelectArtistDetails.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClick_HideSelectArtistDetailsSeeAllView), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        label.text = String(title)
        label.textColor =  UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(label)
        
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-40))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        viewGenreSongs.addSubview(songsViewContent)
        
        let scrollView = UIScrollView(frame: CGRect(x: 10, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        songsViewContent.addSubview(scrollView)
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: CGFloat(allArtistSongsSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allArtistSongsSeeAll.count)*20)+290))
        scrollView.addSubview(contentView)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(allArtistSongsSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allArtistSongsSeeAll.count)*20)+290)
        
        var xLength: CGFloat = 10
        
        for (_, tileData) in allArtistSongsSeeAll.enumerated() {
            let songTile = SongsTileSelectArtistDetailsSeeAll(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblDescription.text = tileData.artist
            songTile.lblTitle.text = tileData.name
            
            songTile.time.text = timeString(time: TimeInterval(tileData.duration!))
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            xLength += UIScreen.main.bounds.width/6+20
            songTile.id = tileData.id
            if arry.contains(tileData.id) || mainInstance.songArray.contains(tileData.id) {
                songTile.add.setTitle("Added", for: .normal)
                songTile.add.backgroundColor = Constants.color_brand
                songTile.add.layer.borderColor = Constants.color_brand.cgColor
                songTile.add.setTitleColor(.white, for: .normal)
            }
            contentView.addSubview(songTile)
        }
        
        viewAllSelectArtistDetails.addSubview(viewGenreSongs)
        viewAllSelectArtistDetails.addSubview(topBar)
        viewAllSelectArtistDetails.addSubview(viewGenreSongs)
        view.addSubview(viewAllSelectArtistDetails)
    }
    
    // MARK: - Model Calls
    //Load library songs
    func loadLibrarySongList() {
        self.libraryDataModel.getLibrarySongs(getLibrarySongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    if self.libraryDataModel.librarySongsList.count<1 {
                        self.noSongLabel.isHidden = false
                    }
                    let minimizedArray = self.libraryDataModel.librarySongsList.chunked(into: 10)
                    self.scrollCollectionLibrarySongs?.browsePlayingList = self.libraryDataModel.librarySongsList.count > 10 ? minimizedArray[0] : self.libraryDataModel.librarySongsList
                    self.scrollCollectionExapndedLibrarySongs?.browsePlayingList = self.libraryDataModel.librarySongsList
                    self.songCount = (self.scrollCollectionExapndedLibrarySongs?.browsePlayingList.count)!
                    if self.songCount<1 {
                        self.labelSongsSeeAllSong.isHidden=true
                    }
                    
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    //Load library artists
    func loadLibraryArtistsList(view: UIView) {
        self.libraryDataModel.getLibraryArtists(getLibraryArtistsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.libraryDataModel.libraryArtistsList.chunked(into: 10)
                    self.libraryArtistsList = self.libraryDataModel.libraryArtistsList.count > 10 ? minimizedArray[0] : self.libraryDataModel.libraryArtistsList
                    self.libraryArtistsListAll = self.libraryDataModel.libraryArtistsList
                    self.artistCount = self.libraryArtistsListAll.count
                    if self.artistCount<1 {
                        self.labelSongsSeeAllArtist.isHidden=true
                    }
                    self.createLibraryArtistFrontView(view: view)
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    //ReLoad library artists
    func reloadLibraryArtistsList(view: UIView) {
        self.libraryDataModel.getLibraryArtists(getLibraryArtistsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.libraryDataModel.libraryArtistsList.chunked(into: 10)
                    self.libraryArtistsList = self.libraryDataModel.libraryArtistsList.count > 10 ? minimizedArray[0] : self.libraryDataModel.libraryArtistsList
                    self.libraryArtistsListAll = self.libraryDataModel.libraryArtistsList
                    self.createLibraryArtistSeeAllView(view: view, title: "Artists")
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    //Load library artist songs
    func loadLibraryArtistSongsList(id: Int) {
        self.homeDataModel.getHomePopularArtistSongs(id: id, getHomePopularArtistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.homeDataModel.popularArtistSongsList.chunked(into: 10)
                    self.scrollCollectionMinimizedSongsByArtist?.currentPlayingList = self.homeDataModel.popularArtistSongsList.count > 10 ? minimizedArray[0] : self.homeDataModel.popularArtistSongsList
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    //Load library artist all songs
    func loadLibraryArtistAllSongsList(id: Int) {
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
    
    //Load library kiki playlists
    func loadLibraryKiKiPlaylistsList() {
        self.libraryDataModel.getKiKiPlaylists(getPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async {
                    
                    let minimizedArray = self.libraryDataModel.kikiPlaylists.chunked(into: 10)
                    self.libraryKiKiPlaylists = self.libraryDataModel.kikiPlaylists.count > 10 ? minimizedArray[0] : self.libraryDataModel.kikiPlaylists
                    self.libraryKiKiAllPlaylists = self.libraryDataModel.kikiPlaylists
                    self.kikiPlaylistCount = self.libraryKiKiAllPlaylists.count
                    if self.kikiPlaylistCount<1 {
                        self.labelSongsSeeAllKikiPlaylist.isHidden=true
                    }
                    self.createKiKiPlaylistFrontView(view: self.scrollView)
                }
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    //Reload library kiki playlists
    func reloadLibraryKiKiPlaylistsList() {
        self.libraryDataModel.getKiKiPlaylists(getPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async {
                    let minimizedArray = self.libraryDataModel.kikiPlaylists.chunked(into: 10)
                    self.libraryKiKiPlaylists = self.libraryDataModel.kikiPlaylists.count > 10 ? minimizedArray[0] : self.libraryDataModel.kikiPlaylists
                    self.libraryKiKiAllPlaylists = self.libraryDataModel.kikiPlaylists
                    self.createKiKiPlaylistSeeAllViews(view: self.view, title: "Playlists")
                }
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    //Load library kiki playlist songs
    func loadKiKiPlaylistSongsList(id: Int, url: String, title: String, songs_count: String, date: String) {
        self.homeDataModel.getLatestPlaylistSongs(id: String(id), getHomeLatestPlaylistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.UserPlaylistSongs = self.homeDataModel.latestPlaylistSongsList
                    self.createKiKiPlaylistDetailsView(id: String(id), url: url, title: title, songs_count: songs_count, date: date)
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    //Load library kiki playlist songs play
    func loadSongsOfGlobalPlaylistKiKiGlobal(listID:Int) {
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            /*self.playlistModel.getSongsOfPlaylistGlobal(listID: listID, getSongsOfPlaylistCallFinished:{ (status, error, songs) in
             if (status) {
             if (songs == nil || (songs?.isEmpty)!) {
             let alert = UIAlertController(title: "Kiki", message: "No Songs Availabale", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
             } else {
             self.playerView.pause()
             self.playerView.currentPlayingList = songs!
             self.playerView.currentPlayingTime = 0
             self.playerView.play()
             }
             } else {
             let alert = UIAlertController(title: "Kiki", message: "Unexpected error occured", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
             }
             })*/
            if currentPlayingListId != String(listID) {
                currentPlayingListId = String(listID)
                self.playerView.pause()
                self.playerView.currentPlayingList = UserPlaylistSongs
                self.playerView.currentPlayingTime = 0
                self.playerView.play()
            }
        }
    }
    
    //Load library user playlist
    func loadLibraryUserPlaylistsList() {
        self.libraryDataModel.getPlaylists(getPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async {
                    let minimizedArray = self.libraryDataModel.playlists.chunked(into: 10)
                    self.libraryPlaylists = self.libraryDataModel.playlists.count > 10 ? minimizedArray[0] : self.libraryDataModel.playlists
                    self.libraryAllPlaylists = self.libraryDataModel.playlists
                    self.userPlaylistCount = self.libraryAllPlaylists.count
                    if self.userPlaylistCount<1 {
                        self.labelSongsSeeAllUserPlaylist.isHidden=true
                    }
                    self.createUserPlaylistFrontView(view: self.scrollView)
                    self.createPlaylistView.removeFromSuperview()
                    self.viewSelectPlaylistDetails.removeFromSuperview()
                    mainInstance.playlistName = ""
                    mainInstance.playlistImage = ""
                }
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    //Reload library user playlist
    func reloadLibraryUserPlaylistsList() {
        self.libraryDataModel.getPlaylists(getPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async {
                    let minimizedArray = self.libraryDataModel.playlists.chunked(into: 10)
                    self.libraryPlaylists = self.libraryDataModel.playlists.count > 10 ? minimizedArray[0] : self.libraryDataModel.playlists
                    self.libraryAllPlaylists = self.libraryDataModel.playlists
                    self.createUserPlaylistSeeAllViews(view: self.view, title: "Playlists")
                    
                }
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    //Load library user playlist songs
    func loadUserPlaylistSongsList(id: Int, url: String, title: String, songs_count: String, date: String) {
        self.libraryDataModel.getSongsOfPlaylist(listID: id, getSongsOfPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.UserPlaylistSongs = self.libraryDataModel.playlistSongs
                    
                    for s in self.UserPlaylistSongs {
                        self.arry.append(s.id)
                    }
                    
                    self.loadLibraryUserPlaylistsList()
                    self.createUserPlaylistDetailsView(id: String(id), url: url, title: title, songs_count: songs_count, date: date)
                    self.viewSelectPlaylistDetails.removeFromSuperview()
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {})
                ProgressView.shared.hide()
            }
        })
    }
    
    //Load library user playlist songs play
    func loadSongsOfGlobalPlaylistGlobal(listID:Int) {
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            /*self.playlistModel.getSongsOfPlaylist(listID: listID, getSongsOfPlaylistCallFinished:{ (status, error, songs) in
             if (status) {
             if (songs == nil || (songs?.isEmpty)!) {
             let alert = UIAlertController(title: "Kiki", message: "No Songs Availabale", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
             } else {
             self.playerView.pause()
             self.playerView.currentPlayingList = songs!
             self.playerView.currentPlayingTime = 0
             self.playerView.play()
             }
             } else {
             let alert = UIAlertController(title: "Kiki", message: "Unexpected error occured", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
             }
             })*/
            
            if currentPlayingListId != String(listID) {
                playerView?.radioStatus = "song"
                currentPlayingListId = String(listID)
                self.playerView.pause()
                self.playerView.currentPlayingList = UserPlaylistSongs
                self.playerView.currentPlayingTime = 0
                self.playerView.play()
            }
        }
    }
    
    //Create playlist
    func createPlaylist(playlistName: String, imageUrl: String) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        self.libraryDataModel.createPlaylist(playlistName: playlistName, imageUrl: imageUrl, createPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    var playlistId = ""
                    
                    self.returnPlaylistData = self.libraryDataModel.returnPlaylistData
                    
                    for (_, tileData) in self.returnPlaylistData.enumerated() {
                        playlistId.append(String(tileData.id))
                    }
                    if self.tempPlaylistSongs.count > 0 {
                        var songsid = [String]()
                        
                        for (_, tileData) in self.tempPlaylistSongs.enumerated() {
                            songsid.append(String(tileData.id))
                        }
                        print("playlistId: "+playlistId+" songs: ",songsid)
                        self.createPlaylist(playlistId: playlistId, songs: songsid)
                        
                    }
                    
                    self.alert(message: "Playlist created")
                    self.loadLibraryUserPlaylistsList()
                    self.viewAllLibraryPlaylists.removeFromSuperview()
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    //Create playlist
    func getPlaylistData(pid: Int) {
        
        self.libraryDataModel.getPlaylistData(pid: pid, getPlaylistDataCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    var pid=0, url="", title="", sc=0, date=""
                    
                    self.returnPlaylistData = self.libraryDataModel.returnPlaylistData
                    
                    for (_, tileData) in self.returnPlaylistData.enumerated() {
                        pid = tileData.id
                        url = tileData.image!
                        title = tileData.name
                        sc = tileData.number_of_songs
                        date = tileData.date!
                    }
                    let dateArr = date.components(separatedBy: "-")
                    var decodedImage = url.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
                    print("decodedImage "+decodedImage)
                    self.loadUserPlaylistSongsList(id: pid, url: decodedImage, title: title, songs_count: String(sc), date: dateArr[0])
                    self.tempPlaylistSongs.removeAll()
                    mainInstance.playlistImage=""
                    mainInstance.playlistName=""
                    
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    
    func updatePlaylist(name: String, pid: Int, songs: [Int], image: String) {
        self.libraryDataModel.updatePlaylist(name: name, pid: pid, songs: songs, image: image, updatePlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.getPlaylistData(pid: pid)
                    self.tempPlaylistSongs.removeAll()
                    mainInstance.playlistName=""
                    mainInstance.playlistImage=""
                    mainInstance.playlistSessionToken=""
                    self.alert(message: "Your playlist successfully Edited")
                    self.editStatus = false
                })
            } else {
                ProgressView.shared.hide()
            }
        })
    }
    
    func createPlaylist(playlistId: String, songs: [String]) {
        self.libraryDataModel.addToPlaylist(playlistId: playlistId, songs: songs, addToPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    //self.tempPlaylistSongs.removeAll()
                    //mainInstance.playlistName=""
                    mainInstance.playlistSessionToken=""
                    self.viewSelectPlaylistDetails.removeFromSuperview()
                })
            }
        })
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func addToTempPlaylistSongs(session_id: String, ref_id: Int, type: String) {
        self.libraryDataModel.addToTempPlaylistSongs(session_id: session_id, ref_id: ref_id, type: type, addToTempPlaylistSongsCallFinished: { (status_r, error, userInfo) in
            if status_r {
                DispatchQueue.main.async(execute: {
                    self.getTempPlaylist(session_id: session_id)
                })
            }
        })
    }
    
    func addToTempEditedPlaylistSongs(session_id: String, ref_id: Int, type: String) {
        self.libraryDataModel.addToTempPlaylistSongs(session_id: session_id, ref_id: ref_id, type: type, addToTempPlaylistSongsCallFinished: { (status_r, error, userInfo) in
            if status_r {
                DispatchQueue.main.async(execute: {
                    self.getTempEditPlaylist(session_id: session_id)
                })
            }
        })
    }
    
    func addToTempEditedPlaylistSongs2(session_id: String, ref_id: Int, type: String) {
        self.libraryDataModel.addToTempPlaylistSongs(session_id: session_id, ref_id: ref_id, type: type, addToTempPlaylistSongsCallFinished: { (status_r, error, userInfo) in
            if status_r {
                DispatchQueue.main.async(execute: {
                    self.getTempEditPlaylist2(session_id: session_id)
                })
            }
        })
    }
    
    func getTempPlaylist(session_id: String) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        self.libraryDataModel.getTempPlaylist(session_id: session_id, getTempPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.tempPlaylistSongs = self.libraryDataModel.tempPlaylistSongs
                    
                    self.createNewPlaylistView(view: self.view, status: session_id)
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func loadAllPlaylists(view: UIView) {
        self.libraryDataModel.getAllPlaylist(getAllPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.libraryDataModel.allPlaylist.chunked(into: 10)
                    self.allPlaylist = self.libraryDataModel.allPlaylist.count > 10 ? minimizedArray[0] : self.libraryDataModel.allPlaylist
                    self.allPlaylistSeeAll = self.libraryDataModel.allPlaylist
                    
                    self.loadAllPlaylistViews(view: view)
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func loadAllSongs(view: UIView, offset: Int) {
        self.libraryDataModel.getAllSongs(offset: offset, getAllSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.libraryDataModel.allSongs.chunked(into: 10)
                    self.allSong = self.libraryDataModel.allSongs.count > 10 ? minimizedArray[0] : self.libraryDataModel.allSongs
                    self.allSongSeeAll = self.libraryDataModel.allSongs
                    
                    self.loadAllSongViews(view: view)
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func loadAllArtists(view: UIView) {
        self.libraryDataModel.getAllArtists(getAllArtistsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.libraryDataModel.allArtists.chunked(into: 10)
                    self.allArtist = self.libraryDataModel.allArtists.count > 10 ? minimizedArray[0] : self.libraryDataModel.allArtists
                    self.allArtistSeeAll = self.libraryDataModel.allArtists
                    
                    self.loadAllArtistViews(view: view)
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func loadAllSelectPlaylistSongsList(id: String, url: String, title: String, songs_count: String, date: String) {
        self.libraryDataModel.getSelectPlaylistSongs(id: id, getSelectPlaylistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.playlistDetailsSongs = self.libraryDataModel.selectPlaylistSongsList
                    
                    self.createSelectPlaylistDetails(id: id, url: url, title: title, songs_count: songs_count, date: date, status: self.playlistStatus)
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func addToTempPlaylistSongs2(session_id: String, ref_id: Int, type: String) {
        self.libraryDataModel.addToTempPlaylistSongs(session_id: session_id, ref_id: ref_id, type: type, addToTempPlaylistSongsCallFinished: { (status_r, error, userInfo) in
            if status_r {
                DispatchQueue.main.async(execute: {
                    self.getTempPlaylist2(session_id: session_id)
                })
            }
        })
    }
    
    func getTempPlaylist2(session_id: String) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        self.libraryDataModel.getTempPlaylist(session_id: session_id, getTempPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.tempPlaylistSongs = self.libraryDataModel.tempPlaylistSongs
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func loadSelectArtistSongsList(id: Int, name: String, url: String, album: String, song: String) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        self.libraryDataModel.getSelectArtistSongs(id: id, getSelectArtistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.libraryDataModel.selectArtistSongsList.chunked(into: 10)
                    self.allArtistSongs = self.libraryDataModel.selectArtistSongsList.count > 10 ? minimizedArray[0] : self.libraryDataModel.selectArtistSongsList
                    
                    self.allArtistSongsSeeAll = self.libraryDataModel.selectArtistSongsList
                    
                    self.createSelectArtistDetails(id: id, name: name, url: url, album: album, song: song)
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func fetchRemainingSongs() {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        self.libraryDataModel.getAllSongs(offset: self.allSongSeeAll.count, getAllSongsListCallFinished: { (status, error, userInfo) in
            if status {
                self.allSongSeeAll = self.libraryDataModel.allSongs
                self.contOffset = Int(CGFloat(self.allSongSeeAll.count)*(UIScreen.main.bounds.width/6))
                DispatchQueue.main.async{
                    ProgressView.shared.hide()
                    self.loadSelectSongsSeeAllViews(view: self.view, title: "Add Songs")
                }
            } else {
                DispatchQueue.main.async{
                    ProgressView.shared.hide()
                }
            }
        })
    }
    
    func removePlaylistFromLibrary(id: Int) {
        
        confirmAlertDialog.isHidden = true
        confirmAlertDialog.removeFromSuperview()
        overLayView.removeFromSuperview()
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        self.libraryDataModel.removePlaylistFromLibrary(id: id, removePlaylistFromLibraryCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    
                    self.reloadLibraryUserPlaylistsList()
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func removeFromLibrary(key: String, id: Int) {
        confirmAlertDialog.isHidden = true
        confirmAlertDialog.removeFromSuperview()
        overLayView.removeFromSuperview()
        if key=="A" || key=="P" {
            ProgressView.shared.show(view, mainText: nil, detailText: nil)
        } else {
            //ProgressView.shared.show(addAlertDialog, mainText: nil, detailText: nil)
        }
        
        self.libraryDataModel.removeFromLibrary(key: key, id: id, removeFromLibraryCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.alert(message: "REMOVED_FROM_LIBRARY".localizedString)
                    //self.addAlertDialog.isHidden = true
                    //self.addAlertDialog.removeFromSuperview()
                    //self.overLayView.removeFromSuperview()
                    if key=="A" {
                        self.reloadLibraryArtistsList(view: self.view)
                    }
                    if key=="P" {
                        self.reloadLibraryKiKiPlaylistsList()
                    }
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func playlistLoadTempTable(session_id: String, pid: Int) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        self.libraryDataModel.playlistLoadTempTable(session_id: session_id, pid: pid, playlistLoadTempTableCallFinished: { (status, error, userInfo) in
            if status {
                DispatchQueue.main.async(execute: {
                    //ProgressView.shared.hide()
                    self.getTempEditPlaylist2(session_id: session_id)
                    
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func getTempEditPlaylist(session_id: String) {
        //ProgressView.shared.show(view, mainText: nil, detailText: nil)
        self.libraryDataModel.getTempPlaylist(session_id: session_id, getTempPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.tempPlaylistSongs.removeAll()
                    self.tempPlaylistSongs = self.libraryDataModel.tempPlaylistSongs
                    ProgressView.shared.hide()
                    self.createNewPlaylistView(view: self.view, status: session_id)
                    // self.createEditPlaylistView(view: self.view, status: session_id)
                    
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func getTempEditPlaylist2(session_id: String) {
        
        //ProgressView.shared.show(view, mainText: nil, detailText: nil)
        self.libraryDataModel.getTempPlaylist(session_id: session_id, getTempPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.tempPlaylistSongs.removeAll()
                    self.tempPlaylistSongs = self.libraryDataModel.tempPlaylistSongs
                    ProgressView.shared.hide()
                    //self.createNewPlaylistView(view: self.view, status: session_id)
                    self.createEditPlaylistView(view: self.view, status: session_id)
                    
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func getFinalEditPlaylist(session_id: String) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        self.libraryDataModel.getTempPlaylist(session_id: session_id, getTempPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.tempPlaylistSongs.removeAll()
                    self.tempPlaylistSongs = self.libraryDataModel.tempPlaylistSongs
                    
                    if self.tempPlaylistSongs.count > 0 {
                        var songsid = [Int]()
                        
                        for (_, tileData) in self.tempPlaylistSongs.enumerated() {
                            songsid.append(tileData.id)
                        }
                        if self.imgGlobal != "" {
                            self.updatePlaylist(name: self.newPlaylist.text!, pid: mainInstance.playlistId, songs: songsid, image: "data:image/png;base64,"+self.imgGlobal)
                        } else {
                            self.updatePlaylist(name: self.newPlaylist.text!, pid: mainInstance.playlistId, songs: songsid, image: "")
                        }
                        //self.updatePlaylist(name: ,pid: mainInstance.playlistId, songs: songsid)
                    }
                    
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    // MARK: - OnClick Events
    
    @objc func buttonClickedPlaylistSongPlay(recognizer: PlaylistPlayGesture) {
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            playerView?.radioStatus = "song"
            playerView.pause()
            playerView.currentPlayingList = UserPlaylistSongs
            playerView.currentPlayingIndex = recognizer.id
            playerView.currentPlayingTime = 0
            playerView.scrollCollection.changeSong(index: recognizer.id)
            playerView.play()
        }
    }
    
    @objc func buttonClickedRemoveArtistFromLibrary(recognizer: GenreTapGesture) {
        showConfirmAlertDialog(title: "DO_YOU_WANT_TO_REMOVE".localizedString + recognizer.title, id: Int(recognizer.id)!, key: "A")
    }
    
    @objc func buttonClickedRemovePlaylistFromLibrary(recognizer: GenreTapGesture) {
        showConfirmAlertDialog(title: "DO_YOU_WANT_TO_REMOVE".localizedString + recognizer.title, id: Int(recognizer.id)!, key: "P")
    }
    
    @objc func buttonClickedRemoveUserPlaylistFromLibrary(recognizer: GenreTapGesture) {
        showConfirmAlertDialog(title: "DO_YOU_WANT_TO_REMOVE".localizedString + recognizer.title, id: Int(recognizer.id)!, key: "UP")
    }
    
    @objc func buttonClickSeeAllLibrarySongs(sender: LibraryTapGesture) {
        loadLibrarySongList()
        librarySongsSeeAllView.isHidden = false
    }
    
    @objc func buttonClickBackLibrarySongsSeeAllView(sender: UIButton) {
        
        if songCount != (self.scrollCollectionExapndedLibrarySongs?.browsePlayingList.count)! {
            createLibrarySongFrontView(view: scrollView) // Library songs front view
            createLibrarySongSeeAllView(view: view, title: "Songs") // Library songs see all view
            loadLibrarySongList() //Load songs for Library
        }
        
        librarySongsSeeAllView.isHidden = true
    }
    
    @objc func buttonClickSeeAllLibraryArtists(sender: UIButton) {
        self.createLibraryArtistSeeAllView(view: view, title: "Artist".localizedString)
    }
    
    @objc func buttonClickedOnArtist(recognizer: MyTapGesture) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        self.loadLibraryArtistSongsList(id: recognizer.id)
        self.createLibraryArtistDetails(id: recognizer.id, name: recognizer.aname, url: recognizer.url, album: "", song: String(recognizer.songs)+" Songs")
    }
    
    @objc func buttonClickBackLibraryArtistsSeeAllView(sender: UIButton) {
        if artistCount != libraryArtistsListAll.count {
            self.createLibraryArtistFrontView(view: scrollView)
        }
        libraryArtistsSeeAllView.removeFromSuperview()
    }
    
    @objc func backButtonClickLibraryArtistDetails(sender:UIButton) {
        viewAllLibraryArtistDetails.removeFromSuperview()
    }
    
    @objc func buttonClickedSeeAllArtistBySongs(recognizer: PlaylistPlayGesture) {
        createLibrarySongByArtistSeeAllView(view: view, title: "Song".localizedString)
        loadLibraryArtistAllSongsList(id: recognizer.id)
    }
    
    @objc func viewAllSongsButtonClicked(sender:UIButton) {
        viewAllSongs.isHidden = true
        viewAllBrowseArtistSongs.isHidden = true
    }
    
    @objc func buttonClickSeeAllLibraryKiKiPlaylists(sender:UIButton) {
        createKiKiPlaylistSeeAllViews(view: view, title: "KikiPlaylist".localizedString)
    }
    
    @objc func buttonClickBackLibraryKiKiPlaylistSeeAllView(sender:UIButton) {
        //self.createKiKiPlaylistFrontView(view: self.scrollView)
        if kikiPlaylistCount != libraryKiKiAllPlaylists.count {
            self.createKiKiPlaylistFrontView(view: scrollView)
        }
        viewAllLibraryPlaylists.removeFromSuperview()
    }
    
    @objc func buttonClickLibraryKiKiPlaylist(recognizer: PlaylistTapGesture) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        loadKiKiPlaylistSongsList(id: Int(recognizer.id)!, url: recognizer.image, title: recognizer.title, songs_count: recognizer.songs, date: recognizer.year)
    }
    
    @objc func buttonClickBackLibraryViewAllUserPlaylistsDetails(sender:UIButton) {
        viewUserPlaylistDetails.removeFromSuperview()
    }
    
    @objc func buttonClickedLibraryKiKiPlaylistPlay(recognizer: PlaylistPlayGesture) {
        loadSongsOfGlobalPlaylistKiKiGlobal(listID: recognizer.id)
    }
    
    @objc func buttonClickSeeAllLibraryUserPlaylists(sender:UIButton) {
        createUserPlaylistSeeAllViews(view: view, title: "YourPlaylist".localizedString)
    }
    
    @objc func buttonClickBackLibraryUserPlaylistSeeAllView(sender:UIButton) {
        if userPlaylistCount != libraryAllPlaylists.count {
            self.createUserPlaylistFrontView(view: scrollView)
        }
        viewAllLibraryPlaylists.removeFromSuperview()
    }
    
    @objc func buttonClickLibraryPlaylist(recognizer: PlaylistTapGesture) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        playlistYear = recognizer.year
        loadUserPlaylistSongsList(id: Int(recognizer.id)!, url: recognizer.image, title: recognizer.title, songs_count: recognizer.songs, date: recognizer.year)
    }
    
    @objc func buttonClickedPlaylistPlus(sender:UIButton) {
        mainInstance.playlistName = ""
        mainInstance.playlistImage = ""
        createNewPlaylistView(view: view, status: mainInstance.playlistSessionToken)
        mainInstance.playlistSessionToken = UIDevice.current.identifierForVendor!.uuidString+String(Date().currentTimeMillis())
    }
    
    @objc func buttonClickedLibraryUserPlaylistPlay(recognizer: PlaylistPlayGesture) {
        loadSongsOfGlobalPlaylistGlobal(listID: recognizer.id)
    }
    
    @objc func buttonClickedLibraryUserPlaylistEdit(recognizer: EditPlaylistTapGesture) {
        editStatus = true
        ProgressView.shared.hide()
        mainInstance.playlistSessionToken = UIDevice.current.identifierForVendor!.uuidString+String(Date().currentTimeMillis())
        mainInstance.playlistName = recognizer.title
        mainInstance.playlistImage = recognizer.image
        editImage = recognizer.image
        mainInstance.playlistId = recognizer.pid
        playlistLoadTempTable(session_id: mainInstance.playlistSessionToken, pid: recognizer.pid)
    }
    
    @objc func buttonClick_HideCreatedPlaylistView(sender:UIButton) {
        editStatus = false
        mainInstance.playlistImage=""
        mainInstance.playlistSessionToken=""
        tempPlaylistSongs.removeAll()
        print("mainInstance.playlistSessionToken=_")
        createPlaylistView.removeFromSuperview()
        viewSelectPlaylistDetails.removeFromSuperview()
        createSelectSongsView.removeFromSuperview()
    }
    
    @objc func buttonClick_ConfirmCreatedPlaylistView(sender:UIButton) {
        //mainInstance.playlistImage=""
        mainInstance.songArray.removeAll()
        mainInstance.playlistName=newPlaylist.text!
        if mainInstance.playlistName == "" || mainInstance.playlistName == "NEW_PLAYLIST".localizedString {
            if imgGlobal != "" {
                createPlaylist(playlistName: "New Playlist", imageUrl: "data:image/png;base64,"+imgGlobal)
            } else {
                createPlaylist(playlistName: "New Playlist", imageUrl: "")
            }
        } else {
            if imgGlobal != "" {
                createPlaylist(playlistName: mainInstance.playlistName, imageUrl: "data:image/png;base64,"+imgGlobal)
            } else {
                createPlaylist(playlistName: mainInstance.playlistName, imageUrl: "")
            }
            
        }
        
        createSelectSongsView.removeFromSuperview()
        createPlaylistView.removeFromSuperview()
    }
    
    @objc func buttonClick_ConfirmEditPlaylistView(sender:UIButton) {
        
        //mainInstance.playlistImage=""
        getFinalEditPlaylist(session_id: mainInstance.playlistSessionToken)
        createSelectSongsView.removeFromSuperview()
        createPlaylistView.removeFromSuperview()
    }
    
    @objc func buttonClickAddImage(recognizer: PlaylistTapGesture) {
        let imagePicker = UIImagePickerController()
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
    }
    
    @objc func buttonClick_EditPlaylistName(sender:UIButton) {
        newPlaylist.becomeFirstResponder()
        newPlaylist.isEnabled = true
        newPlaylist.isUserInteractionEnabled = true
    }
    
    @objc func buttonClick_DonePlaylistName(sender:UIButton) {
        mainInstance.playlistName=newPlaylist.text!
        newPlaylist.isEnabled = false
        newPlaylist.isUserInteractionEnabled = false
        edit.isHidden = false
        done.isHidden = true
    }
    
    @objc func buttonClickRemoveSongFromPlaylist(recognizer: PlaylistTapGesture) {
        addToTempEditedPlaylistSongs(session_id: mainInstance.playlistSessionToken, ref_id: Int(recognizer.id)!, type: "S")
    }
    
    @objc func buttonClickRemoveSongFromPlaylist2(recognizer: PlaylistTapGesture) {
        addToTempEditedPlaylistSongs2(session_id: mainInstance.playlistSessionToken, ref_id: Int(recognizer.id)!, type: "S")
    }
    
    @objc func buttonClick_AddSongs(sender:UIButton) {
        mainInstance.playlistName=newPlaylist.text!
        if CGFloat(tempPlaylistSongs.count)>0 {
            createPlaylistView.removeFromSuperview()
        } else {
            createSelectSongsView(view: view)
        }
    }
    
    @objc func buttonClick_AddEditSongs(sender:UIButton) {
        createSelectSongsView(view: view)
    }
    
    @objc func buttonClick_HideSelectSongsView(sender:UIButton) {
        createSelectSongsView.removeFromSuperview()
    }
    
    @objc func buttonClick_ConfirmPlaylist(sender:UIButton) {
        if editStatus {
            getTempEditPlaylist2(session_id: mainInstance.playlistSessionToken)
        } else {
            getTempEditPlaylist(session_id: mainInstance.playlistSessionToken)
        }
    }
    
    @objc func buttonClickedAddSongsFromPlayLists(recognizer: HomeTapGesture) {
        loadSelectPlaylistsSeeAllViews(view: view, title: recognizer.lname)
    }
    
    @objc func buttonClickedAddSongsFromSongs(recognizer: HomeTapGesture) {
        loadSelectSongsSeeAllViews(view: view, title: recognizer.lname)
    }
    
    @objc func buttonClickedAddSongsFromArtists(recognizer: HomeTapGesture) {
        loadSelectArtistsSeeAllViews(view: view, title: recognizer.lname)
    }
    
    @objc func buttonClickedCreateSelectPlaylistDetails(recognizer: PlaylistTapGesture) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        loadAllSelectPlaylistSongsList(id: recognizer.id, url: recognizer.image, title: recognizer.title, songs_count: recognizer.songs, date: recognizer.year)
        
    }
    
    @objc func buttonClickedSelectArtist(recognizer: MyTapGesture) {
        self.loadSelectArtistSongsList(id: recognizer.id, name: recognizer.aname, url: recognizer.url, album: "11 albums", song: String(recognizer.songs))
    }
    
    @objc func buttonClick_HideSelectPlaylistsSeeAllView(sender:UIButton) {
        viewAllSelectPlaylists.removeFromSuperview()
    }
    
    @objc func buttonClick_HideSelectSongsSeeAllView(sender:UIButton) {
        viewAllSelectSongs.removeFromSuperview()
    }
    
    @objc func buttonClick_HideSelectArtistSeeAllView(sender:UIButton) {
        viewAllSelectArtists.removeFromSuperview()
    }
    
    @objc func buttonClick_HideSelectPlaylistDetailsView(sender:UIButton) {
        playlistStatus = false
        viewSelectPlaylistDetails.removeFromSuperview()
    }
    
    @objc func buttonClickedSelectAllPlaylistSongs(recognizer: PlaylistTapGesture) {
        addToTempPlaylistSongs2(session_id: mainInstance.playlistSessionToken, ref_id: Int(recognizer.id)!, type: "P")
        viewSelectPlaylistDetails.removeFromSuperview()
        createSelectPlaylistDetails(id: recognizer.id, url: recognizer.image, title: recognizer.title, songs_count: recognizer.songs, date: recognizer.year, status: playlistStatus)
    }
    
    @objc func buttonClick_HideSelectArtistDetailsView(sender:UIButton) {
        viewSelectArtistDetails.removeFromSuperview()
    }
    
    @objc func buttonClickedSelectSeeAllArtistBySongs(recognizer: PlaylistPlayGesture) {
        createSelectArtistAllSongsView(view: view, title: "Songs")
    }
    
    @objc func buttonClick_HideSelectArtistDetailsSeeAllView(sender:UIButton) {
        viewAllSelectArtistDetails.removeFromSuperview()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        handleShowSearchVC()
        return false
    }
    
    @objc func handleShowSearchVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        newViewController.barSwitch = true
        newViewController.pSongs = self.UserPlaylistSongs
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    // MARK: - Helper
    var windows = UIApplication.shared.keyWindow!
    func getRootViewController() -> KYDrawerController{
        return windows.rootViewController as! KYDrawerController
    }
    
    func subscribeAlert() {
        if AppStoreManager.IS_ON_REVIEW{
            UIHelper.makeNoContentAlert(on: self.view.window!)
        }else{
            UIHelper.makeSubscribeToListenAlert(on: self.view.window!)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let images = info[.originalImage] as? UIImage else { return }
        imgGlobal = convertImageToBase64String(img: images)
        mainInstance.playlistImage = imgGlobal
        image.image = images
        playlistImage = images
        globalImage = images
        mainInstance.pImage = images
        image.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4)
        image.center.x = createPlaylistView.center.x
        picker.dismiss(animated: true, completion: nil)
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    //Date to milliseconds
    func currentTimeMillis() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
}

extension LibraryController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let shouldRequestForRemaingEpisodes = offsetY + 100 > contentHeight - scrollView.frame.size.height
        if (shouldRequestForRemaingEpisodes) {
            self.fetchRemainingSongs()
        }
    }
}
