//
//  BrowseViewController.swift
//  SusilaMobile
//
//  Created by Admin on 11/5/19.
//  Copyright © 2019 Kiroshan T. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class BrowseViewController: UIView {
    
    var selectedTileSeeAllArtist:SongTileSeeAllArtist?
    var tilesSeeAllArtist:[SongTileSeeAllArtist] = [SongTileSeeAllArtist]()
    
    var scrollView = UIScrollView(frame: CGRect.zero)
    var contentView = UIView(frame: CGRect.zero)
    
    var styleType = 0{
        didSet{
            tilesSeeAllArtist.forEach{tile in
                tile.styleType = self.styleType
            }
        }
    }
    
    var allArtistList:[Artist] = [Artist]()
    var allArtistListSeeAll:[Artist] = [Artist]()
    var browseGenreArtistList:[Artist] = [Artist]()
    var browseGenreArtistListSeeAll:[Artist] = [Artist]()
    var genrePlayLists:[GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var genrePlayListsAll:[GlobalPlaylistItem] = [GlobalPlaylistItem]()
    
    var colorArray = [UIColor(red:0.83, green:0.33, blue:0.00, alpha:1.0), UIColor(red:0.15, green:0.61, blue:0.14, alpha:1.0), UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0), UIColor(red:0.42, green:0.00, blue:1.00, alpha:1.0), UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0), UIColor(red:0.00, green:0.67, blue:0.66, alpha:1.0), UIColor(red:0.83, green:0.21, blue:0.51, alpha:1.0), UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0), UIColor(red:0.35, green:0.34, blue:0.84, alpha:1.0), UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0)]
    let allSongsModel = AllSongsModel()
    var parentVC: DashboardViewController!
    var genreTileWidth = CGFloat(100)
    var scrollGenres: UIScrollView!
    var genreButtonContainer = UIView(frame: CGRect.zero)
    
    var scrollArtist: UIScrollView!
    var artistButtonContainer = UIView(frame: CGRect.zero)
    var scrollMain: UIScrollView!
    
    var songsViewContent = UIView(frame: CGRect.zero)
    
    var genreView = UIView(frame: CGRect.zero)
    var genreViewSeeAllArtist = UIView(frame: CGRect.zero)
    var viewAllBrowseArtists = UIView(frame: CGRect.zero)
    var genreSeeAllView = UIView(frame: CGRect.zero)
    var viewAllSongs = UIView(frame: CGRect.zero)
    var viewLatestPlaylistDetails = UIView(frame: CGRect.zero)
    
    var allSongs:[Song] = [Song]()
    // var genreViewArray:[GenreTiles] = [GenreTiles]()
    let homeDataModel = HomeDataModel()
    let browseDataModel = BrowseDataModel()
    
    
    var viewPopularArtists: UIView!
    var viewScrollPopularArtists: UIView!
    var viewGenreSongs: UIView!
    var viewGenreArtists: UIView!
    var viewGenrePlaylists: UIView!
    var viewScrollGenreSongs: UIView!
    
    var viewAlbumByArtist: UIView!
    var albumByArtistViewContent: UIView!
    
    var genreViewContentScroll: UIScrollView!
    var genreViewContent: UIView!
    
    var playerView = PlayerView() {
        didSet{
            scrollCollectionMinimizedPopularArtists?.playerView = self.playerView
            scrollCollectionExapndedPopularArtists?.playerView = self.playerView
            
            scrollCollectionMinimizedGenreSongs?.playerView = self.playerView
            scrollCollectionExapndedGenreSongs?.playerView = self.playerView
            
            scrollCollectionMinimizedGenreArtists?.playerView = self.playerView
            scrollCollectionMinimizedGenrePlaylist?.playerView = self.playerView
            
            scrollCollectionSongByArtist?.playerView = self.playerView
            scrollCollectionExapndedSongByArtist?.playerView = self.playerView
        }
    }
    
    var scrollCollectionMinimizedPopularArtists:ScrollCollectionBrowse?
    var scrollCollectionExapndedPopularArtists:ScrollCollectionBrowse?
    
    var scrollCollectionMinimizedGenreSongs:ScrollCollectionBrowse?
    var scrollCollectionExapndedGenreSongs:ScrollCollectionBrowse?
    
    var scrollCollectionMinimizedGenreArtists:ScrollCollectionBrowse?
    var scrollCollectionMinimizedGenrePlaylist:ScrollCollectionBrowse?
    
    var scrollCollectionAlbumByArtist:ScrollCollectionBrowse?
    
    var scrollCollectionSongByArtist:ScrollCollectionBrowse?
    var scrollCollectionExapndedSongByArtist:ScrollCollectionBrowse?
    
    //var scrollCollectionSeeAllArtist:scrollMain?
    var currentPlayingList:[Song] = [Song]()
    var genrePlayList:[Song] = [Song]()
    
    var playlistItems:[GlobalPlaylistItem] = [GlobalPlaylistItem](){
        didSet{
        }
    }
    
    var currentShowingSongs:[Song] = [Song](){
        didSet{
        }
    }
    
    var addAlertDialog = AddAlertDialog()
    var addToPlaylistAlertDialog = AddToPlaylistAlertDialog()
    var overLayView = UIView(frame: UIScreen.main.bounds)
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        loadAllSongsGenres()
        self.backgroundColor = Constants.color_background
        scrollMain = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scrollMain.showsHorizontalScrollIndicator = false
        scrollMain.showsVerticalScrollIndicator = false
        
        let labelByGenre = UILabel()
        labelByGenre.frame = CGRect(x: 10, y: 0, width: self.frame.width, height:40)
        labelByGenre.text = "ByGenre".localizedString
        labelByGenre.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelByGenre.textColor = UIColor.white
        scrollMain.addSubview(labelByGenre);
        
        let labelByGenreSeeAll = UILabel()
        labelByGenreSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: 10, width: 70, height:20)
        labelByGenreSeeAll.text = "ViewAll".localizedString
        labelByGenreSeeAll.textAlignment = .center
        labelByGenreSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelByGenreSeeAll.layer.cornerRadius = 10
        labelByGenreSeeAll.textColor = UIColor.white
        labelByGenreSeeAll.layer.masksToBounds = true
        labelByGenreSeeAll.backgroundColor = Constants.color_brand
        let tap = HomeTapGesture(target: self, action: #selector(buttonClickedSeeAllGenre))
        tap.lname = "Genres"
        labelByGenreSeeAll.isUserInteractionEnabled = true
        labelByGenreSeeAll.addGestureRecognizer(tap)
        scrollMain.addSubview(labelByGenreSeeAll);
        
        scrollGenres = UIScrollView(frame: CGRect(x: 10, y: 40, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.width-20))
        scrollGenres.showsHorizontalScrollIndicator = false
        scrollGenres.showsVerticalScrollIndicator = false
        genreButtonContainer = UIView(frame: CGRect(x: 0, y: 0, width: scrollGenres.frame.width, height: scrollGenres.frame.height))
        scrollMain.addSubview(scrollGenres)
        scrollGenres.addSubview(genreButtonContainer)
        scrollGenres.showsHorizontalScrollIndicator = false
        scrollGenres.showsVerticalScrollIndicator = false
        
        let labelByArtist = UILabel()
        labelByArtist.frame = CGRect(x: 10, y: labelByGenre.frame.height+scrollGenres.frame.height+10, width: self.frame.width, height:40)
        labelByArtist.text = "Byartist".localizedString
        labelByArtist.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelByArtist.textColor = UIColor.white
        scrollMain.addSubview(labelByArtist);
        
        let labelByArtistSeeAll = UILabel()
        labelByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: labelByGenre.frame.height+genreButtonContainer.frame.height+20, width: 70, height:20)
        labelByArtistSeeAll.text = "ViewAll".localizedString
        labelByArtistSeeAll.textAlignment = .center
        labelByArtistSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelByArtistSeeAll.layer.cornerRadius = 10
        labelByArtistSeeAll.textColor = UIColor.white
        labelByArtistSeeAll.layer.masksToBounds = true
        labelByArtistSeeAll.backgroundColor = Constants.color_brand
        let tapSeeAllBrowseArtist = HomeTapGesture(target: self, action: #selector(buttonClickedSeeAllBrowseArtist))
        tapSeeAllBrowseArtist.lname = "Popular Songs"
        labelByArtistSeeAll.isUserInteractionEnabled = true
        labelByArtistSeeAll.addGestureRecognizer(tapSeeAllBrowseArtist)
        scrollMain.addSubview(labelByArtistSeeAll);
        
        scrollArtist = UIScrollView(frame: CGRect(x: 0, y: labelByGenre.frame.height+genreButtonContainer.frame.height+labelByArtist.frame.height+10, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/3))
        scrollArtist.showsHorizontalScrollIndicator = false
        scrollArtist.showsVerticalScrollIndicator = false
        artistButtonContainer = UIView(frame: CGRect(x: 10, y: labelByGenre.frame.height+genreButtonContainer.frame.height+labelByArtist.frame.height+10, width: scrollArtist.frame.width, height: UIScreen.main.bounds.width/3))
        scrollMain.addSubview(artistButtonContainer)
        
        if UIScreen.main.bounds.height > 810 {
            scrollMain.contentSize = CGSize(width: UIScreen.main.bounds.width, height: genreButtonContainer.frame.height+330+labelByGenre.frame.height+labelByArtist.frame.height+artistButtonContainer.frame.height)
        } else{
            scrollMain.contentSize = CGSize(width: UIScreen.main.bounds.width, height: genreButtonContainer.frame.height+280+labelByGenre.frame.height+labelByArtist.frame.height+artistButtonContainer.frame.height)
        }
        
        self.addSubview(scrollMain)
        
        loadAllArtistsList()
        
        viewAllBrowseArtists = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        
        self.addSubview(viewAllBrowseArtists)
        
        self.addSubview(genreSeeAllView)
        
        overLayView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        addAlertDialog = AddAlertDialog(frame: getCenteredFrameForOverlay(150))
        addAlertDialog.isHidden = true
        addAlertDialog.layer.zPosition = 1002
        addAlertDialog.btnCancel.addTarget(self, action: #selector(cancelClickAddAlertDialog), for: .touchUpInside)
        
        let tapAddToLibrary = PlaylistPlayGesture(target: self, action: #selector(buttonClick_AddToLibrary))
        addAlertDialog.lblAddToLibrary.isUserInteractionEnabled = true
        addAlertDialog.lblAddToLibrary.addGestureRecognizer(tapAddToLibrary)
        
        let tapAddToPlaylist = PlaylistPlayGesture(target: self, action: #selector(buttonClick_AddToPlaylist))
        addAlertDialog.lblAddToPlaylist.isUserInteractionEnabled = true
        addAlertDialog.lblAddToPlaylist.addGestureRecognizer(tapAddToPlaylist)
        
        addToPlaylistAlertDialog = AddToPlaylistAlertDialog(frame: getCenteredFrameForOverlay(300))
        addToPlaylistAlertDialog.isHidden = true
        addToPlaylistAlertDialog.layer.zPosition = 2002
        addToPlaylistAlertDialog.btnCancel.addTarget(self, action: #selector(cancelClickAddToPlaylistAlertDialog), for: .touchUpInside)
        
        self.addSubview(addAlertDialog)
        self.addSubview(addToPlaylistAlertDialog)
    }
    
    @objc func cancelClickAddToPlaylistAlertDialog(sender:PlaylistTapGesture) {
        addToPlaylistAlertDialog.isHidden = true
        addToPlaylistAlertDialog.removeFromSuperview()
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
    
    @objc func buttonClickAddSongToPlaylists(recognizer: PlaylistTapGesture) {
        print("PlaylistId ", recognizer.id," SongId ", self.addAlertDialog.id)
        var songsid = [String]()
        songsid.append(String(self.addAlertDialog.id))
        addSongToPlaylist(playlistId: recognizer.id, songs: songsid)
        self.alert(message:"AddedToPlayList".localizedString)
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
    
    func showAddToPlaylistAlertDialog(title: String, id: String) {
        self.addSubview(addToPlaylistAlertDialog)
        addToPlaylistAlertDialog.id = addAlertDialog.id
        addToPlaylistAlertDialog.isHidden = false
    }
    
    func getCenteredFrameForOverlay(_ height: CGFloat) -> CGRect {
        return CGRect(x: 15, y: (UIScreen.main.bounds.height - 250 - height)/2, width: UIScreen.main.bounds.width - 30 , height: height)
    }
    
    func createGenreSeeAllView(view: UIView, title: String) {
        
        genreSeeAllView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        genreSeeAllView.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        genreSeeAllView.addSubview(topBar)
        
        let scrollGenresSeeAll = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-140))
        scrollGenresSeeAll.showsHorizontalScrollIndicator = false
        scrollGenresSeeAll.showsVerticalScrollIndicator = false
        
        genreSeeAllView.addSubview(scrollGenresSeeAll)
        
        let genreButtonContainerSeeAll = UIView(frame: CGRect(x: 0, y: 0, width: scrollGenresSeeAll.frame.width, height: ((UIScreen.main.bounds.width-40)*1/3)*5+120))
        
        scrollGenresSeeAll.addSubview(genreButtonContainerSeeAll)
        
        let arrow = UIButton(frame: CGRect(x: 0, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(allGenreBackButtonClicked), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 30, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        label.text = String(title)
        label.textColor =  UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(label)
        
        scrollGenresSeeAll.contentSize = CGSize(width: UIScreen.main.bounds.width-20, height: genreButtonContainerSeeAll.frame.height)
        
        var buttonY: CGFloat = 0, buttonY2: CGFloat = 0, buttonY3: CGFloat = 0, buttonY4: CGFloat = 0, buttonY5: CGFloat = 0, buttonY6: CGFloat = 0
        
        
        for (index, genreData) in songGenresAll.enumerated(){
            //let color = colorArray[index]
            let color:UIColor = UIHelper.colorWithHexString(hex: genreData.genreColor)
            
            let button = UIButton()
            button.backgroundColor = color
            button.setTitle(genreData.genreName, for: .normal)
            button.titleLabel!.font = UIFont(name: "Roboto", size: 11.0)
            button.titleLabel?.textColor = UIColor.white
            button.accessibilityHint = genreData.genreName!
            
            if (index>11) {
                button.frame = CGRect(x: buttonY5+10, y: ((UIScreen.main.bounds.width-40)*1/3+10)*4, width:(UIScreen.main.bounds.width-40)*1/3, height:(UIScreen.main.bounds.width-40)*1/3)
                buttonY5 += (UIScreen.main.bounds.width-40)*1/3 + 10
                buttonY6 = 5
            } else if (index>8) {
                button.frame = CGRect(x: buttonY4+10, y: ((UIScreen.main.bounds.width-40)*1/3+10)*3, width:(UIScreen.main.bounds.width-40)*1/3, height:(UIScreen.main.bounds.width-40)*1/3)
                buttonY4 += (UIScreen.main.bounds.width-40)*1/3 + 10
                buttonY6 = 4
            } else if (index>5) {
                button.frame = CGRect(x: buttonY3+10, y: ((UIScreen.main.bounds.width-40)*1/3+10)*2, width:(UIScreen.main.bounds.width-40)*1/3, height:(UIScreen.main.bounds.width-40)*1/3)
                buttonY3 += (UIScreen.main.bounds.width-40)*1/3 + 10
                buttonY6 = 3
            } else if (index>2) {
                button.frame = CGRect(x: buttonY2+10, y: (UIScreen.main.bounds.width-40)*1/3+10, width:(UIScreen.main.bounds.width-40)*1/3, height:(UIScreen.main.bounds.width-40)*1/3)
                buttonY2 += (UIScreen.main.bounds.width-40)*1/3 + 10
                buttonY6 = 2
            } else {
                button.frame = CGRect(x: buttonY+10, y: 0, width:(UIScreen.main.bounds.width-40)*1/3, height:(UIScreen.main.bounds.width-40)*1/3)
                buttonY6 = 1
            }
            button.contentMode = UIView.ContentMode.scaleToFill
            button.layer.cornerRadius = 10
            buttonY += (UIScreen.main.bounds.width-40)*1/3 + 10
            button.tag = index
            let tap = GenreTapGesture(target: self, action: #selector(buttonClicked))
            tap.id = String(genreData.genreId)
            tap.title = genreData.genreName!
            button.isUserInteractionEnabled = true
            button.addGestureRecognizer(tap)
            // button.addTarget(self, action:#selector(buttonClicked),for:.touchUpInside)
            //button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            //button.isUserInteractionEnabled = true
            //button.addGestureRecognizer(tapGestureRecognizer)
            genreButtonContainerSeeAll.addSubview(button)
            
            // genreButtonContainer.addSubview(genreTileFetched)
        }
        
        view.addSubview(genreSeeAllView)
        
    }
    
    @objc func allGenreBackButtonClicked(sender: UIButton) {
        genreSeeAllView.removeFromSuperview()
    }
    
    @objc func buttonClickedSeeAllGenre(recognizer: HomeTapGesture) {
        
        createGenreSeeAllView(view: self, title: "ByGenre".localizedString)
        print(recognizer.lname)
    }
    
    var songGenres:[SongGenre] = [SongGenre](){
        willSet{
            //genreButtonContainer.removeFromSuperview()
            //scrollGenres.removeFromSuperview()
        }
        didSet{
            var buttonY: CGFloat = 0, buttonY2: CGFloat = 0, buttonY3: CGFloat = 0, buttonY4: CGFloat = 0, buttonY5: CGFloat = 0, buttonY6: CGFloat = 0
            
            for (index, genreData) in songGenres.enumerated(){
                //let color = colorArray[index]
                let color:UIColor = UIHelper.colorWithHexString(hex: genreData.genreColor)
                
                let button = UIButton()
                button.backgroundColor = color
                button.setTitle(genreData.genreName, for: .normal)
                button.titleLabel!.font = UIFont(name: "Roboto", size: 13.0)
                button.titleLabel?.textColor = UIColor.white
                button.accessibilityHint = genreData.genreName!
                
                if (index>11) {
                    button.frame = CGRect(x: buttonY5, y: ((UIScreen.main.bounds.width-40)*1/3+10)*4, width:(UIScreen.main.bounds.width-40)*1/3, height:(UIScreen.main.bounds.width-40)*1/3)
                    buttonY5 += (UIScreen.main.bounds.width-40)*1/3 + 10
                    buttonY6 = 5
                } else if (index>8) {
                    button.frame = CGRect(x: buttonY4, y: ((UIScreen.main.bounds.width-40)*1/3+10)*3, width:(UIScreen.main.bounds.width-40)*1/3, height:(UIScreen.main.bounds.width-40)*1/3)
                    buttonY4 += (UIScreen.main.bounds.width-40)*1/3 + 10
                    buttonY6 = 4
                } else if (index>5) {
                    button.frame = CGRect(x: buttonY3, y: ((UIScreen.main.bounds.width-40)*1/3+10)*2, width:(UIScreen.main.bounds.width-40)*1/3, height:(UIScreen.main.bounds.width-40)*1/3)
                    buttonY3 += (UIScreen.main.bounds.width-40)*1/3 + 10
                    buttonY6 = 3
                } else if (index>2) {
                    button.frame = CGRect(x: buttonY2, y: (UIScreen.main.bounds.width-40)*1/3+10, width:(UIScreen.main.bounds.width-40)*1/3, height:(UIScreen.main.bounds.width-40)*1/3)
                    buttonY2 += (UIScreen.main.bounds.width-40)*1/3 + 10
                    buttonY6 = 2
                } else {
                    button.frame = CGRect(x: buttonY, y: 0, width:(UIScreen.main.bounds.width-40)*1/3, height:(UIScreen.main.bounds.width-40)*1/3)
                    buttonY6 = 1
                }
                button.contentMode = UIView.ContentMode.scaleToFill
                button.layer.cornerRadius = 10
                buttonY += (UIScreen.main.bounds.width-40)*1/3 + 10
                button.tag = index
                // button.addTarget(self, action:#selector(buttonClicked),for:.touchUpInside)
                let tap = GenreTapGesture(target: self, action: #selector(buttonClicked))
                tap.id = String(genreData.genreId)
                tap.title = genreData.genreName!
                button.isUserInteractionEnabled = true
                button.addGestureRecognizer(tap)
                //button.isUserInteractionEnabled = true
                //button.addGestureRecognizer(tapGestureRecognizer)
                genreButtonContainer.addSubview(button)
                
                // genreButtonContainer.addSubview(genreTileFetched)
            }
            //scrollGenres.contentSize = CGSize(width: UIScreen.main.bounds.width-20, height: ((UIScreen.main.bounds.width-40)*1/3)*buttonY6+30)
            //scrollGenres.isScrollEnabled = false
            // scrollGenres.scrollRectToVisible(genreViewArray[0].frame, animated: true)
        }
    }
    
    var songGenresAll:[SongGenre] = [SongGenre]()
    
    @objc func buttonClicked(recognizer: GenreTapGesture) {
        genreInstance.name = recognizer.title
        createGenre(id: Int(recognizer.id)!, genreName: recognizer.title)
        
        /*if(sender.tag == 5){
         
         var abc = "argOne" //Do something for tag 5
         }
         print("hello")*/
    }
    
    func loadAllArtistsList() {
        self.browseDataModel.getBrowseAllArtists(getBrowseAllArtistsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.browseDataModel.allArtistsList.chunked(into: 10)
                    self.allArtistList = self.browseDataModel.allArtistsList.count > 10 ? minimizedArray[0] : self.browseDataModel.allArtistsList
                    
                    self.allArtistListSeeAll = self.browseDataModel.allArtistsList
                    
                    self.loadBrowseAllArtistsViews(view: self.scrollMain)
                    self.createBrowseArtistSeeAllView(view: self.viewAllBrowseArtists, title: "Byartist".localizedString)
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    @objc func goGenreButtonClicked(sender:UIButton) {
        
        genreView.isHidden = true
        
        /*if(sender.tag == 5){
         
         var abc = "argOne" //Do something for tag 5
         }
         print("hello")*/
    }
    
    func createGenre(id: Int, genreName: String) {
        
        genreView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        genreView.backgroundColor = Constants.color_background
        
        genreViewContentScroll = UIScrollView(frame: CGRect(x: 0, y: 40, width: self.frame.width, height: self.frame.height))
        genreViewContentScroll.showsHorizontalScrollIndicator = false
        genreViewContentScroll.showsVerticalScrollIndicator = false
        
        genreViewContent = UIView(frame: CGRect(x: 0, y: 0, width: genreViewContentScroll.frame.width, height: (UIScreen.main.bounds.width-40)*1/3+30+(UIScreen.main.bounds.width-40)*1/3+10+UIScreen.main.bounds.width/2-30+500))
        
        genreViewContentScroll.addSubview(genreViewContent)
        
        genreViewContentScroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height:genreViewContent.frame.height)
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let songBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        //songBar.backgroundColor = UIColor.blue
        
        let artistsBar = UIView(frame: CGRect(x: 0, y: songBar.frame.height+((UIScreen.main.bounds.width-40)*1/3+30), width: UIScreen.main.bounds.width, height: 40))
        //artistsBar.backgroundColor = UIColor.blue
        
        let playListBar = UIView(frame: CGRect(x: 0, y: songBar.frame.height+artistsBar.frame.height+((UIScreen.main.bounds.width-40)*1/3+30)+((UIScreen.main.bounds.width-40)*1/3+10), width: UIScreen.main.bounds.width, height: 40))
        //playListBar.backgroundColor = UIColor.blue
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(goGenreButtonClicked), for: .touchUpInside)
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: self.frame.width, height:40)
        labelSongs.text = "Song".localizedString
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: 10, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelSongsSeeAll.layer.cornerRadius = 10
        labelSongsSeeAll.textColor = UIColor.white
        labelSongsSeeAll.layer.masksToBounds = true
        labelSongsSeeAll.backgroundColor = Constants.color_brand
        let tap = HomeTapGesture(target: self, action: #selector(buttonClickedSeeAllSongs))
        tap.lname = "Songs"
        labelSongsSeeAll.isUserInteractionEnabled = true
        labelSongsSeeAll.addGestureRecognizer(tap)
        
        let labelArtists = UILabel()
        labelArtists.frame = CGRect(x: 10, y: 0, width: self.frame.width, height:40)
        labelArtists.text = "Artist".localizedString
        labelArtists.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelArtists.textColor = UIColor.white
        
        let labelByArtistsSeeAll = UILabel()
        labelByArtistsSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: 10, width: 70, height:20)
        labelByArtistsSeeAll.text = "ViewAll".localizedString
        labelByArtistsSeeAll.textAlignment = .center
        labelByArtistsSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelByArtistsSeeAll.layer.cornerRadius = 10
        labelByArtistsSeeAll.textColor = UIColor.white
        labelByArtistsSeeAll.layer.masksToBounds = true
        labelByArtistsSeeAll.backgroundColor = Constants.color_brand
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(buttonClickedSeeAllArtist))
        labelByArtistsSeeAll.isUserInteractionEnabled = true
        labelByArtistsSeeAll.addGestureRecognizer(tap2)
        
        let labelPlayList = UILabel()
        labelPlayList.frame = CGRect(x: 10, y: 0, width: self.frame.width, height:40)
        labelPlayList.text = "Playlists".localizedString
        labelPlayList.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelPlayList.textColor = UIColor.white
        
        let labelPlayListSeeAll = UILabel()
        labelPlayListSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: 10, width: 70, height:20)
        labelPlayListSeeAll.text = "ViewAll".localizedString
        labelPlayListSeeAll.textAlignment = .center
        labelPlayListSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
        labelPlayListSeeAll.layer.cornerRadius = 10
        labelPlayListSeeAll.textColor = UIColor.white
        labelPlayListSeeAll.layer.masksToBounds = true
        labelPlayListSeeAll.backgroundColor = Constants.color_brand
        let tapPlayList = HomeTapGesture(target: self, action: #selector(buttonClickedSeeAllPlaylist))
        tapPlayList.lname = "Latest Playlist"
        labelPlayListSeeAll.isUserInteractionEnabled = true
        labelPlayListSeeAll.addGestureRecognizer(tapPlayList)
        
        loadGenreSongsViews()
        
        topBar.addSubview(arrow)
        genreView.addSubview(topBar)
        
        songBar.addSubview(labelSongs)
        songBar.addSubview(labelSongsSeeAll)
        genreViewContent.addSubview(songBar)
        
        
        
        artistsBar.addSubview(labelArtists)
        artistsBar.addSubview(labelByArtistsSeeAll)
        genreViewContent.addSubview(artistsBar)
        
        playListBar.addSubview(labelPlayList)
        playListBar.addSubview(labelPlayListSeeAll)
        genreViewContent.addSubview(playListBar)
        
        genreView.addSubview(genreViewContentScroll)
        self.addSubview(genreView)
        
        
        //getSongsOfGenre(genre:genreName)
        loadGenreSongList(genre:genreName)
        loadGenreArtistsList(id: id)
        //loadGenrePlaylistList()
        loadPlaylists(id: id)
        
        
    }
    
    @objc func buttonClickedSeeAllPlaylist(recognizer: HomeTapGesture) {
        self.createGenrePlaylistAllView(view: self)
    }
    
    func createGenreSeeAllArtists() {
        
        genreViewSeeAllArtist = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        genreViewSeeAllArtist.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(goGenreButtonClickedArtist), for: .touchUpInside)
        
        let text = UILabel(frame: CGRect(x: 40, y: 10, width: 100, height: 20))
        text.text = "Artist".localizedString
        text.textColor = UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(text)
        genreViewSeeAllArtist.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: self.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height: CGFloat(browseGenreArtistListSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(browseGenreArtistListSeeAll.count)*20)+370))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height: CGFloat(browseGenreArtistListSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(browseGenreArtistListSeeAll.count)*20)+370)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in browseGenreArtistListSeeAll.enumerated(){
            let songTile = SongTileSeeAllArtist(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            if tileData.songsCount! > 0 {
                songTile.albums.text = String(tileData.songsCount!)+" songs"
            }
            if tileData.numberOfAlbums! > 0 {
                //songTile.albums.text = String (tileData.numberOfAlbums!)+" albums"
            }
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedArtist))
            tap.id = tileData.id
            tap.aname = tileData.name
            tap.songs = tileData.songsCount!
            tap.url = decodedImage
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            let tapAdd = PlaylistPlayGesture(target: self, action: #selector(buttonClickedAddArtistToLibrary))
            tapAdd.id = tileData.id
            songTile.add.isUserInteractionEnabled = true
            songTile.add.addGestureRecognizer(tapAdd)
            
            songTile.styleType = self.styleType
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
            if index == 0 {
                selectedTileSeeAllArtist = songTile
                songTile.isSelected = true
            }
            tilesSeeAllArtist.append(songTile)
        }
        genreViewSeeAllArtist.addSubview(one)
        self.addSubview(genreViewSeeAllArtist)
    }
    
    @objc func goGenreButtonClickedArtist(sender:UIButton) {
        genreViewSeeAllArtist.isHidden = true
        
    }
    @objc func buttonClickedArtist(recognizer: MyTapGesture) {
        if recognizer.songs==0 {
            createArtistDetails(id: recognizer.id, name: recognizer.aname, url: recognizer.url, album: "", song: String(recognizer.songs)+" Songs")
        } else {
            createArtistDetails(id: recognizer.id, name: recognizer.aname, url: recognizer.url, album: "", song: String(recognizer.songs)+" Songs")
        }
    }
    
    @objc func buttonClickedBrowseArtist(recognizer: MyTapGesture) {
        createArtistDetails(id: recognizer.id, name: recognizer.aname, url: recognizer.url, album: "", song: String(recognizer.songs)+" Songs")
    }
    
    var vi = UIView(frame: CGRect.zero)
    func createArtistDetails(id: Int, name: String, url: String, album: String, song: String) {
        vi = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        vi.backgroundColor = Constants.color_background
        //vi.isUserInteractionEnabled = false
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(goArtistButtonClicked), for: .touchUpInside)
        
        topBar.addSubview(arrow)
        vi.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height, width: vi.frame.width , height: self.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:420+UIScreen.main.bounds.width/3+UIScreen.main.bounds.width/2+10+UIScreen.main.bounds.width*1/3))
        one.addSubview(two)
        //one.contentSize = CGSize(width: one.frame.width, height:two.frame.height)
        
        one.contentSize = CGSize(width: one.frame.width, height:UIScreen.main.bounds.width/3+100)
        
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
        
        loadSongByArtistList(id: id)
        two.addSubview(labelSong)
        two.addSubview(labelSongByArtistSeeAll)
        
        loadSongByArtistViews(view: one)
        
        vi.addSubview(one)
        
        self.addSubview(vi)
    }
    
    @objc func buttonClickedAddArtistToLibrary(recognizer: PlaylistPlayGesture) {
        
        addToLibrary(key: "A", songs: recognizer.id)
    }
    
    func addToLibrary(key: String, songs: Int) {
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        self.homeDataModel.addToLibrary(key: key, songs: songs, addToLibraryCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.alert(message: "AddedToLibrary".localizedString)
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
    
    @objc func buttonClickedSeeAllArtistBySongs(recognizer: PlaylistPlayGesture) {
        
        createSongsSeeAllView(view: viewAllSongs, title: "Songs By Artist")
        self.addSubview(viewAllSongs)
        loadAllSongByArtistList(id: recognizer.id)
        //viewAllPopularArtistSongs.isHidden = false
        //
        
    }
    
    @objc func goArtistButtonClicked(sender:UIButton) {
        
        vi.isHidden = true
        
        /*if(sender.tag == 5){
         
         var abc = "argOne" //Do something for tag 5
         }
         print("hello")*/
    }
    
    @objc func buttonClickedSeeAllArtist(sender:UIButton) {
        
        /*if(sender.tag == 5){
         
         var abc = "argOne" //Do something for tag 5
         }
         print("hello")*/
        print("createGenreSeeAllArtists()")
        createGenreSeeAllArtists()
    }
    
    //Artist Details/ Album by artist
    func loadAlbumByArtistViews(view: UIView) {
        let viewAlbumByArtist = UIView(frame: CGRect(x: 0, y: 80+UIScreen.main.bounds.width/3, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width/2+10))
        //viewAlbumByArtist.backgroundColor = UIColor.yellow
        
        let albumByArtistViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewAlbumByArtist.frame.width, height: viewAlbumByArtist.frame.height))
        //albumByArtistViewContent.backgroundColor = UIColor.gray
        
        scrollCollectionAlbumByArtist = ScrollCollectionBrowse(frame: CGRect(x: 0, y: 0, width: albumByArtistViewContent.frame.width, height: albumByArtistViewContent.frame.height))
        scrollCollectionAlbumByArtist?.styleType = 18
        albumByArtistViewContent.addSubview(scrollCollectionAlbumByArtist!)
        
        viewAlbumByArtist.addSubview(albumByArtistViewContent)
        
        view.addSubview(viewAlbumByArtist)
        
    }
    
    //Artist Details/ Song by artist
    func loadSongByArtistViews(view: UIView) {
        //let viewAlbumByArtist = UIView(frame: CGRect(x: 0, y: 130+UIScreen.main.bounds.width/3+UIScreen.main.bounds.width/2, width: UIScreen.main.bounds.width , height: ((UIScreen.main.bounds.width-40)*1/3-10)+40))
        
        let viewAlbumByArtist = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width/3+110, width: UIScreen.main.bounds.width , height: ((UIScreen.main.bounds.width-40)*1/3-10)+40))
        //viewAlbumByArtist.backgroundColor = UIColor.yellow
        
        
        let albumByArtistViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewAlbumByArtist.frame.width, height: viewAlbumByArtist.frame.height))
        //albumByArtistViewContent.backgroundColor = UIColor.gray
        
        scrollCollectionSongByArtist = ScrollCollectionBrowse(frame: CGRect(x: 0, y: 0, width: albumByArtistViewContent.frame.width, height: albumByArtistViewContent.frame.height))
        scrollCollectionSongByArtist?.styleType = 15
        scrollCollectionSongByArtist?.playerView = self.parentVC.playerView
        albumByArtistViewContent.addSubview(scrollCollectionSongByArtist!)
        
        viewAlbumByArtist.addSubview(albumByArtistViewContent)
        
        view.addSubview(viewAlbumByArtist)
        
    }
    
    func loadAllSongsGenres() {
        self.allSongsModel.getAllSongsGenreList(getAllSongsGenreListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.songGenres = self.allSongsModel.allGenreList
                    self.songGenresAll = self.allSongsModel.allGenreList
                })
            }
        })
    }
    
    func loadAllSongs() {
        
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        
        self.allSongsModel.getAllSongsList(offset: self.allSongs.count, getAllSongsListCallFinished: { (status, error, userInfo) in
            if status{
                
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                    self.parentVC.playerView.currentPlayingList = self.allSongsModel.allSongsList
                    self.allSongs = self.allSongsModel.allSongsList
                    self.currentShowingSongs = self.allSongsModel.allSongsList
                })
            }else{
                
                
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    
    
    func loadPopularArtistsList() {
        self.homeDataModel.getPopularSongs(getPopularSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.homeDataModel.popularSongsList.chunked(into: 10)
                    self.scrollCollectionMinimizedPopularArtists?.browsePlayingList = self.homeDataModel.popularSongsList.count > 10 ? minimizedArray[0] : self.homeDataModel.popularSongsList
                    
                    self.scrollCollectionExapndedPopularArtists?.browsePlayingList = self.homeDataModel.popularSongsList
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    /*func loadPopularArtistsList() {
     self.homeDataModel.getPopularSongs(getPopularSongsListCallFinished: { (status, error, userInfo) in
     if status{
     DispatchQueue.main.async(execute: {
     let minimizedArray = self.homeDataModel.popularSongsList.chunked(into: 10)
     self.currentPlayingList = self.homeDataModel.popularSongsList.count > 10 ? minimizedArray[0] : self.homeDataModel.popularSongsList
     })
     } else {
     DispatchQueue.main.async(execute: {})
     }
     })
     }*/
    
    func loadGenreSongList(genre:String) {
        ProgressView.shared.show(genreView, mainText: nil, detailText: nil)
        self.browseDataModel.getSongsByGenre(offset: 0, genre: genre, getSongsOfGenreCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.browseDataModel.genreSongsList.chunked(into: 10)
                    self.scrollCollectionMinimizedGenreSongs?.browsePlayingList = self.browseDataModel.genreSongsList.count > 10 ? minimizedArray[0] : self.browseDataModel.genreSongsList
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func loadAllGenreSongsList(offset: Int, genre:String) {
        
        ProgressView.shared.show(self.viewAllSongs, mainText: nil, detailText: nil)
        self.browseDataModel.getSongsByGenre(offset: offset, genre: genre, getSongsOfGenreCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    //self.scrollCollectionExapndedGenreSongs?.browsePlayingList = self.browseDataModel.genreSongsList
                    self.genreSongsList.append(contentsOf: self.browseDataModel.genreSongsList)
                    self.viewAllSongs.removeFromSuperview()
                    self.createSongsSeeAllView(view: self.viewAllSongs, title: genreInstance.name)
                    let x = UIScreen.main.bounds.width/6+20
                    var y = 0
                    if self.genreSongsList.count>15 {
                        y = self.genreSongsList.count-15
                    }
                    self.scrollView2.contentOffset = CGPoint(x: 0, y: Int(x)*y)
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {ProgressView.shared.hide()})
            }
        })
    }
    
    func loadGenreArtistsList(id: Int) {
        self.browseDataModel.getBrowseGenreArtists(id: id, getBrowseGenreArtistsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.browseDataModel.genreArtistsList.chunked(into: 10)
                    self.browseGenreArtistList = self.browseDataModel.genreArtistsList.count > 10 ? minimizedArray[0] : self.browseDataModel.genreArtistsList
                    
                    self.browseGenreArtistListSeeAll = self.browseDataModel.genreArtistsList
                    //print("browseGenreArtistList ",self.browseGenreArtistList)
                    self.loadBrowseGenreArtistsViews(view: self.genreViewContent)
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func loadGenrePlaylistList() {
        self.homeDataModel.getPopularSongs(getPopularSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.homeDataModel.popularSongsList.chunked(into: 10)
                    self.scrollCollectionMinimizedGenrePlaylist?.browsePlayingList = self.homeDataModel.popularSongsList.count > 10 ? minimizedArray[0] : self.homeDataModel.popularSongsList
                    
                    // self.scrollCollectionExapndedPopularArtists?.currentPlayingList = self.homeDataModel.popularSongsList
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func loadAlbumByArtistList() {
        self.homeDataModel.getPopularSongs(getPopularSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.homeDataModel.popularSongsList.chunked(into: 10)
                    self.scrollCollectionAlbumByArtist?.browsePlayingList = self.homeDataModel.popularSongsList.count > 10 ? minimizedArray[0] : self.homeDataModel.popularSongsList
                    
                    // self.scrollCollectionExapndedPopularArtists?.currentPlayingList = self.homeDataModel.popularSongsList
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func loadSongByArtistList(id: Int) {
        ProgressView.shared.show(vi, mainText: nil, detailText: nil)
        self.browseDataModel.getBrowseSongsByArtist(id: id, getBrowseArtistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    
                    let minimizedArray = self.browseDataModel.SongsByArtistList.chunked(into: 10)
                    self.scrollCollectionSongByArtist?.browsePlayingList = self.browseDataModel.SongsByArtistList.count > 10 ? minimizedArray[0] : self.browseDataModel.SongsByArtistList
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
        
    }
    
    func loadAllSongByArtistList(id: Int) {
        
        self.browseDataModel.getBrowseSongsByArtist(id: id, getBrowseArtistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    
                    self.scrollCollectionExapndedSongByArtist?.browsePlayingList = self.browseDataModel.SongsByArtistList
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
        
    }
    
    //All Artists View Browse
    func loadBrowseAllArtistsViews(view: UIView) {
        
        let viewArtist = UIScrollView(frame: CGRect(x: 0, y: genreButtonContainer.frame.height+90, width: UIScreen.main.bounds.width , height: (UIScreen.main.bounds.width-40)*1/3+10))
        //viewGenreSongs.backgroundColor = UIColor.yellow
        viewArtist.showsHorizontalScrollIndicator = false
        viewArtist.showsVerticalScrollIndicator = false
        
        let artistContent = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(allArtistList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: viewArtist.frame.height))
        //artistContent.backgroundColor = UIColor.gray
        
        viewArtist.addSubview(artistContent)
        
        viewArtist.contentSize = CGSize(width: CGFloat(allArtistList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: viewArtist.frame.height)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in allArtistList.enumerated(){
            
            let songTile = SongTileHomeArtists(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
            //songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedBrowseArtist))
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
    
    //All Artists View All Browse
    func createBrowseArtistSeeAllView(view: UIView, title: String) {
        viewAllBrowseArtists.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(goAllArtistBackButtonClicked), for: .touchUpInside)
        
        let text = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        text.text = title
        text.textColor = UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(text)
        viewAllBrowseArtists.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: self.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:  CGFloat(allArtistListSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allArtistListSeeAll.count)*20)+340))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height: two.frame.height)
        
        var xLength: CGFloat = 10
        
        for (_, tileData) in allArtistListSeeAll.enumerated(){
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
        viewAllBrowseArtists.addSubview(one)
        viewAllBrowseArtists.isHidden = true
    }
    
    @objc func buttonClickedSeeAllBrowseArtist(recognizer: HomeTapGesture) {
        
        viewAllBrowseArtists.isHidden = false
    }
    
    @objc func goAllArtistBackButtonClicked(sender:UIButton) {
        viewAllBrowseArtists.isHidden = true
    }
    
    func loadPopularArtistsViews() {
        viewPopularArtists = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width*1/3))
        viewScrollPopularArtists = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: viewPopularArtists.frame.height))
        viewPopularArtists.addSubview(viewScrollPopularArtists)
        artistButtonContainer.addSubview(viewPopularArtists)
        
        scrollCollectionMinimizedPopularArtists = ScrollCollectionBrowse(frame: CGRect(x: 0, y: 0, width: viewScrollPopularArtists.frame.width, height: viewScrollPopularArtists.frame.height))
        scrollCollectionMinimizedPopularArtists?.styleType = 13
        self.viewScrollPopularArtists.addSubview(scrollCollectionMinimizedPopularArtists!)
    }
    
    //Genre Songs View
    func loadGenreSongsViews() {
        viewGenreSongs = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width , height: (UIScreen.main.bounds.width-40)*1/3+30))
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        scrollCollectionMinimizedGenreSongs = ScrollCollectionBrowse(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionMinimizedGenreSongs?.styleType = 15
        scrollCollectionMinimizedGenreSongs?.playerView = self.parentVC.playerView
        songsViewContent.addSubview(scrollCollectionMinimizedGenreSongs!)
        viewGenreSongs.addSubview(songsViewContent)
        genreViewContent.addSubview(viewGenreSongs)
    }
    
    //Artists View
    func loadBrowseGenreArtistsViews(view: UIView) {
        let viewArtist = UIScrollView(frame: CGRect(x: 0, y: 80+viewGenreSongs.frame.height, width: UIScreen.main.bounds.width , height: (UIScreen.main.bounds.width-40)*1/3+10))
        viewArtist.showsHorizontalScrollIndicator = false
        viewArtist.showsVerticalScrollIndicator = false
        
        let artistContent = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(browseGenreArtistList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: viewArtist.frame.height))
        viewArtist.addSubview(artistContent)
        viewArtist.contentSize = CGSize(width: CGFloat(browseGenreArtistList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: viewArtist.frame.height)
        
        var xLength: CGFloat = 10
        for (index, tileData) in browseGenreArtistList.enumerated(){
            
            let songTile = SongTileBrowseArtists(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedArtist))
            tap.id = tileData.id
            tap.aname = tileData.name
            tap.songs = tileData.songsCount!
            tap.url = decodedImage
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            xLength += ((UIScreen.main.bounds.width-40)*1/3)
            artistContent.addSubview(songTile)
        }
        view.addSubview(viewArtist)
    }
    
    @objc func buttonClickedSeeAllSongs(recognizer: HomeTapGesture) {
        genreSongsList.removeAll()
        self.createSongsSeeAllView(view: self.viewAllSongs, title: genreInstance.name)
        self.addSubview(self.viewAllSongs)
        loadAllGenreSongsList(offset: 0, genre: genreInstance.name)
        
    }
    
    func timeString(time: TimeInterval) -> String {
        let t = time*60
        
        let minute = Int(t) / 60
        let second = Int(t) % 60
        
        return String(format: "%02i:%02i", minute, second)
    }
    
    var scrollView2 = UIScrollView()
    var scrollHeight: CGFloat = 0
    var genreSongsList: [Song] = [Song]()
    func createSongsSeeAllView(view: UIView, title: String) {
        
        viewAllSongs = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        viewAllSongs.backgroundColor = Constants.color_background
        
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(viewAllSongsButtonClicked), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        label.text = "Song".localizedString
        label.textColor = .white
        
        topBar.addSubview(arrow)
        topBar.addSubview(label)
        
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-40))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        if title == "Songs By Artist" {
            scrollCollectionExapndedSongByArtist = ScrollCollectionBrowse(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
            scrollCollectionExapndedSongByArtist?.styleType = 19
            scrollCollectionExapndedSongByArtist?.playerView = self.parentVC.playerView
            songsViewContent.addSubview(scrollCollectionExapndedSongByArtist!)
            
        } else {
            //scrollCollectionExapndedGenreSongs = ScrollCollectionBrowse(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
            //scrollCollectionExapndedGenreSongs?.styleType = 19
            //scrollCollectionExapndedGenreSongs?.playerView = self.parentVC.playerView
            
            scrollView2 = UIScrollView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-40))
            scrollView2.showsHorizontalScrollIndicator = false
            scrollView2.showsVerticalScrollIndicator = false
            scrollView2.delegate = self
            scrollView2.contentOffset = CGPoint(x: 0, y: 0)
            songsViewContent.addSubview(scrollView2)
            
            contentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView2.frame.width, height: CGFloat(self.genreSongsList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(self.genreSongsList.count)*20)+290))
            scrollView2.addSubview(contentView)
            scrollView2.contentSize = CGSize(width: scrollView2.frame.width, height: CGFloat(self.genreSongsList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(self.genreSongsList.count)*20)+290)
            
            var xLength: CGFloat = 10
            
            for (index, tileData) in self.genreSongsList.enumerated(){
                let songTile = SongTileBrowseListSquareSongs(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
                songTile.lblDescription.text = tileData.artist
                songTile.lblTitle.text = tileData.name
                var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                songTile.index = index
                songTile.albums.text = timeString(time: TimeInterval(tileData.duration!))
                songTile.songs.text = String(tileData.date!)
                
                let tapAdd = PlaylistTapGesture(target: self, action: #selector(buttonClick_genreSongAdd))
                tapAdd.title = tileData.name
                tapAdd.id = String(tileData.id)
                songTile.add.isUserInteractionEnabled = true
                songTile.add.addGestureRecognizer(tapAdd)
                
                let tapGestureRecognizer = PlaylistPlayGesture(target: self, action: #selector(buttonClickedGenreSongPlay))
                tapGestureRecognizer.id = index
                songTile.isUserInteractionEnabled = true
                songTile.addGestureRecognizer(tapGestureRecognizer)
                // songTile.styleType = self.styleType
                xLength += UIScreen.main.bounds.width/6+20
                contentView.addSubview(songTile)
                if index == 0 {
                    // selectedTileListSquareSongs = songTile
                    songTile.isSelected = true
                }
                
            }
            //songsViewContent.addSubview(contentView)
            //songsViewContent.addSubview(scrollCollectionExapndedGenreSongs!)
        }
        
        
        
        
        
        viewGenreSongs.addSubview(songsViewContent)
        
        //view.addSubview(viewGenreSongs)
        
        viewAllSongs.addSubview(topBar)
        viewAllSongs.addSubview(viewGenreSongs)
        self.addSubview(viewAllSongs)
    }
    
    @objc func buttonClick_genreSongAdd(sender:PlaylistTapGesture) {
        showAddAlertDialog(title: sender.title, id: sender.id)
    }
    
    @objc func viewAllSongsButtonClicked(sender: UIButton) {
        viewAllSongs.isHidden = true
    }
    
    func loadPlaylists(id: Int) {
        
        self.browseDataModel.getGenrePlaylists(id: id, getGenrePlaylistCallFinished: { (status, error, userInfo) in
            if status {
                self.parentVC.allSongs?.genrePlayLists = self.browseDataModel.genrePlaylists
                self.parentVC.allSongs?.genrePlayListsAll = self.browseDataModel.genrePlaylists
                //self.parentVC.home?.globalPlayListsAll = self.homeDataModel.globalPlaylists
                self.createGenrePlaylistView(view: self.genreViewContent)
                ProgressView.shared.hide()
            }
        })
    }
    
    var viewAllPlayList = UIView(frame: CGRect.zero)
    func createGenrePlaylistView(view: UIView) {
        
        
        let scrollPlayList = UIScrollView(frame: CGRect(x: 0, y: 120+viewGenreSongs.frame.height+(UIScreen.main.bounds.width-40)*1/3+10, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.width/2-10))
        scrollPlayList.showsHorizontalScrollIndicator = false
        scrollPlayList.showsVerticalScrollIndicator = false
        
        let playListContentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(genrePlayLists.count)*(UIScreen.main.bounds.width/2-20)+10, height: scrollPlayList.frame.height))
        
        scrollPlayList.addSubview(playListContentView)
        
        scrollPlayList.contentSize = CGSize(width: CGFloat(genrePlayLists.count)*(UIScreen.main.bounds.width/2-20)+10, height: scrollPlayList.frame.height)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in genrePlayLists.enumerated(){
            let playListTile = PlayListTile(frame: CGRect(x: xLength, y: 0, width: UIScreen.main.bounds.width/2-30, height: UIScreen.main.bounds.width/2-30))
            playListTile.lblTitle.text = tileData.name
            
            var decodedImage: String = ""
            decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            playListTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            
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
        
        view.addSubview(scrollPlayList)
    }
    
    
    func createGenrePlaylistAllView(view: UIView) {
        viewAllPlayList = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(goAllPlaylistBackButtonClicked), for: .touchUpInside)
        viewAllPlayList.addSubview(arrow)
        viewAllPlayList.backgroundColor = Constants.color_background
        
        let scrollPlayList = UIScrollView(frame: CGRect(x: 10, y: 40, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-40))
        scrollPlayList.showsHorizontalScrollIndicator = false
        scrollPlayList.showsVerticalScrollIndicator = false
        
        let playListContentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollPlayList.frame.width, height: CGFloat(genrePlayListsAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(genrePlayListsAll.count)*20)+290))
        scrollPlayList.addSubview(playListContentView)
        scrollPlayList.contentSize = CGSize(width: scrollPlayList.frame.width, height: CGFloat(genrePlayListsAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(genrePlayListsAll.count)*20)+290)
        
        var xLength: CGFloat = 10
        for (index, tileData) in genrePlayListsAll.enumerated(){
            let playListTile = PlayListTileAll(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            playListTile.lblTitle.text = tileData.name
            var decodedImage: String = ""
            decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            playListTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
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
        viewAllPlayList.addSubview(scrollPlayList)
        self.addSubview(viewAllPlayList)
    }
    
    @objc func goAllPlaylistBackButtonClicked(sender:UIButton) {
        viewAllPlayList.isHidden = true
    }
    
    @objc func buttonClickedPlaylistDetails(recognizer: PlaylistTapGesture) {
        print("Printer ", recognizer.id," ", recognizer.title)
        ProgressView.shared.show(genreView, mainText: nil, detailText: nil)
        loadAllLatestPlaylistSongsList(id: recognizer.id, url: recognizer.image, title: recognizer.title, songs_count: recognizer.songs, date: recognizer.year)
        
    }
    
    func loadAllLatestPlaylistSongsList(id: String, url: String, title: String, songs_count: String, date: String) {
        self.homeDataModel.getLatestPlaylistSongs(id: id, getHomeLatestPlaylistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    //self.scrollCollectionExapndedLatestPlaylistSongs?.currentPlayingList = self.homeDataModel.latestPlaylistSongsList
                    self.genrePlayList = self.homeDataModel.latestPlaylistSongsList
                    
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
        //vi.isUserInteractionEnabled = false
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(goPlaylistButtonClicked), for: .touchUpInside)
        topBar.addSubview(arrow)
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4+90))
        titleContainer.backgroundColor = Constants.color_background
        titleContainer.isUserInteractionEnabled = true
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height+titleContainer.frame.height, width: self.frame.width, height: self.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height: CGFloat(genrePlayList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(genrePlayList.count)*20)+370+UIScreen.main.bounds.width/4+40))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height:CGFloat(genrePlayList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(genrePlayList.count)*20)+370+UIScreen.main.bounds.width/4+40)
        
        one.isUserInteractionEnabled = true
        two.isUserInteractionEnabled = true
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4))
        var decodedImage = url.replacingOccurrences(of: "%3A", with: ":")
        decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
        image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
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
        year.text = genreInstance.name
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
        
        //labelPlaySong.textAlignment = .center
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
        labelAddSong.font = UIFont(name: "Roboto-Bold", size: 9.0)
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
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in genrePlayList.enumerated(){
            let songTile = PlayListSongsTileAll(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblDescription.text = tileData.artist
            songTile.lblTitle.text = tileData.name
            //songTile.imageURL = tileData.image!
            songTile.image.sd_setImage(with: URL(string: tileData.image!), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickAddSongToPlaylist))
            tap.title = tileData.name
            tap.id = String(tileData.id)
            songTile.add.isUserInteractionEnabled = true
            songTile.add.addGestureRecognizer(tap)
            
            let tapPlay = PlaylistPlayGesture(target: self, action: #selector(buttonClickedPlaylistSongPlay))
            tapPlay.id = index
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tapPlay)
            //let tap = PlaylistPlayGesture(target: self, action: #selector(buttonClickedPlaylistPlay))
            //tap.id = 29
            //songTile.isUserInteractionEnabled = true
            //songTile.addGestureRecognizer(tap)
            /*songTile.playListId = tileData.id
             songTile.btnPlay?.tag = tileData.id
             songTile.btnPlay!.addTarget(self, action: #selector(self.actPlayList(_:)), for: UIControl.Event.touchUpInside)*/
            
            
            songTile.styleType = self.styleType
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
            //if index == 0 {
            //  selectedTileSeeAllArtist = songTile
            //   songTile.isSelected = true
            //}
            //tilesSeeAllArtist.append(songTile)
        }
        
        viewLatestPlaylistDetails.addSubview(topBar)
        viewLatestPlaylistDetails.addSubview(titleContainer)
        viewLatestPlaylistDetails.addSubview(one)
        
        self.addSubview(viewLatestPlaylistDetails)
    }
    
    @objc func buttonClickAddSongToPlaylist(sender: PlaylistTapGesture) {
        showAddAlertDialog(title: sender.title, id: sender.id)
    }
    
    func showAddAlertDialog(title: String, id: String) {
        overLayView.removeFromSuperview()
        self.addSubview(overLayView)
        self.addSubview(addAlertDialog)
        addAlertDialog.lblTitle.text = title
        addAlertDialog.id = Int(id)!
        addAlertDialog.isHidden = false
    }
    
    @objc func buttonClickedPlaylistSongPlay(recognizer: PlaylistPlayGesture) {
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            self.parentVC.playerView?.radioStatus = "song"
            self.parentVC.playerView.pause()
            self.parentVC.playerView.currentPlayingList = genrePlayList
            self.parentVC.playerView.currentPlayingIndex = recognizer.id
            self.parentVC.playerView.currentPlayingTime = 0
            self.parentVC.playerView.scrollCollection.changeSong(index: recognizer.id)
            self.parentVC.playerView.play()
        }
    }
    
    @objc func buttonClickedGenreSongPlay(recognizer: PlaylistPlayGesture) {
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            self.parentVC.playerView?.radioStatus = "song"
            self.parentVC.playerView.pause()
            self.parentVC.playerView.currentPlayingList = genreSongsList
            self.parentVC.playerView.currentPlayingIndex = recognizer.id
            self.parentVC.playerView.currentPlayingTime = 0
            self.parentVC.playerView.scrollCollection.changeSong(index: recognizer.id)
            self.parentVC.playerView.play()
        }
    }
    
    @objc func buttonClickedAddPlaylistToLibrary(recognizer: PlaylistPlayGesture) {
        addToLibrary(key: "P", songs: recognizer.id)
    }
    
    @objc func buttonClickedPlaylistPlay(recognizer: PlaylistPlayGesture) {
        print("playlistid ", recognizer.id)
        loadSongsOfGlobalPlaylistGlobal(listID: recognizer.id)
    }
    
    let playlistModel = PlaylistModel()
    func loadSongsOfGlobalPlaylistGlobal(listID:Int){
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
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            
            if currentPlayingListId != String(listID) {
                currentPlayingListId = String(listID)
                self.parentVC.playerView.pause()
                self.parentVC.playerView.currentPlayingList = genrePlayList
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
}

extension BrowseViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let shouldRequestForRemaingEpisodes = offsetY + 100 > contentHeight - scrollView.frame.size.height
        if (shouldRequestForRemaingEpisodes) {// && self.isOnAllSongsTab) {
            print("Scrolling5")
            loadAllGenreSongsList(offset: genreSongsList.count, genre: genreInstance.name)
            //createSongsSeeAllView(view: viewAllSongs, title: genreInstance.name)
            
            //self.addSubview(viewAllSongs)
            //self.fetchRemainingSongs()
            // self.scrollHeight = scrollView2.contentSize.height - scrollView2.frame.size.height
        }
    }
}
