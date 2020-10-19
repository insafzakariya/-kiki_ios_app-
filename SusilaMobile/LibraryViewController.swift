//
//  LibraryViewController.swift
//  SusilaMobile
//
//  Created by Kiroshan T on 11/27/19.
//  Copyright © 2019 Isuru Jayathissa. All rights reserved.
//

import UIKit

class LibraryViewController: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parentVC: DashboardViewController!
    let homeDataModel = HomeDataModel()
    let libraryDataModel = LibraryDataModel()
    var playlistItem = PlaylistItem()
    
    var playlistStatus = false
    
    var viewAllLibrarySongs = UIView(frame: CGRect.zero)
    var viewAllLibraryArtists = UIView(frame: CGRect.zero)
    var viewAllLibraryPlaylists = UIView(frame: CGRect.zero)
    var viewAllLibraryArtistDetails = UIView(frame: CGRect.zero)
    var viewAllBrowseArtistSongs = UIView(frame: CGRect.zero)
    var viewUserPlaylistDetails = UIView(frame: CGRect.zero)
    var viewAllSelectPlaylists = UIView(frame: CGRect.zero)
    var viewAllSelectSongs = UIView(frame: CGRect.zero)
    var viewAllSelectArtists = UIView(frame: CGRect.zero)
    var viewSelectPlaylistDetails = UIView(frame: CGRect.zero)
    var viewSelectArtistDetails = UIView(frame: CGRect.zero)
    var viewAllSelectArtistDetails = UIView(frame: CGRect.zero)
    var viewLibrarySongs = UIView(frame: CGRect.zero)
    
    
    var libraryPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var libraryAllPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var libraryKiKiPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var libraryKiKiAllPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var allPlaylist: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var allPlaylistSeeAll: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var allSong: [Song] = [Song]()
    var allSongSeeAll: [Song] = [Song]()
    var allArtist: [Artist] = [Artist]()
    var allArtistSeeAll: [Artist] = [Artist]()
    var allArtistSongs: [Song] = [Song]()
    var allArtistSongsSeeAll: [Song] = [Song]()
    var playlistDetailsSongs: [Song] = [Song]()
    var tempPlaylistSongs: [Song] = [Song]()
    var returnPlaylistData: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    
    var playerView = PlayerView() {
        didSet{
            scrollCollectionLibrarySongs?.playerView = self.playerView
            scrollCollectionExapndedLibrarySongs?.playerView = self.playerView
            
            scrollCollectionMinimizedSongsByArtist?.playerView = self.playerView
            scrollCollectionExapndedSongsByArtist?.playerView = self.playerView
        }
    }
    
    var scrollCollectionLibrarySongs:ScrollCollectionBrowse?
    var scrollCollectionExapndedLibrarySongs:ScrollCollectionBrowse?
    
    var scrollCollectionMinimizedSongsByArtist:ScrollCollection?
    var scrollCollectionExapndedSongsByArtist:ScrollCollection?
    
    var libraryArtistsList:[Artist] = [Artist]()
    var libraryArtistsListAll:[Artist] = [Artist]()
    var UserPlaylistSongs: [Song] = [Song]()
    
    var scrollView = UIScrollView(frame: CGRect.zero)
    var contentView = UIView(frame: CGRect.zero)
    var tempView = UIView(frame: CGRect.zero)
    
    var createPlaylistView = UIView(frame: CGRect.zero)
    var createSelectSongsView = UIView(frame: CGRect.zero)
    
    let playlistModel = PlaylistModel()
    
    var selectedTileArtists:SongTileLibraryArtists?
    var tilesArtists:[SongTileLibraryArtists] = [SongTileLibraryArtists]()
    
    var selectedTilePlaylists:SongTileLibraryPlaylist?
    var tilesPlaylists:[SongTileLibraryPlaylist] = [SongTileLibraryPlaylist]()
    
    var currentPlayingListA:[Song] = [Song]()
    
    var newPlaylist = UITextField()
    var done = UIButton()
    var edit = UIButton()
    var image = UIImageView()
    var playlistImage = UIImage()
    
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
        mainInstance.exitStatus = false
        mainInstance.item.removeAll()
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: UIScreen.main.bounds.height-200))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ((UIScreen.main.bounds.width-40)*1/3)*2+260+UIScreen.main.bounds.width+30))
        scrollView.addSubview(contentView)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: ((UIScreen.main.bounds.width-40)*1/3)*2+260+UIScreen.main.bounds.width+30)
        
        self.backgroundColor = Constants.color_background
        createSongsHeaderView(view: scrollView)
        loadSongsViews(view: scrollView)
        loadSongList()
        createArtistsHeaderView(view: scrollView)
        loadArtistsList(view: scrollView)
        
        createPlaylistHeaderView(view: scrollView)
        loadPlaylistsList()
        createKiKiPlaylistHeaderView(view: scrollView)
        loadKiKiPlaylistsList()
        
        self.addSubview(scrollView)
        
        createLibrarySongsSeeAllView(view: self, title: "Songs")
        
        //viewLibrarySongs.removeFromSuperview()
    }
    
    func createSongsHeaderView(view: UIView) {
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "Songs"
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        //labelAlbum.backgroundColor = UIColor.green
        
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: topBar.frame.width-80, y: 10, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.font = UIFont(name: "Roboto", size: 13.0)
        labelSongsSeeAll.layer.cornerRadius = 10
        labelSongsSeeAll.textColor = UIColor.white
        labelSongsSeeAll.layer.masksToBounds = true
        labelSongsSeeAll.backgroundColor = Constants.color_brand
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonClickSeeAllLibrarySongs))
        labelSongsSeeAll.isUserInteractionEnabled = true
        labelSongsSeeAll.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAll)
        
        view.addSubview(topBar)
        
    }
    
    @objc func buttonClickSeeAllLibrarySongs(sender:UIButton) {
        
        /*if(sender.tag == 5){
         
         var abc = "argOne" //Do something for tag 5
         }
         print("hello")*/
        //createSongsSeeAllView(view: viewAllSongs)
        //self.addSubview(viewAllSongs)
        
        viewAllLibrarySongs.isHidden = false
        
    }
    
    //Songs Library View
    func loadSongsViews(view: UIView) {
        viewLibrarySongs.removeFromSuperview()
        viewLibrarySongs = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width , height: (UIScreen.main.bounds.width-40)*1/3+30))
        //viewGenreSongs.backgroundColor = UIColor.yellow
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewLibrarySongs.frame.width, height: viewLibrarySongs.frame.height))
        //songsViewContent.backgroundColor = UIColor.gray
        
        scrollCollectionLibrarySongs = ScrollCollectionBrowse(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionLibrarySongs?.styleType = 15
        scrollCollectionLibrarySongs?.playerView = self.playerView
        songsViewContent.addSubview(scrollCollectionLibrarySongs!)
        
        viewLibrarySongs.addSubview(songsViewContent)
        
        view.addSubview(viewLibrarySongs)
        
    }
    
    func createLibrarySongsSeeAllView(view: UIView, title: String) {
        
        viewAllLibrarySongs = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        viewAllLibrarySongs.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(backButtonClickLibraryViewAllLibrarySongs), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width-50, height: 20))
        label.text = String(title)
        label.textColor =  UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(label)
        
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-40))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        scrollCollectionExapndedLibrarySongs = ScrollCollectionBrowse(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionExapndedLibrarySongs?.styleType = 20
        songsViewContent.addSubview(scrollCollectionExapndedLibrarySongs!)
        
        viewGenreSongs.addSubview(songsViewContent)
        view.addSubview(viewGenreSongs)
        
        viewAllLibrarySongs.addSubview(topBar)
        viewAllLibrarySongs.addSubview(viewGenreSongs)
        
        //viewAllLibrarySongs.isHidden = false
        view.addSubview(viewAllLibrarySongs)
        viewAllLibrarySongs.isHidden = true
        
    }
    
    @objc func backButtonClickLibraryViewAllLibrarySongs(sender:UIButton) {
        viewAllLibrarySongs.isHidden = true
    }
    
    //Load Library Songs
    func loadSongList() {
        self.libraryDataModel.getLibrarySongs(getLibrarySongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.libraryDataModel.librarySongsList.chunked(into: 10)
                    self.scrollCollectionLibrarySongs?.browsePlayingList = self.libraryDataModel.librarySongsList.count > 10 ? minimizedArray[0] : self.libraryDataModel.librarySongsList
                    
                    self.scrollCollectionExapndedLibrarySongs?.browsePlayingList = self.libraryDataModel.librarySongsList
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    var viewAllSongs = UIView(frame: CGRect.zero)
    
    
    
    func createSongsSeeAllView(view: UIView) {
        
        viewAllSongs = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        viewAllSongs.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(viewAllSongsButtonClicked), for: .touchUpInside)
        
        topBar.addSubview(arrow)
        viewAllSongs.addSubview(topBar)
    }
    
    @objc func viewAllSongsButtonClicked(sender:UIButton) {
        viewAllSongs.isHidden = true
        viewAllBrowseArtistSongs.isHidden = true
    }
    
    func createArtistsHeaderView(view: UIView) {
        
        let topBar = UIView(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width-40)*1/3+70, width: UIScreen.main.bounds.width, height: 40))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "Artists"
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        //labelAlbum.backgroundColor = UIColor.green
        
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: topBar.frame.width-80, y: 10, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.font = UIFont(name: "Roboto", size: 13.0)
        labelSongsSeeAll.layer.cornerRadius = 10
        labelSongsSeeAll.textColor = UIColor.white
        labelSongsSeeAll.layer.masksToBounds = true
        labelSongsSeeAll.backgroundColor = Constants.color_brand
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonClickSeeAllLibraryArtists))
        labelSongsSeeAll.isUserInteractionEnabled = true
        labelSongsSeeAll.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAll)
        
        view.addSubview(topBar)
        
    }
    
    @objc func buttonClickSeeAllLibraryArtists(sender:UIButton) {
        
        /*if(sender.tag == 5){
         
         var abc = "argOne" //Do something for tag 5
         }
         print("hello")*/
        //createSongsSeeAllView(view: viewAllSongs)
        //self.addSubview(viewAllSongs)
        self.loadArtistsViewsAll(view: self, title: "Artists")
        
    }
    
    //Library Artists View
    func loadArtistsViews(view: UIView) {
        
        let viewArtist = UIScrollView(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width-40)*1/3+110, width: UIScreen.main.bounds.width , height: (UIScreen.main.bounds.width-40)*1/3+10))
        //viewGenreSongs.backgroundColor = UIColor.yellow
        viewArtist.showsHorizontalScrollIndicator = false
        viewArtist.showsVerticalScrollIndicator = false
        
        let artistContent = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(libraryArtistsList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: viewArtist.frame.height))
        //artistContent.backgroundColor = UIColor.gray
        
        viewArtist.addSubview(artistContent)
        
        viewArtist.contentSize = CGSize(width: CGFloat(libraryArtistsList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: viewArtist.frame.height)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in libraryArtistsList.enumerated(){
            
            let songTile = SongTileLibraryArtists(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            print("SongTileLibraryArtists ", decodedImage)
            songTile.index = index
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedArtist))
            tap.id = tileData.id
            tap.aname = tileData.name
            tap.url = decodedImage
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            xLength += ((UIScreen.main.bounds.width-40)*1/3)
            artistContent.addSubview(songTile)
        }
        
        view.addSubview(viewArtist)
        
    }
    
    func loadArtistsViewsAll(view: UIView, title: String) {
        
        viewAllLibraryArtists = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        viewAllLibraryArtists.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(backButtonClickLibraryViewAllLibraryArtists), for: .touchUpInside)
        
        let text = UILabel(frame: CGRect(x: 40, y: 10, width: 100, height: 20))
        text.text = "Artist"
        text.textColor = UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(text)
        viewAllLibraryArtists.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: self.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:  CGFloat(libraryArtistsListAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(libraryArtistsListAll.count)*20)+340))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height: CGFloat(libraryArtistsListAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(libraryArtistsListAll.count)*20)+340)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in libraryArtistsListAll.enumerated(){
            let songTile = SongTileHomeAllArtists(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            //songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedArtist))
            tap.id = tileData.id
            tap.aname = tileData.name
            tap.url = tileData.image!
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        viewAllLibraryArtists.addSubview(one)
        view.addSubview(viewAllLibraryArtists)
    }
    
    @objc func backButtonClickLibraryViewAllLibraryArtists(sender:UIButton) {
        viewAllLibraryArtists.removeFromSuperview()
    }
    
    @objc func buttonClickedArtist(recognizer: MyTapGesture) {
        //globalBool = false
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        self.loadPopularArtistSongsList(id: recognizer.id)
        //self.createArtistDetails(id: recognizer.id, name: recognizer.aname, url: recognizer.url, album: "11 albums", song: "Genre")
        self.createArtistDetails(id: recognizer.id, name: recognizer.aname, url: recognizer.url, album: "0 albums", song: "Genre")
    }
    
    func createArtistDetails(id: Int, name: String, url: String, album: String, song: String) {
        
        viewAllLibraryArtistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewAllLibraryArtistDetails.backgroundColor = Constants.color_background
        
        //vi.isUserInteractionEnabled = false
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(backButtonClickLibraryArtistDetails), for: .touchUpInside)
        
        topBar.addSubview(arrow)
        viewAllLibraryArtistDetails.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height, width: viewAllLibraryArtistDetails.frame.width , height: self.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:420+UIScreen.main.bounds.width/3+UIScreen.main.bounds.width/2+10+UIScreen.main.bounds.width*1/3))
        one.addSubview(two)
        
        one.contentSize = CGSize(width: one.frame.width, height:UIScreen.main.bounds.width/3+100)
        
        loadSongByArtistDetailsViews(view: one)
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/3+40))
        titleContainer.backgroundColor = Constants.color_background
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3))
        image.downloadImageBrowse(from: URL(string: url)!)
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
        
        let songs = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2+10, y: lblTitle.frame.height+image.frame.height, width: UIScreen.main.bounds.width/2-10, height: 20))
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
        //labelAlbum.backgroundColor = UIColor.green
        
        let labelAlbumByArtistSeeAll = UILabel()
        labelAlbumByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10, width: 70, height:20)
        labelAlbumByArtistSeeAll.text = "ViewAll".localizedString
        labelAlbumByArtistSeeAll.textAlignment = .center
        labelAlbumByArtistSeeAll.font = UIFont(name: "Roboto", size: 13.0)
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
        
        labelSong.text = "Songs"
        labelSong.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSong.textColor = UIColor.white
        //labelSong.backgroundColor = UIColor.green
        
        let labelSongByArtistSeeAll = UILabel()
        //labelSongByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10+UIScreen.main.bounds.width/2+50, width: 70, height:20)
        labelSongByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10, width: 70, height:20)
        labelSongByArtistSeeAll.text = "ViewAll".localizedString
        labelSongByArtistSeeAll.textAlignment = .center
        labelSongByArtistSeeAll.font = UIFont(name: "Roboto", size: 13.0)
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
        
        self.addSubview(viewAllLibraryArtistDetails)
    }
    
    @objc func buttonClickedSeeAllArtistBySongs(recognizer: PlaylistPlayGesture) {
        createBrowseArtistAllSongsView(view: viewAllBrowseArtistSongs, title: "Songs")
        loadAllPopularArtistSongsList(id: recognizer.id)
        //viewAllPopularArtistSongs.isHidden = false
        //
        
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
    
    func createBrowseArtistAllSongsView(view: UIView, title: String) {
        
        viewAllBrowseArtistSongs = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
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
        scrollCollectionExapndedSongsByArtist?.styleType = 14
        scrollCollectionExapndedSongsByArtist?.playerView = self.playerView
        songsViewContent.addSubview(scrollCollectionExapndedSongsByArtist!)
        
        
        viewAllBrowseArtistSongs.addSubview(viewGenreSongs)
        
        viewAllBrowseArtistSongs.addSubview(topBar)
        viewAllBrowseArtistSongs.addSubview(viewGenreSongs)
        //viewAllPopularArtistSongs.isHidden = true
        self.addSubview(viewAllBrowseArtistSongs)
        //
    }
    
    func loadPopularArtistSongsList(id: Int) {
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
    
    @objc func backButtonClickLibraryArtistDetails(sender:UIButton) {
        viewAllLibraryArtistDetails.removeFromSuperview()
    }
    
    func loadSongByArtistDetailsViews(view: UIView) {
        
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width/3+80, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width-40)*1/3+30))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        scrollCollectionMinimizedSongsByArtist = ScrollCollection(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionMinimizedSongsByArtist?.styleType = 1
        scrollCollectionMinimizedSongsByArtist?.playerView = self.playerView
        songsViewContent.addSubview(scrollCollectionMinimizedSongsByArtist!)
        
        viewGenreSongs.addSubview(songsViewContent)
        
        view.addSubview(viewGenreSongs)
        
    }
    
    
    
    func loadArtistsList(view: UIView) {
        self.libraryDataModel.getLibraryArtists(getLibraryArtistsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.libraryDataModel.libraryArtistsList.chunked(into: 10)
                    self.libraryArtistsList = self.libraryDataModel.libraryArtistsList.count > 10 ? minimizedArray[0] : self.libraryDataModel.libraryArtistsList
                    
                    self.libraryArtistsListAll = self.libraryDataModel.libraryArtistsList
                    
                    self.loadArtistsViews(view: view)
                    
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func createKiKiPlaylistHeaderView(view: UIView) {
        
        let topBar = UIView(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width-40)*1/3+(UIScreen.main.bounds.width-40)*1/3+120, width: UIScreen.main.bounds.width, height: 40))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "KiKi Playlists"
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        //labelAlbum.backgroundColor = UIColor.green
        
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: topBar.frame.width-80, y: 10, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.font = UIFont(name: "Roboto", size: 13.0)
        labelSongsSeeAll.layer.cornerRadius = 10
        labelSongsSeeAll.textColor = UIColor.white
        labelSongsSeeAll.layer.masksToBounds = true
        labelSongsSeeAll.backgroundColor = Constants.color_brand
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonClickSeeAllLibraryKiKiPlaylists))
        labelSongsSeeAll.isUserInteractionEnabled = true
        labelSongsSeeAll.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAll)
        
        view.addSubview(topBar)
        
    }
    
    func createPlaylistHeaderView(view: UIView) {
        
        let topBar = UIView(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width-40)*1/3+(UIScreen.main.bounds.width-40)*1/3+150+UIScreen.main.bounds.width/2, width: UIScreen.main.bounds.width, height: 40))
        topBar.backgroundColor = Constants.color_background
        
        let labelSongs = UILabel()
        labelSongs.frame = CGRect(x: 10, y: 0, width: topBar.frame.width, height:topBar.frame.height)
        labelSongs.text = "Your Playlists"
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        //labelAlbum.backgroundColor = UIColor.green
        
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: topBar.frame.width-80, y: 10, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.font = UIFont(name: "Roboto", size: 13.0)
        labelSongsSeeAll.layer.cornerRadius = 10
        labelSongsSeeAll.textColor = UIColor.white
        labelSongsSeeAll.layer.masksToBounds = true
        labelSongsSeeAll.backgroundColor = Constants.color_brand
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonClickSeeAllLibraryPlaylists))
        labelSongsSeeAll.isUserInteractionEnabled = true
        labelSongsSeeAll.addGestureRecognizer(tap)
        
        topBar.addSubview(labelSongs)
        topBar.addSubview(labelSongsSeeAll)
        
        view.addSubview(topBar)
        
    }
    
    @objc func buttonClickSeeAllLibraryPlaylists(sender:UIButton) {
        
        /*if(sender.tag == 5){
         
         var abc = "argOne" //Do something for tag 5
         }
         print("hello")*/
        //createSongsSeeAllView(view: viewAllSongs)
        //self.addSubview(viewAllSongs)
        //viewAllLibrarySongs.isHidden = false
        loadPlaylistsSeeAllViews(view: self, title: "Playlists")
    }
    
    @objc func buttonClickSeeAllLibraryKiKiPlaylists(sender:UIButton) {
        loadKiKiPlaylistsSeeAllViews(view: self, title: "Playlists")
    }
    
    //KiKi Playlists View
    func loadKiKiPlaylistsViews(view: UIView) {
        
        let viewPlaylist = UIScrollView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3)*2+160, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width/2))
        viewPlaylist.showsHorizontalScrollIndicator = false
        viewPlaylist.showsVerticalScrollIndicator = false
        
        let playlistContent = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(self.libraryKiKiPlaylists.count)*(UIScreen.main.bounds.width/2-30)+(CGFloat(self.libraryKiKiPlaylists.count)*10)+10, height: UIScreen.main.bounds.width/2))
        viewPlaylist.addSubview(playlistContent)
        
        viewPlaylist.contentSize = CGSize(width: CGFloat(libraryKiKiPlaylists.count)*(UIScreen.main.bounds.width/2-30)+(CGFloat(libraryKiKiPlaylists.count)*10)+10, height: viewPlaylist.frame.height)
        
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
        view.addSubview(viewPlaylist)
    }
    
    //Playlists View
    func loadPlaylistsViews(view: UIView) {
        
        let viewPlaylist = UIScrollView(frame: CGRect(x: 0, y: ((UIScreen.main.bounds.width-40)*1/3)*2+190+UIScreen.main.bounds.width/2, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width/2))
        viewPlaylist.showsHorizontalScrollIndicator = false
        viewPlaylist.showsVerticalScrollIndicator = false
        
        let playlistContent = UIView(frame: CGRect(x: 0, y: 0, width: (CGFloat(self.libraryPlaylists.count)+1)*(UIScreen.main.bounds.width/2-30)+(CGFloat(self.libraryPlaylists.count)*10)+20, height: UIScreen.main.bounds.width/2))
        viewPlaylist.addSubview(playlistContent)
        
        let b_image = UIImage(named: "plus-green") as UIImage?
        let plusButton = UIButton()
        plusButton.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width/2-30, height:UIScreen.main.bounds.width/2-30)
        plusButton.setImage(b_image, for: .normal)
        plusButton.contentVerticalAlignment = .fill
        plusButton.contentHorizontalAlignment = .fill
        plusButton.imageEdgeInsets = UIEdgeInsets(top: (UIScreen.main.bounds.width/2)/3, left: (UIScreen.main.bounds.width/2)/3, bottom: (UIScreen.main.bounds.width/2)/3, right: (UIScreen.main.bounds.width/2)/3)
        plusButton.layer.cornerRadius = 5
        plusButton.backgroundColor = .darkGray
        plusButton.addTarget(self, action: #selector(buttonClicked_PlaylistPlus), for: .touchUpInside)
        
        playlistContent.addSubview(plusButton)
        
        viewPlaylist.contentSize = CGSize(width: (CGFloat(libraryPlaylists.count)+1)*(UIScreen.main.bounds.width/2-30)+(CGFloat(libraryPlaylists.count)*10)+20, height: viewPlaylist.frame.height)
        
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
        view.addSubview(viewPlaylist)
    }
    
    //Playlists See All View
    func loadPlaylistsSeeAllViews(view: UIView, title: String) {
        
        viewAllLibraryPlaylists = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        viewAllLibraryPlaylists.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(backButtonClickLibraryViewAllPlaylists), for: .touchUpInside)
        
        let text = UILabel(frame: CGRect(x: 40, y: 10, width: 100, height: 20))
        text.text = title
        text.textColor = UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(text)
        viewAllLibraryPlaylists.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: self.frame.height))
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
        plusButton.addTarget(self, action: #selector(buttonClicked_PlaylistPlus), for: .touchUpInside)
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
            //songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            songTile.index = index
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            
            let dateArr = tileData.date!.components(separatedBy: "-")
            songTile.year.text = dateArr[0]
            
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickLibraryPlaylist))
            tap.id = String(tileData.id)
            tap.image = decodedImage
            tap.title = tileData.name
            tap.songs = String(tileData.number_of_songs)
            tap.year =  dateArr[0]
            songTile.image.isUserInteractionEnabled = true
            songTile.image.addGestureRecognizer(tap)
            
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        viewAllLibraryPlaylists.addSubview(one)
        view.addSubview(viewAllLibraryPlaylists)
    }
    
    //KiKI Playlists See All View
    func loadKiKiPlaylistsSeeAllViews(view: UIView, title: String) {
        
        viewAllLibraryPlaylists = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        viewAllLibraryPlaylists.backgroundColor = Constants.color_background
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(backButtonClickLibraryViewAllPlaylists), for: .touchUpInside)
        
        let text = UILabel(frame: CGRect(x: 40, y: 10, width: 100, height: 20))
        text.text = title
        text.textColor = UIColor.white
        
        topBar.addSubview(arrow)
        topBar.addSubview(text)
        viewAllLibraryPlaylists.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: self.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:  CGFloat(libraryKiKiAllPlaylists.count)*(UIScreen.main.bounds.width/6)+(CGFloat(libraryKiKiAllPlaylists.count)*20)+360))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height: CGFloat(libraryKiKiAllPlaylists.count)*(UIScreen.main.bounds.width/6)+(CGFloat(libraryKiKiAllPlaylists.count)*20)+360)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in libraryKiKiAllPlaylists.enumerated(){
            let songTile = SongTileLibraryAllPlaylist(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            //songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            songTile.index = index
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            let dateArr = tileData.date!.components(separatedBy: "-")
            songTile.year.text = dateArr[0]
            
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickLibraryKiKiPlaylist))
            tap.id = String(tileData.id)
            tap.title = tileData.name
            tap.songs = String(tileData.number_of_songs)
            tap.year =  dateArr[0]
            tap.image = decodedImage
            songTile.image.isUserInteractionEnabled = true
            songTile.image.addGestureRecognizer(tap)
            
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        viewAllLibraryPlaylists.addSubview(one)
        view.addSubview(viewAllLibraryPlaylists)
    }
    
    @objc func buttonClickLibraryPlaylist(recognizer: PlaylistTapGesture) {
        
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        loadAllUserPlaylistSongsList(id: Int(recognizer.id)!, url: recognizer.image, title: recognizer.title, songs_count: recognizer.songs, date: recognizer.year)
        
    }
    
    @objc func buttonClickLibraryKiKiPlaylist(recognizer: PlaylistTapGesture) {
        
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        loadKiKiPlaylistSongsList(id: Int(recognizer.id)!, url: recognizer.image, title: recognizer.title, songs_count: recognizer.songs, date: recognizer.year)
        
    }
    
    func loadKiKiPlaylistSongsList(id: Int, url: String, title: String, songs_count: String, date: String) {
        
        self.homeDataModel.getLatestPlaylistSongs(id: String(id), getHomeLatestPlaylistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    //self.scrollCollectionExapndedLatestPlaylistSongs?.currentPlayingList = self.homeDataModel.latestPlaylistSongsList
                    self.UserPlaylistSongs = self.homeDataModel.latestPlaylistSongsList
                    
                    self.createKiKiPlaylistDetails(id: String(id), url: url, title: title, songs_count: songs_count, date: date)
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func loadAllUserPlaylistSongsList(id: Int, url: String, title: String, songs_count: String, date: String) {
        
        self.libraryDataModel.getSongsOfPlaylist(listID: id, getSongsOfPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    //self.scrollCollectionExapndedLatestPlaylistSongs?.currentPlayingList = self.homeDataModel.latestPlaylistSongsList
                    self.UserPlaylistSongs = self.libraryDataModel.playlistSongs
                    
                    self.createPlaylistDetails(id: String(id), url: url, title: title, songs_count: songs_count, date: date)
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func createPlaylistDetails(id: String, url: String, title: String, songs_count: String, date: String) {
        print("Printer id ", id," url ", url," title ", title)
        viewUserPlaylistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewUserPlaylistDetails.backgroundColor = Constants.color_background
        //vi.isUserInteractionEnabled = false
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(backButtonClickLibraryViewAllUserPlaylistsDetails), for: .touchUpInside)
        topBar.addSubview(arrow)
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4+90))
        titleContainer.backgroundColor = Constants.color_background
        titleContainer.isUserInteractionEnabled = true
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height+titleContainer.frame.height, width: self.frame.width, height: self.frame.height))
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
            image.downloadImageBrowse(from: URL(string: url)!)
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
        songs.text = songs_count
        songs.textColor = UIColor.gray
        songs.textAlignment = .right
        songs.font = UIFont(name: "Roboto", size: 11.0)
        
        let year = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2+10, y: lblTitle.frame.height+image.frame.height, width: UIScreen.main.bounds.width/2-10, height: 20))
        year.text = date
        year.textColor = UIColor.gray
        year.font = UIFont(name: "Roboto", size: 11.0)
        
        let labelPlaySong = UILabel()
        labelPlaySong.frame = CGRect(x: 0, y: lblTitle.frame.height+image.frame.height+songs.frame.height+10, width: 70, height:20)
        labelPlaySong.text = "‎▶ Play"
        labelPlaySong.center.x = titleContainer.center.x
        labelPlaySong.textAlignment = .center
        labelPlaySong.font = UIFont(name: "Roboto", size: 13.0)
        labelPlaySong.layer.cornerRadius = 10
        labelPlaySong.textColor = UIColor.white
        labelPlaySong.layer.masksToBounds = true
        labelPlaySong.backgroundColor = Constants.color_brand
        let tap = PlaylistPlayGesture(target: self, action: #selector(buttonClickedLibraryPlaylistPlay))
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
        //let tap2 = HomeTapGesture(target: self, action: #selector(buttonClickedSeeAllArtist))
        //tap2.lname = "Popular Artists"
        //labelAddSong.isUserInteractionEnabled = true
        //labelAddSong.addGestureRecognizer(tap2)
        
        titleContainer.addSubview(image)
        titleContainer.addSubview(lblTitle)
        titleContainer.addSubview(songs)
        titleContainer.addSubview(year)
        titleContainer.addSubview(labelPlaySong)
        //titleContainer.addSubview(labelAddSong)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in UserPlaylistSongs.enumerated(){
            let songTile = SongTileLibraryListSquareSongs(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        
        viewUserPlaylistDetails.addSubview(topBar)
        viewUserPlaylistDetails.addSubview(titleContainer)
        viewUserPlaylistDetails.addSubview(one)
        
        self.addSubview(viewUserPlaylistDetails)
    }
    
    func createKiKiPlaylistDetails(id: String, url: String, title: String, songs_count: String, date: String) {
        print("Printer id ", id," url ", url," title ", title)
        viewUserPlaylistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewUserPlaylistDetails.backgroundColor = Constants.color_background
        //vi.isUserInteractionEnabled = false
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(backButtonClickLibraryViewAllUserPlaylistsDetails), for: .touchUpInside)
        topBar.addSubview(arrow)
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4+90))
        titleContainer.backgroundColor = Constants.color_background
        titleContainer.isUserInteractionEnabled = true
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height+titleContainer.frame.height, width: self.frame.width, height: self.frame.height))
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
            image.downloadImageBrowse(from: URL(string: url)!)
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
        songs.text = songs_count
        songs.textColor = UIColor.gray
        songs.textAlignment = .right
        songs.font = UIFont(name: "Roboto", size: 11.0)
        
        let year = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2+10, y: lblTitle.frame.height+image.frame.height, width: UIScreen.main.bounds.width/2-10, height: 20))
        year.text = date
        year.textColor = UIColor.gray
        year.font = UIFont(name: "Roboto", size: 11.0)
        
        let labelPlaySong = UILabel()
        labelPlaySong.frame = CGRect(x: 0, y: lblTitle.frame.height+image.frame.height+songs.frame.height+10, width: 70, height:20)
        labelPlaySong.text = "‎▶ Play"
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
        //let tap2 = HomeTapGesture(target: self, action: #selector(buttonClickedSeeAllArtist))
        //tap2.lname = "Popular Artists"
        //labelAddSong.isUserInteractionEnabled = true
        //labelAddSong.addGestureRecognizer(tap2)
        
        titleContainer.addSubview(image)
        titleContainer.addSubview(lblTitle)
        titleContainer.addSubview(songs)
        titleContainer.addSubview(year)
        titleContainer.addSubview(labelPlaySong)
        //titleContainer.addSubview(labelAddSong)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in UserPlaylistSongs.enumerated(){
            let songTile = SongTileLibraryListSquareSongs(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        
        viewUserPlaylistDetails.addSubview(topBar)
        viewUserPlaylistDetails.addSubview(titleContainer)
        viewUserPlaylistDetails.addSubview(one)
        
        self.addSubview(viewUserPlaylistDetails)
    }
    
    @objc func backButtonClickLibraryViewAllUserPlaylistsDetails(sender:UIButton) {
        viewUserPlaylistDetails.removeFromSuperview()
    }
    
    @objc func buttonClickedLibraryPlaylistPlay(recognizer: PlaylistPlayGesture) {
        print("playlistid ", recognizer.id)
        loadSongsOfGlobalPlaylistGlobal(listID: recognizer.id)
    }
    
    @objc func buttonClickedLibraryKiKiPlaylistPlay(recognizer: PlaylistPlayGesture) {
        print("playlistid ", recognizer.id)
        loadSongsOfGlobalPlaylistKiKiGlobal(listID: recognizer.id)
    }
    
    func loadSongsOfGlobalPlaylistGlobal(listID:Int) {
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            self.playlistModel.getSongsOfPlaylist(listID: listID, getSongsOfPlaylistCallFinished:{ (status, error, songs) in
                if (status) {
                    if (songs == nil || (songs?.isEmpty)!) {
                        let alert = UIAlertController(title: "Kiki", message: "No Songs Availabale", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK_BUTTON_TITLE".localizedString, style: UIAlertAction.Style.default, handler: nil))
                        self.parentVC!.present(alert, animated: true, completion: nil)
                    } else {
                        self.parentVC.playerView.pause()
                        self.parentVC.playerView.currentPlayingList = songs!
                        self.parentVC.playerView.currentPlayingTime = 0
                        self.parentVC.playerView.play()
                    }
                } else {
                    let alert = UIAlertController(title: "Kiki", message: "Unexpected error occured", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK_BUTTON_TITLE".localizedString, style: UIAlertAction.Style.default, handler: nil))
                    self.parentVC!.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func loadSongsOfGlobalPlaylistKiKiGlobal(listID:Int) {
        
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            self.playlistModel.getSongsOfPlaylistGlobal(listID: listID, getSongsOfPlaylistCallFinished:{ (status, error, songs) in
                if (status) {
                    if (songs == nil || (songs?.isEmpty)!) {
                        let alert = UIAlertController(title: "Kiki", message: "No Songs Availabale", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK_BUTTON_TITLE".localizedString, style: UIAlertAction.Style.default, handler: nil))
                        self.parentVC!.present(alert, animated: true, completion: nil)
                    } else {
                        self.parentVC.playerView.pause()
                        self.parentVC.playerView.currentPlayingList = songs!
                        self.parentVC.playerView.currentPlayingTime = 0
                        self.parentVC.playerView.play()
                    }
                } else {
                    let alert = UIAlertController(title: "Kiki", message: "Unexpected error occured", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK_BUTTON_TITLE".localizedString, style: UIAlertAction.Style.default, handler: nil))
                    self.parentVC!.present(alert, animated: true, completion: nil)
                }
            })
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
    
    @objc func backButtonClickLibraryViewAllPlaylists(sender:UIButton) {
        viewAllLibraryPlaylists.removeFromSuperview()
    }
    
    @objc func buttonClicked_PlaylistPlus(sender:UIButton) {
        mainInstance.playlistName = ""
        mainInstance.playlistImage = ""
        createNewPlaylistView(view: self, status: mainInstance.playlistSessionToken)
        mainInstance.playlistSessionToken = UIDevice.current.identifierForVendor!.uuidString+String(Date().currentTimeMillis())
        print(" mainInstance.playlistSessionToken =", UIDevice.current.identifierForVendor!.uuidString+String(Date().currentTimeMillis()))
        
    }
    
    func getTempPlaylist(session_id: String) {
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        self.libraryDataModel.getTempPlaylist(session_id: session_id, getTempPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.tempPlaylistSongs = self.libraryDataModel.tempPlaylistSongs
                    
                    self.createNewPlaylistView(view: self, status: session_id)
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    func getTempPlaylist2(session_id: String) {
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        self.libraryDataModel.getTempPlaylist(session_id: session_id, getTempPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.tempPlaylistSongs = self.libraryDataModel.tempPlaylistSongs
                    
                    // self.createNewPlaylistView(view: self, status: session_id)
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    //New Playlist
    func createNewPlaylistView(view: UIView, status: String) {
        
        createPlaylistView.removeFromSuperview()
        createPlaylistView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
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
            newPlaylist.text = "New Playlist"
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
        
        edit = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2+60, y: 50+UIScreen.main.bounds.width/4, width: 40, height: 30))
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
        
        let libraryAddSongsScrollView = UIScrollView(frame: CGRect(x: 0, y: 90+UIScreen.main.bounds.width/4, width: UIScreen.main.bounds.width , height: self.frame.height))
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
    
    //camera
    var dvc = DashboardViewController()
    @objc func buttonClickAddImage(recognizer: PlaylistTapGesture) {
        let imagePicker = UIImagePickerController()
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
    }
    
    var imgGlobal=""
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //print("worked")
        guard let images = info[.originalImage] as? UIImage else { return }
        imgGlobal = convertImageToBase64String(img: images)
        mainInstance.playlistImage = imgGlobal
        image.image = images
        playlistImage = images
        image.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4)
        image.center.x = createPlaylistView.center.x
        picker.dismiss(animated: true, completion: nil)
        //print("worked ", imgGlobal)
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    //Decoding base64
    /*func convertBase64StringToImage (imageBase64String:String) -> UIImage {
     let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
     let image = UIImage(data: imageData!)
     return image!
     }*/
    
    
    @objc func buttonClickRemoveSongFromPlaylist(recognizer: PlaylistTapGesture) {
        addToTempPlaylistSongs(session_id: mainInstance.playlistSessionToken, ref_id: Int(recognizer.id)!, type: "S")
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
    
    func addToTempPlaylistSongs2(session_id: String, ref_id: Int, type: String) {
        self.libraryDataModel.addToTempPlaylistSongs(session_id: session_id, ref_id: ref_id, type: type, addToTempPlaylistSongsCallFinished: { (status_r, error, userInfo) in
            if status_r {
                DispatchQueue.main.async(execute: {
                    
                    self.getTempPlaylist2(session_id: session_id)
                })
            }
        })
    }
    
    @objc func buttonClick_AddSongs(sender:UIButton) {
        mainInstance.playlistName=newPlaylist.text!
        if CGFloat(tempPlaylistSongs.count)>0 {
            createPlaylistView.removeFromSuperview()
        } else {
            createSelectSongsView(view: self)
        }
        
    }
    
    func createSelectSongsView(view: UIView) {
        createSelectSongsView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
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
        
        let selectSongsScrollView = UIScrollView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width , height: self.frame.height))
        selectSongsScrollView.showsHorizontalScrollIndicator = false
        selectSongsScrollView.showsVerticalScrollIndicator = false
        //selectSongsScrollView.backgroundColor = .blue
        
        selectSongsScrollView.contentSize = CGSize(width: selectSongsScrollView.frame.width, height:(UIScreen.main.bounds.width/2)*3+120+((UIScreen.main.bounds.width-40)*1/3-10)+80+(UIScreen.main.bounds.width-40)*1/3)
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56))
        searchBar.placeholder = "Search by Songs, Playlist and Artists"
        searchBar.backgroundColor = .white
        searchBar.tintColor = .gray
        searchBar.barTintColor = Constants.color_transparent
        
        selectSongsScrollView.addSubview(searchBar)
        
        let labelPlayList = UILabel()
        labelPlayList.frame = CGRect(x: 10, y: 60, width: self.frame.width, height:40)
        labelPlayList.text = "Add Songs from Playlists"
        labelPlayList.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelPlayList.textColor = UIColor.white
        selectSongsScrollView.addSubview(labelPlayList)
        
        let labelPlayListSeeAll = UILabel()
        labelPlayListSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: 70, width: 70, height:20)
        labelPlayListSeeAll.text = "ViewAll".localizedString
        labelPlayListSeeAll.textAlignment = .center
        labelPlayListSeeAll.font = UIFont(name: "Roboto", size: 13.0)
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
        labelSongs.frame = CGRect(x: 10, y: UIScreen.main.bounds.width/2+100, width: self.frame.width, height:40)
        labelSongs.text = "Add Songs"
        labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSongs.textColor = UIColor.white
        selectSongsScrollView.addSubview(labelSongs)
        
        let labelSongsSeeAll = UILabel()
        labelSongsSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: UIScreen.main.bounds.width/2+110, width: 70, height:20)
        labelSongsSeeAll.text = "ViewAll".localizedString
        labelSongsSeeAll.textAlignment = .center
        labelSongsSeeAll.font = UIFont(name: "Roboto", size: 13.0)
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
        labelArtists.frame = CGRect(x: 10, y: UIScreen.main.bounds.width/2+140+((UIScreen.main.bounds.width-40)*1/3-10)+40, width: self.frame.width, height:40)
        labelArtists.text = "Add Songs from Artists"
        labelArtists.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelArtists.textColor = UIColor.white
        selectSongsScrollView.addSubview(labelArtists)
        
        let labelByArtistsSeeAll = UILabel()
        labelByArtistsSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: UIScreen.main.bounds.width/2+150+((UIScreen.main.bounds.width-40)*1/3-10)+40, width: 70, height:20)
        labelByArtistsSeeAll.text = "ViewAll".localizedString
        labelByArtistsSeeAll.textAlignment = .center
        labelByArtistsSeeAll.font = UIFont(name: "Roboto", size: 13.0)
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
    
    @objc func buttonClickedAddSongsFromPlayLists(recognizer: HomeTapGesture) {
        loadSelectPlaylistsSeeAllViews(view: self, title: recognizer.lname)
    }
    
    @objc func buttonClickedAddSongsFromSongs(recognizer: HomeTapGesture) {
        loadSelectSongsSeeAllViews(view: self, title: recognizer.lname)
    }
    
    @objc func buttonClickedAddSongsFromArtists(recognizer: HomeTapGesture) {
        loadSelectArtistsSeeAllViews(view: self, title: recognizer.lname)
    }
    
    @objc func buttonClick_HideSelectSongsView(sender:UIButton) {
        createSelectSongsView.removeFromSuperview()
    }
    
    @objc func buttonClick_ConfirmPlaylist(sender:UIButton) {
        getTempPlaylist(session_id: mainInstance.playlistSessionToken)
        
    }
    
    @objc func buttonClick_EditPlaylistName(sender:UIButton) {
        newPlaylist.becomeFirstResponder()
        newPlaylist.isEnabled = true
        newPlaylist.isUserInteractionEnabled = true
        //edit.isHidden = true
        //done.isHidden = false
    }
    
    @objc func buttonClick_DonePlaylistName(sender:UIButton) {
        mainInstance.playlistName=newPlaylist.text!
        newPlaylist.isEnabled = false
        newPlaylist.isUserInteractionEnabled = false
        edit.isHidden = false
        done.isHidden = true
    }
    
    @objc func buttonClick_ConfirmCreatedPlaylistView(sender:UIButton) {
        mainInstance.playlistImage=""
        mainInstance.playlistName=newPlaylist.text!
        if mainInstance.playlistName == "" || mainInstance.playlistName == "New Playlist" {
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
    
    func createPlaylist(playlistName: String, imageUrl: String) {
        
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        
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
                        
                        self.createPlaylist(playlistId: playlistId, songs: songsid)
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
    
    func createPlaylist(playlistId: String, songs: [String]) {
        self.libraryDataModel.addToPlaylist(playlistId: playlistId, songs: songs, addToPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.tempPlaylistSongs.removeAll()
                    mainInstance.playlistName=""
                    mainInstance.playlistSessionToken=""
                    self.viewSelectPlaylistDetails.removeFromSuperview()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    @objc func buttonClick_HideCreatedPlaylistView(sender:UIButton) {
        mainInstance.playlistImage=""
        mainInstance.playlistSessionToken=""
        tempPlaylistSongs.removeAll()
        print("mainInstance.playlistSessionToken=_")
        createPlaylistView.removeFromSuperview()
        viewSelectPlaylistDetails.removeFromSuperview()
        createSelectSongsView.removeFromSuperview()
    }
    
    func loadPlaylistsList() {
        self.libraryDataModel.getPlaylists(getPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async {
                    let minimizedArray = self.libraryDataModel.playlists.chunked(into: 10)
                    self.libraryPlaylists = self.libraryDataModel.playlists.count > 10 ? minimizedArray[0] : self.libraryDataModel.playlists
                    self.libraryAllPlaylists = self.libraryDataModel.playlists
                    
                    self.loadPlaylistsViews(view: self.scrollView)
                }
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    func loadKiKiPlaylistsList() {
        self.libraryDataModel.getKiKiPlaylists(getPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async {
                    let minimizedArray = self.libraryDataModel.kikiPlaylists.chunked(into: 10)
                    self.libraryKiKiPlaylists = self.libraryDataModel.kikiPlaylists.count > 10 ? minimizedArray[0] : self.libraryDataModel.kikiPlaylists
                    self.libraryKiKiAllPlaylists = self.libraryDataModel.kikiPlaylists
                    
                    self.loadKiKiPlaylistsViews(view: self.scrollView)
                }
            } else {
                DispatchQueue.main.async(execute: {})
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
                    
                    //self.loadPlaylistsViews(view: view)
                    self.loadAllPlaylistViews(view: view)
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
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
    
    func fetchRemainingSongs() {
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        self.libraryDataModel.getAllSongs(offset: self.allSongSeeAll.count, getAllSongsListCallFinished: { (status, error, userInfo) in
            if status{
                self.allSongSeeAll = self.libraryDataModel.allSongs
                // self.currentShowingSongs = self.allSongsModel.allSongsList
                self.contOffset = Int(CGFloat(self.allSongSeeAll.count)*(UIScreen.main.bounds.width/6))
                DispatchQueue.main.async{
                    ProgressView.shared.hide()
                    self.loadSelectSongsSeeAllViews(view: self, title: "Add Songs")
                }
            }else{
                DispatchQueue.main.async{
                    ProgressView.shared.hide()
                }
            }
        })
    }
    
    //All Songs View
    func loadAllSongViews(view: UIView) {
        
        let viewAllSongs = UIScrollView(frame: CGRect(x: 0, y: 140+UIScreen.main.bounds.width/2, width: UIScreen.main.bounds.width , height: ((UIScreen.main.bounds.width-40)*1/3-10)+40))
        viewAllSongs.showsHorizontalScrollIndicator = false
        viewAllSongs.showsVerticalScrollIndicator = false
        
        let allSongContent = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(allSong.count) * (self.frame.height-20), height: viewAllSongs.frame.height))
        
        viewAllSongs.addSubview(allSongContent)
        
        viewAllSongs.contentSize = CGSize(width: CGFloat(allSong.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: viewAllSongs.frame.height)
        
        var xLength: CGFloat = 10
        
        for (_, tileData) in allSong.enumerated(){
            let songTile = SongTileSelectSong(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
            songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            xLength += ((UIScreen.main.bounds.width-40)*1/3)
            songTile.id = tileData.id
            allSongContent.addSubview(songTile)
            songTile.unselectText.text = ""
        }
        view.addSubview(viewAllSongs)
    }
    
    func loadAllArtists(view: UIView) {
        self.libraryDataModel.getAllArtists(getAllArtistsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    let minimizedArray = self.libraryDataModel.allArtists.chunked(into: 10)
                    self.allArtist = self.libraryDataModel.allArtists.count > 10 ? minimizedArray[0] : self.libraryDataModel.allArtists
                    self.allArtistSeeAll = self.libraryDataModel.allArtists
                    
                    //self.loadPlaylistsViews(view: view)
                    self.loadAllArtistViews(view: view)
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
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
            print("SongTileHomeArtistsName ", tileData.name)
            print("SongTileHomeArtists ", tileData.image!)
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            xLength += ((UIScreen.main.bounds.width-40)*1/3)
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedSelectArtist))
            tap.id = tileData.id
            tap.aname = tileData.name
            tap.url = decodedImage
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            allArtistContent.addSubview(songTile)
        }
        view.addSubview(viewAllArtist)
    }
    
    //func constructPlaylists() {}
    
    //Select Playlists See All View
    func loadSelectPlaylistsSeeAllViews(view: UIView, title: String) {
        viewAllSelectPlaylists = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
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
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: self.frame.height))
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
            
            let dateArr = tileData.date!.components(separatedBy: "-")
            songTile.year.text = dateArr[0]
            
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickedCreateSelectPlaylistDetails))
            tap.id = String(tileData.id)
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
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
    
    @objc func buttonClick_HideSelectPlaylistsSeeAllView(sender:UIButton) {
        viewAllSelectPlaylists.removeFromSuperview()
    }
    
    //Select Songs See All View
    var on = UIScrollView(frame: CGRect.zero)
    var tw = UIView(frame: CGRect.zero)
    var contOffset = 0
    func loadSelectSongsSeeAllViews(view: UIView, title: String) {
        viewAllSelectSongs.removeFromSuperview()
        viewAllSelectSongs = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
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
        
        on = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: self.frame.height))
        on.showsHorizontalScrollIndicator = false
        on.showsVerticalScrollIndicator = false
        
        tw = UIView(frame: CGRect(x: 0, y: 0, width: on.frame.width, height:   CGFloat(allSongSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allSongSeeAll.count)*20)+290))
        on.addSubview(tw)
        on.contentSize = CGSize(width: on.frame.width, height: CGFloat(allSongSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allSongSeeAll.count)*20)+290)
        on.contentOffset = CGPoint(x: 0, y: contOffset)
        var xLength: CGFloat = 10
        
        for (_, tileData) in allSongSeeAll.enumerated() {
            let songTile = SongTileSelectSongSeeAll(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.id = tileData.id
            songTile.add.setTitle("Add".localizedString, for: .normal)
            songTile.add.layer.borderColor = Constants.color_brand.cgColor
            songTile.add.setTitleColor(Constants.color_brand, for: .normal)
            xLength += UIScreen.main.bounds.width/6+20
            tw.addSubview(songTile)
        }
        viewAllSelectSongs.addSubview(on)
        view.addSubview(viewAllSelectSongs)
        on.delegate = self
        
    }
    
    @objc func buttonClick_HideSelectSongsSeeAllView(sender:UIButton) {
        viewAllSelectSongs.removeFromSuperview()
    }
    
    //Select Artists See All View
    func loadSelectArtistsSeeAllViews(view: UIView, title: String) {
        
        viewAllSelectArtists = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
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
        
        let one = UIScrollView(frame: CGRect(x: 10, y: topBar.frame.height, width: UIScreen.main.bounds.width , height: self.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height: CGFloat(allArtistSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allArtistSeeAll.count)*20)+370))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height: CGFloat(allArtistSeeAll.count)*(UIScreen.main.bounds.width/6)+(CGFloat(allArtistSeeAll.count)*20)+370)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in allArtistSeeAll.enumerated(){
            let songTile = SongTileSeeAllArtist(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            print("SongTileSeeAllArtist ", tileData.image!)
            songTile.index = index
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedSelectArtist))
            tap.id = tileData.id
            tap.aname = tileData.name
            tap.url = decodedImage
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            xLength += UIScreen.main.bounds.width/6+20
            two.addSubview(songTile)
        }
        viewAllSelectArtists.addSubview(one)
        view.addSubview(viewAllSelectArtists)
    }
    
    @objc func buttonClick_HideSelectArtistSeeAllView(sender:UIButton) {
        viewAllSelectArtists.removeFromSuperview()
    }
    
    @objc func buttonClickedCreateSelectPlaylistDetails(recognizer: PlaylistTapGesture) {
        print("Printer ", recognizer.id," ", recognizer.title)
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
        loadAllSelectPlaylistSongsList(id: recognizer.id, url: recognizer.image, title: recognizer.title, songs_count: recognizer.songs, date: recognizer.year)
        
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
    
    func createSelectPlaylistDetails(id: String, url: String, title: String, songs_count: String, date: String, status: Bool) {
        
        viewSelectPlaylistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewSelectPlaylistDetails.backgroundColor = Constants.color_background
        //vi.isUserInteractionEnabled = false
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClick_HideSelectPlaylistDetailsView), for: .touchUpInside)
        topBar.addSubview(arrow)
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: topBar.frame.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4+90))
        titleContainer.backgroundColor = Constants.color_background
        titleContainer.isUserInteractionEnabled = true
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height+titleContainer.frame.height, width: self.frame.width, height: self.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height: CGFloat(playlistDetailsSongs.count)*(UIScreen.main.bounds.width/6)+(CGFloat(playlistDetailsSongs.count)*20)+370+UIScreen.main.bounds.width/3+40))
        one.addSubview(two)
        one.contentSize = CGSize(width: one.frame.width, height:CGFloat(playlistDetailsSongs.count)*(UIScreen.main.bounds.width/6)+(CGFloat(playlistDetailsSongs.count)*20)+370+UIScreen.main.bounds.width/3+40)
        
        one.isUserInteractionEnabled = true
        two.isUserInteractionEnabled = true
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4))
        image.downloadImageBrowse(from: URL(string: url)!)
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
        labelAddSong.text = "‎+ Add All"
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
            songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            if status {
                songTile.add.setTitle("AddedToPlayList".localizedString, for: .normal)
                songTile.add.backgroundColor = Constants.color_brand
                songTile.add.layer.borderColor = Constants.color_brand.cgColor
                songTile.add.setTitleColor(.white, for: .normal)
            }
            xLength += UIScreen.main.bounds.width/6+20
            songTile.id = tileData.id
            two.addSubview(songTile)
        }
        
        viewSelectPlaylistDetails.addSubview(topBar)
        viewSelectPlaylistDetails.addSubview(titleContainer)
        viewSelectPlaylistDetails.addSubview(one)
        
        self.addSubview(viewSelectPlaylistDetails)
        
        if playlistStatus {
            playlistStatus = false
        } else {
            playlistStatus = true
        }
    }
    
    @objc func buttonClick_HideSelectPlaylistDetailsView(sender:UIButton) {
        playlistStatus = false
        viewSelectPlaylistDetails.removeFromSuperview()
    }
    
    
    @objc func buttonClickedSelectAllPlaylistSongs(recognizer: PlaylistTapGesture) {
        print("playlistid ", recognizer.id)
        addToTempPlaylistSongs2(session_id: mainInstance.playlistSessionToken, ref_id: Int(recognizer.id)!, type: "P")
        //loadSongsOfGlobalPlaylistGlobal(listID: recognizer.id)
        viewSelectPlaylistDetails.removeFromSuperview()
        createSelectPlaylistDetails(id: recognizer.id, url: recognizer.image, title: recognizer.title, songs_count: recognizer.songs, date: recognizer.year, status: playlistStatus)
        
    }
    
    @objc func buttonClickedSelectArtist(recognizer: MyTapGesture) {
        //globalBool = false
        print("worked")
        self.loadSelectArtistSongsList(id: recognizer.id, name: recognizer.aname, url: recognizer.url, album: "11 albums", song: "Genre")
        //self.createArtistDetails(id: recognizer.id, name: recognizer.aname, url: recognizer.url, album: "11 albums", song: "Genre")
        
    }
    
    func loadSelectArtistSongsList(id: Int, name: String, url: String, album: String, song: String) {
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
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
    
    func createSelectArtistDetails(id: Int, name: String, url: String, album: String, song: String) {
        
        viewSelectArtistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewSelectArtistDetails.backgroundColor = Constants.color_background
        
        //vi.isUserInteractionEnabled = false
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        let arrow = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        arrow.setBackgroundImage(UIImage(named: "left_arrow"), for: UIControl.State.normal)
        arrow.addTarget(self, action: #selector(buttonClick_HideSelectArtistDetailsView), for: .touchUpInside)
        
        topBar.addSubview(arrow)
        viewSelectArtistDetails.addSubview(topBar)
        
        let one = UIScrollView(frame: CGRect(x: 0, y: topBar.frame.height, width: viewSelectArtistDetails.frame.width , height: self.frame.height))
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:420+UIScreen.main.bounds.width/3+UIScreen.main.bounds.width/2+10+UIScreen.main.bounds.width*1/3))
        one.addSubview(two)
        
        one.contentSize = CGSize(width: one.frame.width, height:UIScreen.main.bounds.width/3+100)
        
        loadSelectSongByArtistDetailsViews(view: one)
        
        let titleContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/3+40))
        titleContainer.backgroundColor = Constants.color_background
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3))
        image.downloadImageBrowse(from: URL(string: url)!)
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
        
        let songs = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2+10, y: lblTitle.frame.height+image.frame.height, width: UIScreen.main.bounds.width/2-10, height: 20))
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
        //labelAlbum.backgroundColor = UIColor.green
        
        let labelAlbumByArtistSeeAll = UILabel()
        labelAlbumByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10, width: 70, height:20)
        labelAlbumByArtistSeeAll.text = "ViewAll".localizedString
        labelAlbumByArtistSeeAll.textAlignment = .center
        labelAlbumByArtistSeeAll.font = UIFont(name: "Roboto", size: 13.0)
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
        
        labelSong.text = "Songs"
        labelSong.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSong.textColor = UIColor.white
        //labelSong.backgroundColor = UIColor.green
        
        let labelSongByArtistSeeAll = UILabel()
        //labelSongByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10+UIScreen.main.bounds.width/2+50, width: 70, height:20)
        labelSongByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10, width: 70, height:20)
        labelSongByArtistSeeAll.text = "ViewAll".localizedString
        labelSongByArtistSeeAll.textAlignment = .center
        labelSongByArtistSeeAll.font = UIFont(name: "Roboto", size: 13.0)
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
        
        self.addSubview(viewSelectArtistDetails)
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
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(allArtistSongs.count) * (self.frame.height - 20 ), height: scrollView.frame.height))
        scrollView.addSubview(contentView)
        
        scrollView.contentSize = CGSize(width: CGFloat(allArtistSongs.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: scrollView.frame.height)
        for (_, tileData) in allArtistSongs.enumerated() {
            let songTile = SongsTileSelectArtistDetails(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
            songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.id = tileData.id
            songTile.unselectText.text = ""
            xLength += ((UIScreen.main.bounds.width-40)*1/3)
            contentView.addSubview(songTile)
        }
        view.addSubview(viewGenreSongs)
    }
    
    @objc func buttonClick_HideSelectArtistDetailsView(sender:UIButton) {
        viewSelectArtistDetails.removeFromSuperview()
    }
    
    @objc func buttonClickedSelectSeeAllArtistBySongs(recognizer: PlaylistPlayGesture) {
        createSelectArtistAllSongsView(view: self, title: "Songs")
    }
    
    func createSelectArtistAllSongsView(view: UIView, title: String) {
        
        viewAllSelectArtistDetails = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
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
            songTile.lblDescription.text = tileData.description
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            xLength += UIScreen.main.bounds.width/6+20
            songTile.id = tileData.id
            contentView.addSubview(songTile)
        }
        
        viewAllSelectArtistDetails.addSubview(viewGenreSongs)
        viewAllSelectArtistDetails.addSubview(topBar)
        viewAllSelectArtistDetails.addSubview(viewGenreSongs)
        view.addSubview(viewAllSelectArtistDetails)
    }
    
    @objc func buttonClick_HideSelectArtistDetailsSeeAllView(sender:UIButton) {
        viewAllSelectArtistDetails.removeFromSuperview()
    }
    
    func createPlaylist(playlistName: String, createPlaylistCallFinished: @escaping (_ status: Bool, _ playlist: GlobalPlaylistItem?) -> Void){
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
    }
    
    func addToPlaylist(playlistId: Int, songId: Int, addToPlayListCallFinished: @escaping (_ status: Bool) -> Void){
        ProgressView.shared.show(self, mainText: nil, detailText: nil)
    }
    
    //func loadSongsOfGlobalPlaylist(listID:Int) {}
}

extension LibraryViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let shouldRequestForRemaingEpisodes = offsetY + 100 > contentHeight - scrollView.frame.size.height
        if (shouldRequestForRemaingEpisodes) {// && self.isOnAllSongsTab) {
            self.fetchRemainingSongs()
            //self.scrollHeight = scrollSongs.contentSize.height - scrollSongs.frame.size.height
        }
    }
    
    /*func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
     let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
     if (actualPosition.y > 0){
     // Dragging down
     print("Scroll down")
     }else{
     // Dragging up
     fetchRemainingSongs()
     print("Scroll up")
     }
     }*/
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}


/*extension LibraryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
 if let imag = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
 image.image = imag
 }
 
 imagePicker.dismiss(animated:true, completion:nil)
 }
 }
 */

