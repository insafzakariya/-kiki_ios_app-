//
//  ArtistDetailViewController.swift
//  SusilaMobile
//
//  Created by Kiroshan on 6/2/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class ArtistDetailViewController: UIViewController {
    var id: Int?
    var name: String?
    var url: String?
    var album: String?
    var song: String?
    var homeDataModel = HomeDataModel()
    
    var playerView: PlayerView? {
        didSet {
            scrollCollectionMinimizedSongsByArtist?.playerView = self.playerView
            scrollCollectionExapndedSongsByArtist?.playerView = self.playerView
        }
    }
    var scrollCollectionMinimizedSongsByArtist:ScrollCollection?
    var scrollCollectionExapndedSongsByArtist:ScrollCollection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createArtistDetails(id: id!, name: name!, url: url!, album: album!, song: song!)
        loadPopularArtistSongsList(id: id!)
        print(name as Any)
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
    
    @objc func buttonClickedSeeAllArtistBySongs(recognizer: PlaylistPlayGesture) {
        let controller = AllSongViewController()
        controller.id = recognizer.id
        controller.key = ""
        controller.type = ""
        controller.playerView = self.playerView
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func createArtistDetails(id: Int, name: String, url: String, album: String, song: String) {
        
        let viewBrowseArtist = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        viewBrowseArtist.backgroundColor = Constants.color_background
        
        //vi.isUserInteractionEnabled = false
        
        let one = UIScrollView(frame: CGRect(x: 0, y: 0, width: viewBrowseArtist.frame.width , height: view.frame.height))
        
        let two = UIView(frame: CGRect(x: 0, y: 0, width: one.frame.width, height:420+UIScreen.main.bounds.width/3+UIScreen.main.bounds.width/2+10+UIScreen.main.bounds.width*1/3))
        one.addSubview(two)
        //one.contentSize = CGSize(width: one.frame.width, height:two.frame.height)\
        
        
        one.contentSize = CGSize(width: one.frame.width, height:UIScreen.main.bounds.width/3+100)
        loadSongByArtistViews(view: one)
        let titleContainer = UIView(frame: CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/3+70))
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
        
        let songs = UILabel(frame: CGRect(x: 0, y: lblTitle.frame.height+image.frame.height, width: UIScreen.main.bounds.width, height: 20))
        songs.textAlignment = .center
        songs.text = song
        songs.textColor = UIColor.gray
        songs.font = UIFont(name: "Roboto", size: 11.0)
        
        let labelAddArtist = UILabel()
        labelAddArtist.frame = CGRect(x: 0, y: lblTitle.frame.height+image.frame.height+albums.frame.height+5, width: 70, height:20)
        labelAddArtist.center.x = titleContainer.center.x
        labelAddArtist.text = NSLocalizedString("Add".localized(using: "Localizable"), comment: "")
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
        labelAlbumByArtistSeeAll.text = NSLocalizedString("ViewAll".localized(using: "Localizable"), comment: "")
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
        
        labelSong.text = NSLocalizedString("Song".localized(using: "Localizable"), comment: "")
        labelSong.font = UIFont(name: "Roboto-Bold", size: 18.0)
        labelSong.textColor = UIColor.white
        //labelSong.backgroundColor = UIColor.green
        
        let labelSongByArtistSeeAll = UILabel()
        labelSongByArtistSeeAll.frame = CGRect(x: UIScreen.main.bounds.width-80, y: titleContainer.frame.height+10, width: 70, height:20)
        labelSongByArtistSeeAll.text = NSLocalizedString("ViewAll".localized(using: "Localizable"), comment: "")
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
        
        viewBrowseArtist.addSubview(one)
        
        view.addSubview(viewBrowseArtist)
    }
    
    @objc func buttonClickedAddArtistToLibrary(recognizer: PlaylistPlayGesture) {
        addToLibrary(key: "A", songs: recognizer.id)
    }
    
    func addToLibrary(key: String, songs: Int) {
        
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        
        self.homeDataModel.addToLibrary(key: key, songs: songs, addToLibraryCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.alert(message: NSLocalizedString("AddedToLibrary".localized(using: "Localizable"), comment: ""))
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
