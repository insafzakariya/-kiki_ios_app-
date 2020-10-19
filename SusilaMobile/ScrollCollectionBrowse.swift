//
//  ScrollCollectionBrowse.swift
//  SusilaMobile
//
//  Created by Admin on 11/7/19.
//  Copyright © 2019 Kiroshan T. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class ScrollCollectionBrowse: UIView, UIScrollViewDelegate {
    
    var scrollView = UIScrollView(frame: CGRect.zero)
    var contentView = UIView(frame: CGRect.zero)
    
    var librarySongs:[Song] = [Song]()
    var songCount = 0
    
    var playerView:PlayerView?
    
    var selectedTile:SongTileBrowse?
    var tiles:[SongTileBrowse] = [SongTileBrowse]()
    
    var selectedTileSquare:SongTileBrowseSquare?
    var tilesSquare:[SongTileBrowseSquare] = [SongTileBrowseSquare]()
    
    var selectedTileSquareSongs:SongTileBrowseSquareSongs?
    var tilesSquareSongs:[SongTileBrowseSquareSongs] = [SongTileBrowseSquareSongs]()
    
    var selectedTileArtists:SongTileBrowseArtists?
    var tilesArtists:[SongTileBrowseArtists] = [SongTileBrowseArtists]()
    
    var selectedTilePlaylist:SongTileBrowsePlaylist?
    var tilesPlaylist:[SongTileBrowsePlaylist] = [SongTileBrowsePlaylist]()
    
    var selectedTileAlbumByArtist:SongTileAlbumByArtist?
    var tilesAlbumByArtist:[SongTileAlbumByArtist] = [SongTileAlbumByArtist]()
    
    var selectedTileListSquareSongs:SongTileBrowseListSquareSongs?
    var tilesListSquareSongs:[SongTileBrowseListSquareSongs] = [SongTileBrowseListSquareSongs]()
    
    ///var selectedTileSeeAllArtist:SongTileSeeAllArtist?
    // var tilesSeeAllArtist:[SongTileSeeAllArtist] = [SongTileSeeAllArtist]()
    var addAlertDialog = AddAlertDialog()
    var confirmAlertDialog = ConfirmAlertDialog()
    var addToPlaylistAlertDialog = AddToPlaylistAlertDialog()
    var overLayView = UIView(frame: UIScreen.main.bounds)
    //var genre: GenreViewController?
    
    var styleType = 0{
        didSet{
            tilesSquareSongs.forEach{tile in
                tile.styleType = self.styleType
            }
        }
    }
    
    var browsePlayingList:[Song] = [Song](){
        willSet{
            contentView.subviews.forEach{ viewSub in
                viewSub.removeFromSuperview()
            }
        }
        didSet{
            contentView.removeFromSuperview()
            tilesSquareSongs = [SongTileBrowseSquareSongs]()
            // scroll view of expanded player
            
            if(styleType == 13){
                scrollView.removeFromSuperview()
                
                var xLength: CGFloat = 0
                
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: ((UIScreen.main.bounds.width-40)*1/3)+40))
                self.addSubview(scrollView)
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(browsePlayingList.count) * (self.frame.height - 20 ), height: scrollView.frame.height))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: CGFloat(browsePlayingList.count)*((UIScreen.main.bounds.width-10)*1/3), height: scrollView.frame.height)
                for (index, tileData) in browsePlayingList.enumerated(){
                    let songTile = SongTileBrowse(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
                    songTile.lblDescription.text = tileData.description
                    songTile.lblTitle.text = tileData.name
                    var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                    songTile.index = index
                    let tapGestureRecognizer = playSongTapGesture(target: self, action: #selector(imageTappedYouMightLike(tapGestureRecognizer:)))
                    tapGestureRecognizer.id = index
                    songTile.isUserInteractionEnabled = true
                    songTile.addGestureRecognizer(tapGestureRecognizer)
                    songTile.styleType = self.styleType
                    xLength += ((UIScreen.main.bounds.width-40)*1/3)+10
                    contentView.addSubview(songTile)
                    if index == 0 {
                        selectedTile = songTile
                        songTile.isSelected = true
                    }
                    tiles.append(songTile)
                }
            }
            
            else if(styleType == 14){
                scrollView.removeFromSuperview()
                
                var xLength: CGFloat = 0
                
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: ((UIScreen.main.bounds.width-40)*1/3)+40))
                self.addSubview(scrollView)
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(browsePlayingList.count) * (self.frame.height - 20 ), height: scrollView.frame.height))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: CGFloat(browsePlayingList.count)*((UIScreen.main.bounds.width-10)*1/3), height: scrollView.frame.height)
                for (index, tileData) in browsePlayingList.enumerated(){
                    let songTile = SongTileBrowseSquare(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
                    songTile.lblDescription.text = tileData.description
                    songTile.lblTitle.text = tileData.name
                    var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                    songTile.index = index
                    let tapGestureRecognizer = playSongTapGesture(target: self, action: #selector(imageTappedYouMightLike(tapGestureRecognizer:)))
                    tapGestureRecognizer.id = index
                    songTile.isUserInteractionEnabled = true
                    songTile.addGestureRecognizer(tapGestureRecognizer)
                    songTile.styleType = self.styleType
                    xLength += ((UIScreen.main.bounds.width-40)*1/3)+10
                    contentView.addSubview(songTile)
                    if index == 0 {
                        selectedTileSquare = songTile
                        songTile.isSelected = true
                    }
                    tilesSquare.append(songTile)
                }
            }
            
            else if(styleType == 15){
                createViewSongs()
            }
            
            else if(styleType == 16){
                scrollView.removeFromSuperview()
                
                var xLength: CGFloat = 10
                
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width-40)*1/3+10))
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                self.addSubview(scrollView)
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(browsePlayingList.count) * (self.frame.height - 20 ), height: scrollView.frame.height))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: CGFloat(browsePlayingList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: scrollView.frame.height)
                for (index, tileData) in browsePlayingList.enumerated(){
                    let songTile = SongTileBrowseArtists(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
                    songTile.lblDescription.text = tileData.artist
                    songTile.lblTitle.text = tileData.name
                    var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                    songTile.index = index
                    let tapGestureRecognizer = playSongTapGesture(target: self, action: #selector(imageTappedYouMightLike(tapGestureRecognizer:)))
                    tapGestureRecognizer.id = index
                    songTile.isUserInteractionEnabled = true
                    songTile.addGestureRecognizer(tapGestureRecognizer)
                    songTile.styleType = self.styleType
                    xLength += ((UIScreen.main.bounds.width-40)*1/3)
                    contentView.addSubview(songTile)
                    if index == 0 {
                        selectedTileArtists = songTile
                        songTile.isSelected = true
                    }
                    tilesArtists.append(songTile)
                }
            }
            else if(styleType == 17){
                scrollView.removeFromSuperview()
                
                var xLength: CGFloat = 10
                
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/2-30))
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                self.addSubview(scrollView)
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(browsePlayingList.count)*(UIScreen.main.bounds.width/2-30)+(CGFloat(browsePlayingList.count)*10)+10, height: scrollView.frame.height))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: CGFloat(browsePlayingList.count)*(UIScreen.main.bounds.width/2-30)+(CGFloat(browsePlayingList.count)*10)+10, height: scrollView.frame.height)
                for (index, tileData) in browsePlayingList.enumerated(){
                    let songTile = SongTileBrowsePlaylist(frame: CGRect(x: xLength, y: 0, width: UIScreen.main.bounds.width/2-30, height: UIScreen.main.bounds.width/2-30))
                    songTile.lblDescription.text = tileData.description
                    songTile.lblTitle.text = tileData.name
                    var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                    songTile.index = index
                    songTile.styleType = self.styleType
                    xLength += UIScreen.main.bounds.width/2-30+10
                    contentView.addSubview(songTile)
                    if index == 0 {
                        selectedTilePlaylist = songTile
                        songTile.isSelected = true
                    }
                    tilesPlaylist.append(songTile)
                }
            }
            else if(styleType == 18){
                scrollView.removeFromSuperview()
                
                var xLength: CGFloat = 10
                
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/2+10))
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                self.addSubview(scrollView)
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(browsePlayingList.count)*(UIScreen.main.bounds.width/2-30)+(CGFloat(browsePlayingList.count)*10)+10, height: scrollView.frame.height))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: CGFloat(browsePlayingList.count)*(UIScreen.main.bounds.width/2-30)+(CGFloat(browsePlayingList.count)*10)+10, height: scrollView.frame.height)
                for (index, tileData) in browsePlayingList.enumerated(){
                    let songTile = SongTileAlbumByArtist(frame: CGRect(x: xLength, y: 0, width: UIScreen.main.bounds.width/2-30, height: UIScreen.main.bounds.width/2-30))
                    songTile.lblDescription.text = tileData.description
                    songTile.lblTitle.text = tileData.name
                    var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                    songTile.index = index
                    songTile.styleType = self.styleType
                    xLength += UIScreen.main.bounds.width/2-30+10
                    contentView.addSubview(songTile)
                    if index == 0 {
                        selectedTileAlbumByArtist = songTile
                        songTile.isSelected = true
                    }
                    tilesAlbumByArtist.append(songTile)
                }
            }
            
            else if(styleType == 19){
                scrollView.removeFromSuperview()
                scrollView = UIScrollView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-40))
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.showsVerticalScrollIndicator = false
                
                self.addSubview(scrollView)
                
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: CGFloat(browsePlayingList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(browsePlayingList.count)*20)+290))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(browsePlayingList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(browsePlayingList.count)*20)+290)
                
                var xLength: CGFloat = 10
                
                for (index, tileData) in browsePlayingList.enumerated(){
                    let songTile = SongTileBrowseListSquareSongs(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
                    songTile.lblDescription.text = tileData.artist
                    songTile.lblTitle.text = tileData.name
                    var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                    songTile.index = index
                    songTile.albums.text = timeString(time: TimeInterval(tileData.duration!))
                    songTile.songs.text = String(tileData.date!)
                    
                    let tapAdd = PlaylistTapGesture(target: self, action: #selector(buttonClick_Add))
                    tapAdd.title = tileData.name
                    tapAdd.id = String(tileData.id)
                    songTile.add.isUserInteractionEnabled = true
                    songTile.add.addGestureRecognizer(tapAdd)
                    
                    let tapGestureRecognizer = playSongTapGesture(target: self, action: #selector(imageTappedYouMightLike(tapGestureRecognizer:)))
                    tapGestureRecognizer.id = index
                    songTile.isUserInteractionEnabled = true
                    songTile.addGestureRecognizer(tapGestureRecognizer)
                    songTile.styleType = self.styleType
                    xLength += UIScreen.main.bounds.width/6+20
                    contentView.addSubview(songTile)
                    if index == 0 {
                        selectedTileListSquareSongs = songTile
                        songTile.isSelected = true
                    }
                    tilesListSquareSongs.append(songTile)
                }
            }
            
            else if(styleType == 20){
                createViewSeeAllSongs()
            }
            
            /*else if(styleType == 18){
             scrollView.removeFromSuperview()
             
             var xLength: CGFloat = 10
             
             scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
             //scrollView.showsVerticalScrollIndicator = false
             //scrollView.showsHorizontalScrollIndicator = false
             self.addSubview(scrollView)
             contentView = UIView(frame: CGRect(x: 10, y: 0, width: scrollView.frame.width, height: CGFloat(browsePlayingList.count)*(UIScreen.main.bounds.width/4)+(CGFloat(browsePlayingList.count)*20)+270))
             scrollView.addSubview(contentView)
             scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(browsePlayingList.count)*(UIScreen.main.bounds.width/4)+(CGFloat(browsePlayingList.count)*20)+270)
             for (index, tileData) in browsePlayingList.enumerated(){
             let songTile = SongTileSeeAllArtist(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/4))
             songTile.lblDescription.text = tileData.description
             songTile.lblTitle.text = tileData.name
             songTile.imageURL = tileData.image!
             songTile.index = index
             let tap = MyTapGesture(target: self, action: #selector(buttonClickedArtist))
             tap.aname = tileData.name
             tap.url = tileData.image!
             songTile.isUserInteractionEnabled = true
             songTile.addGestureRecognizer(tap)
             songTile.styleType = self.styleType
             xLength += UIScreen.main.bounds.width/4+20
             contentView.addSubview(songTile)
             if index == 0 {
             selectedTileSeeAllArtist = songTile
             songTile.isSelected = true
             }
             tilesSeeAllArtist.append(songTile)
             }
             }*/
        }
    }
    
    func createViewSongs() {
        scrollView.removeFromSuperview()
        var xLength: CGFloat = 10
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ((UIScreen.main.bounds.width-40)*1/3-10)+40))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(browsePlayingList.count) * (self.frame.height - 20 ), height: scrollView.frame.height))
        scrollView.addSubview(contentView)
        scrollView.contentSize = CGSize(width: CGFloat(browsePlayingList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: scrollView.frame.height)
        for (index, tileData) in browsePlayingList.enumerated(){
            let songTile = SongTileBrowseSquareSongs(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
            songTile.lblDescription.text = tileData.artist
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            let tapGestureRecognizer = playSongTapGesture(target: self, action: #selector(imageTappedYouMightLike(tapGestureRecognizer:)))
            tapGestureRecognizer.id = index
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tapGestureRecognizer)
            songTile.styleType = self.styleType
            xLength += ((UIScreen.main.bounds.width-40)*1/3)
            contentView.addSubview(songTile)
            if index == 0 {
                selectedTileSquareSongs = songTile
                songTile.isSelected = true
            }
            tilesSquareSongs.append(songTile)
        }
    }
    
    func createViewSeeAllSongs() {
        scrollView.removeFromSuperview()
        scrollView = UIScrollView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-40))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        self.addSubview(scrollView)
        
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: CGFloat(browsePlayingList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(browsePlayingList.count)*20)+290))
        scrollView.addSubview(contentView)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(browsePlayingList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(browsePlayingList.count)*20)+290)
        
        var xLength: CGFloat = 10
        
        for (index, tileData) in browsePlayingList.enumerated(){
            let songTile = SongsTileLibrarySongsSeeAll(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblDescription.text = tileData.artist
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = index
            songTile.albums.text = timeString(time: TimeInterval(tileData.duration!))
            songTile.songs.text = String(tileData.date!)
            
            let tapRemove = GenreTapGesture(target: self, action: #selector(buttonClickedRemoveSongFromLibrary))
            tapRemove.title = tileData.name
            tapRemove.id = String(tileData.id)
            songTile.remove.isUserInteractionEnabled = true
            songTile.remove.addGestureRecognizer(tapRemove)
            
            let tapAdd = GenreTapGesture(target: self, action: #selector(buttonClickedAddSongToPlaylist))
            tapAdd.title = tileData.name
            tapAdd.id = String(tileData.id)
            addAlertDialog.id = tileData.id
            songTile.add.isUserInteractionEnabled = true
            songTile.add.addGestureRecognizer(tapAdd)
            
            let tapGestureRecognizer = playSongTapGesture(target: self, action: #selector(imageTappedYouMightLike(tapGestureRecognizer:)))
            tapGestureRecognizer.id = index
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tapGestureRecognizer)
            songTile.styleType = self.styleType
            xLength += UIScreen.main.bounds.width/6+20
            contentView.addSubview(songTile)
            //print("WellDone")
        }
    }
    
    @objc func buttonClickedRemoveSongFromLibrary(recognizer: GenreTapGesture) {
        showConfirmAlertDialog(title: "DoYouWantToRemoveThisFromLibrary".localizedString + recognizer.title, id: recognizer.id)
        
    }
    
    @objc func buttonClickedAddSongToPlaylist(recognizer: GenreTapGesture) {
        loadPlaylistsList()
        showAddToPlaylistAlertDialog(title: "Select Playlist", id: recognizer.id)
    }
    
    func removeFromLibrary(key: String, id: Int) {
        
        print("key: "+key+"id: ",id)
        confirmAlertDialog.isHidden = true
        confirmAlertDialog.removeFromSuperview()
        overLayView.removeFromSuperview()
        
        if key=="S" || key=="P" {
            ProgressView.shared.show(self, mainText: nil, detailText: nil)
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
                    self.loadLibrarySongList()
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    //Reload library songs
    func loadLibrarySongList() {
        self.libraryDataModel.getLibrarySongs(getLibrarySongsListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    //let minimizedArray = self.libraryDataModel.librarySongsList.chunked(into: 10)
                    //self.librarySongs = self.libraryDataModel.librarySongsList.count > 10 ? minimizedArray[0] : self.libraryDataModel.librarySongsList
                    self.browsePlayingList = self.libraryDataModel.librarySongsList
                    //self.createViewSongs()
                    self.createViewSeeAllSongs()
                })
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
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
    
    /*var vi = UIView(frame: CGRect.zero)
     var image = UIImageView(frame: CGRect.zero)
     @objc func buttonClickedArtist (recognizer: MyTapGesture) {
     print(recognizer.aname)
     print(recognizer.url)
     
     vi = UIView(frame: CGRect(x: 0, y: -40, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
     vi.backgroundColor = UIColor.blue
     //vi.isUserInteractionEnabled = false
     
     let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
     let tap = UITapGestureRecognizer(target: self, action: #selector(goArtistButtonClicked))
     topBar.isUserInteractionEnabled = true
     topBar.addGestureRecognizer(tap)
     
     let arrow = UIButton(frame: CGRect(x: 40, y: 10, width: 20, height: 20))
     arrow.addTarget(UITapGestureRecognizer.self, action: #selector(goArtistButtonClicked), for: .touchUpInside)
     
     let titleContainer = UIView(frame: CGRect(x: 0, y: topBar.frame.height, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3+40))
     titleContainer.center.x = vi.center.x
     titleContainer.backgroundColor = UIColor.red
     
     image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3))
     image.downloadImageBrowse(from: URL(string: recognizer.url)!)
     image.layer.cornerRadius = 5
     image.layer.cornerRadius = (UIScreen.main.bounds.width/3)/2
     image.clipsToBounds = true
     
     let lblTitle = UILabel(frame: CGRect(x: 0, y: 180, width: 200, height: 20))
     let albums = UILabel(frame: CGRect.zero)
     let songs = UILabel(frame: CGRect.zero)
     
     titleContainer.addSubview(image)
     titleContainer.addSubview(lblTitle)
     titleContainer.addSubview(albums)
     titleContainer.addSubview(songs)
     topBar.addSubview(arrow)
     vi.addSubview(topBar)
     vi.addSubview(titleContainer)
     self.addSubview(vi)
     
     /*if(sender.tag == 5){
     
     var abc = "argOne" //Do something for tag 5
     }
     print("hello")*/
     print("hello")
     
     }*/
    
    @objc func imageTappedYouMightLike(tapGestureRecognizer: playSongTapGesture) {
        playerView?.radioStatus = "song"
        if (mainInstance.subscribeStatus) {
            subscribeAlert()
        } else {
            let index = tapGestureRecognizer.id
            print("ind", index)
            changeSong(index: index)
            playerView?.currentPlayingList = self.browsePlayingList
            print("ind", browsePlayingList)
            playerView?.currentPlayingIndex = index
            playerView?.currentPlayingTime = 0
            playerView?.videoPlayer.pause()
            playerView?.videoPlayer.seek(to: CMTimeMake(value: 0, timescale: 1))
            playerView?.scrollCollection.changeSong(index: index)
            playerView?.play()
        }
    }
    
    func changeSong(index: Int){
        if (styleType == 0){
            tiles.forEach{tile in
                tile.isSelected = false //last change
            }
            tiles[index].isSelected = true
            scrollView.setContentOffset(CGPoint(x: index * 200, y: 0), animated: true)
        }
        else if (styleType == 1){
            tiles.forEach{tile in
                tile.isSelected = true
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
        
        confirmAlertDialog = ConfirmAlertDialog(frame: getCenteredFrameForOverlay2(130))
        confirmAlertDialog.isHidden = true
        confirmAlertDialog.layer.zPosition = 1002
        
        let tapYes = GenreTapGesture(target: self, action: #selector(buttonClick_Yes))
        confirmAlertDialog.btnYes.isUserInteractionEnabled = true
        confirmAlertDialog.btnYes.addGestureRecognizer(tapYes)
        
        let tapNo = PlaylistPlayGesture(target: self, action: #selector(buttonClick_No))
        confirmAlertDialog.btnNo.isUserInteractionEnabled = true
        confirmAlertDialog.btnNo.addGestureRecognizer(tapNo)
        
        addToPlaylistAlertDialog = AddToPlaylistAlertDialog(frame: getCenteredFrameForOverlay(300))
        addToPlaylistAlertDialog.isHidden = true
        addToPlaylistAlertDialog.layer.zPosition = 2002
        //addToPlaylistAlertDialog.scrollCollection = self
        addToPlaylistAlertDialog.btnCancel.addTarget(self, action: #selector(cancelClickAddToPlaylistAlertDialog), for: .touchUpInside)
        
        self.addSubview(addAlertDialog)
        self.addSubview(confirmAlertDialog)
        self.addSubview(addToPlaylistAlertDialog)
    }
    
    @objc func buttonClick_Add(sender:PlaylistTapGesture) {
        showAddAlertDialog(title: sender.title, id: sender.id)
    }
    
    func getCenteredFrameForOverlay(_ height: CGFloat) -> CGRect {
        return CGRect(x: 15, y: (UIScreen.main.bounds.height - 250 - height)/2, width: UIScreen.main.bounds.width - 30 , height: height)
    }
    
    func getCenteredFrameForOverlay2(_ height: CGFloat) -> CGRect {
        return CGRect(x: UIScreen.main.bounds.width/4, y: (UIScreen.main.bounds.height - 250 - height)/2, width: UIScreen.main.bounds.width/2 , height: height)
    }
    
    @objc func cancelClickAddAlertDialog(sender:PlaylistTapGesture) {
        addAlertDialog.isHidden = true
        addAlertDialog.removeFromSuperview()
        overLayView.removeFromSuperview()
    }
    
    @objc func buttonClick_AddToLibrary(sender:PlaylistPlayGesture) {
        addToLibrary(key: "S", songs: addAlertDialog.id)
    }
    
    @objc func buttonClick_Yes(sender:GenreTapGesture) {
        removeFromLibrary(key: "S", id: confirmAlertDialog.id)
    }
    
    @objc func buttonClick_No(sender:PlaylistPlayGesture) {
        confirmAlertDialog.isHidden = true
        confirmAlertDialog.removeFromSuperview()
        overLayView.removeFromSuperview()
    }
    
    func showAddAlertDialog(title: String, id: String) {
        overLayView.removeFromSuperview()
        self.addSubview(overLayView)
        self.addSubview(addAlertDialog)
        addAlertDialog.lblTitle.text = title
        addAlertDialog.id = Int(id)!
        addAlertDialog.isHidden = false
    }
    
    func showConfirmAlertDialog(title: String, id: String) {
        overLayView.removeFromSuperview()
        self.addSubview(overLayView)
        self.addSubview(confirmAlertDialog)
        confirmAlertDialog.lblTitle.text = title
        confirmAlertDialog.id = Int(id)!
        confirmAlertDialog.isHidden = false
    }
    
    @objc func buttonClick_AddToPlaylist(sender:PlaylistPlayGesture) {
        addToPlaylistAlertDialog.removeFromSuperview()
        loadPlaylistsList()
        showAddToPlaylistAlertDialog(title: "Select Playlist", id: String(sender.id))
    }
    
    @objc func cancelClickAddToPlaylistAlertDialog(sender:PlaylistTapGesture) {
        addToPlaylistAlertDialog.isHidden = true
        addToPlaylistAlertDialog.removeFromSuperview()
    }
    
    func showAddToPlaylistAlertDialog(title: String, id: String) {
        self.addSubview(addToPlaylistAlertDialog)
        addToPlaylistAlertDialog.id = addAlertDialog.id
        addToPlaylistAlertDialog.isHidden = false
    }
    
    var homeDataModel = HomeDataModel()
    var libraryDataModel = LibraryDataModel()
    func addToLibrary(key: String, songs: Int) {
        ProgressView.shared.show(addAlertDialog, mainText: nil, detailText: nil)
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
    
    var libraryAllPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
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
            
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickAddSongToPlaylist))
            tap.id = String(tileData.id)
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            xLength += UIScreen.main.bounds.width/6+20
            uiAlert.addSubview(songTile)
        }
        view.addSubview(uiAlert)
        
        self.addToPlaylistAlertDialog.scrollList.contentSize = CGSize(width: self.addToPlaylistAlertDialog.scrollList.frame.width, height: CGFloat(libraryAllPlaylists.count)*(UIScreen.main.bounds.width/6)+CGFloat(libraryAllPlaylists.count)*20)
    }
    
    @objc func buttonClickAddSongToPlaylist(recognizer: PlaylistTapGesture) {
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






/*class SongTileSeeAllArtist2: UIView {
 var imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
 var image = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-40)*1/3, height: (UIScreen.main.bounds.width-40)*1/3))
 var lblTitle = UILabel(frame: CGRect(x: 0, y: 180, width: 200, height: 20))
 var lblDescription = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 20))
 var albums = UILabel(frame: CGRect.zero)
 var songs = UILabel(frame: CGRect.zero)
 //let selectedColor = UIColor(red: 198/255, green: 241/255, blue: 253/255, alpha: 1.0)
 var line = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5))
 let selectedColor = Constants.videoAppBackColor
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
 image.downloadImageBrowse(from: URL(string: imageURL)!)
 }
 }
 
 var isSelected = false{
 willSet{
 self.backgroundColor = UIColor.clear
 
 
 }
 didSet{
 if (styleType == 0){
 self.imageContainer.backgroundColor = isSelected ? selectedColor : UIColor.clear
 //self.lblDescription.isHidden = !isSelected
 //self.lblTitle.isHidden = !isSelected
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
 
 imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width , height: self.frame.width ))
 image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4))
 lblTitle = UILabel(frame: CGRect(x: image.frame.width+10, y: 0, width: self.frame.width-20 , height: 20))
 lblDescription = UILabel(frame: CGRect(x: image.frame.width+10, y: lblTitle.frame.height, width: self.frame.width-20, height: 20))
 
 albums = UILabel(frame: CGRect(x: image.frame.width+10, y: lblTitle.frame.height+lblDescription.frame.height+10, width: self.frame.width-20, height: 20))
 albums.text = "2 albums"
 albums.font = UIFont.systemFont(ofSize: 13)
 albums.textColor = UIColor.gray
 
 songs = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2, y: lblTitle.frame.height+lblDescription.frame.height+10, width: self.frame.width-20, height: 20))
 songs.text = "14 songs"
 songs.font = UIFont.systemFont(ofSize: 13)
 songs.textColor = UIColor.gray
 
 line = UIView(frame: CGRect(x: 0, y: image.frame.height+10, width: UIScreen.main.bounds.width-20 , height: 0.5))
 line.backgroundColor = UIColor.gray
 
 image.layer.cornerRadius = 5
 image.layer.cornerRadius = (UIScreen.main.bounds.width/4)/2
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
 self.addSubview(albums)
 self.addSubview(songs)
 self.addSubview(line)
 }
 }*/

extension UIImageView{
    func getDataBrowse(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImageBrowse(from url: URL) {
        getDataBrowse(from: url) { data, response, error in
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


