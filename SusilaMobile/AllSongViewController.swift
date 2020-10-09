//
//  AllSongViewController.swift
//  SusilaMobile
//
//  Created by Kiroshan on 6/3/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class AllSongViewController: UIViewController {
    
    var id: Int?
    var type: String?
    var key: String?
    var homeDataModel = HomeDataModel()
    var searchViewModel = SearchViewModel()
    
    
    var playerView: PlayerView? {
        didSet {
            scrollCollectionExapndedSongsByArtist?.playerView = self.playerView
        }
    }
    var scrollCollectionExapndedSongsByArtist:ScrollCollection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.color_background
        
        self.createPopularArtistSongsView(view: view, title: NSLocalizedString("Song".localized(using: "Localizable"), comment: ""))
        
        if type == "song" {
            search(key: key!, type: type!, offset: 0)
        } else {
            loadAllPopularArtistSongsList(id: id!)
        }
    }
    
    func createPopularArtistSongsView(view: UIView, title: String) {
        
        let viewAllPopularArtistSongs = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height))
        viewAllPopularArtistSongs.backgroundColor = Constants.color_background
        
        let viewGenreSongs = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-40))
        
        let songsViewContent = UIView(frame: CGRect(x: 0, y: 0, width: viewGenreSongs.frame.width, height: viewGenreSongs.frame.height))
        
        viewGenreSongs.addSubview(songsViewContent)
        
        scrollCollectionExapndedSongsByArtist = ScrollCollection(frame: CGRect(x: 0, y: 0, width: songsViewContent.frame.width, height: songsViewContent.frame.height))
        scrollCollectionExapndedSongsByArtist?.styleType = 13
        scrollCollectionExapndedSongsByArtist?.playerView = self.playerView
        songsViewContent.addSubview(scrollCollectionExapndedSongsByArtist!)
        
        
        viewAllPopularArtistSongs.addSubview(viewGenreSongs)
        
        viewAllPopularArtistSongs.addSubview(viewGenreSongs)
        //viewAllPopularArtistSongs.isHidden = true
         view.addSubview(viewAllPopularArtistSongs)
        //
    }
    
    func search(key: String, type: String, offset: Int) {
        ProgressView.shared.show(view, mainText: "", detailText: "")
        searchViewModel.searchByWordAll(key: key, type: type, offset: offset) { (status, error, isEmpty) in
            if (status && isEmpty) {
                let alert = UIAlertController(title: "Kiki", message: "No results available", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                ProgressView.shared.hide()
            } else {
                self.scrollCollectionExapndedSongsByArtist?.currentPlayingList = self.searchViewModel.songList
                print(self.searchViewModel.songList)
                ProgressView.shared.hide()
            }
        }
    }
    
    func loadAllPopularArtistSongsList(id: Int) {
        ProgressView.shared.show(view, mainText: "", detailText: "")
        self.homeDataModel.getHomePopularArtistSongs(id: id, getHomePopularArtistSongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.scrollCollectionExapndedSongsByArtist?.currentPlayingList = self.homeDataModel.popularArtistSongsList
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {ProgressView.shared.hide()})
            }
        })
    }
}
