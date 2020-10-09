//
//  ScrollCollection.swift
//  SusilaMobile
//
//  Created by MacBookSH on 1/14/19.
//  Copyright © 2019 Isuru Jayathissa. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class ScrollCollection: UIView, UIScrollViewDelegate {
    var dashboardViewController = DashboardViewController()
    var libraryDataModel = LibraryDataModel()
    var homeDataModel = HomeDataModel()
    var addAlertDialog = AddAlertDialog()
    var addToPlaylistAlertDialog = AddToPlaylistAlertDialog()
    var id="", name=""
    
    var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width-50))
    var contentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width-50))
    
    var playerView: PlayerView?
    
    var selectedTile: SongTilePlayer?
    var tiles: [SongTilePlayer] = [SongTilePlayer]()
    
    var selectedTileSquareSongs: SongTileHomeSquareSongs?
    var tilesSquareSongs: [SongTileHomeSquareSongs] = [SongTileHomeSquareSongs]()
    
    var selectedTileListSquareSongs: SongTileHomeListSquareSongs?
    var tilesListSquareSongs: [SongTileHomeListSquareSongs] = [SongTileHomeListSquareSongs]()
    
    var styleType = 0 {
        didSet {
            tiles.forEach {
                tile in
                tile.styleType = self.styleType
            }
        }
    }
    
    func loadImage(fromURL urlString: String, toImageView imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            return
        }
        var delay: Double = 0
        //Fetch image
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //Did we get some data back?
            if let data = data {
                //Yes we did, update the imageview then
                let image = UIImage(data: data)
                // DispatchQueue.main.async {
                //    imageView.image = image
                //}
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    // Put your code which should be executed with a delay here
                    imageView.image = image
                })
                delay += 0.8
                
            }
        }.resume() //remember this one or nothing will happen :)
    }
    
    var currentPlayingList:[Song] = [Song]() {
        willSet {
            contentView.subviews.forEach {
                viewSub in
                viewSub.removeFromSuperview()
            }
        } didSet {
            contentView.removeFromSuperview()
            tiles = [SongTilePlayer]()
            
            if (styleType == 0) { // scroll view of expanded player
                let contentViewEmptySpaceWidth = UIScreen.main.bounds.width-(UIScreen.main.bounds.width-60)
                
                contentView = UIView(frame: CGRect(x: 0, y: 0, width:(CGFloat(currentPlayingList.count)*(UIScreen.main.bounds.width-60))+contentViewEmptySpaceWidth, height: UIScreen.main.bounds.width))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width:(CGFloat(currentPlayingList.count)*(UIScreen.main.bounds.width-60))+contentViewEmptySpaceWidth, height: UIScreen.main.bounds.width-50)
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                
                //var xLength: CGFloat = 30
                
                for (index, tileData) in currentPlayingList.enumerated() {
                    let songTile = SongTilePlayer(frame: CGRect(x: (CGFloat(index)*(UIScreen.main.bounds.width-60))+contentViewEmptySpaceWidth/2, y: 0, width: UIScreen.main.bounds.width-60, height: UIScreen.main.bounds.width-50))
                    songTile.lblDescription.text = tileData.artist
                    songTile.lblTitle.text = tileData.name
                    var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                    songTile.index = index
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                    tapGestureRecognizer.accessibilityHint = String(tileData.id)+"|"+tileData.name
                    songTile.image.isUserInteractionEnabled = true
                    songTile.image.addGestureRecognizer(tapGestureRecognizer)
                    songTile.styleType = self.styleType
                    contentView.addSubview(songTile)
                    if index == 0 {
                        selectedTile = songTile
                        songTile.isSelected = true
                    }
                    tiles.append(songTile)
                    //xLength += UIScreen.main.bounds.width-60
                }
                
            } else if(styleType == 1) { // scroll view of minimized you might like
                scrollView.removeFromSuperview()
                var xLength: CGFloat = 10
                
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ((UIScreen.main.bounds.width-40)*1/3-10)+40))
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                self.addSubview(scrollView)
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(currentPlayingList.count) * (self.frame.height - 20 ), height: scrollView.frame.height))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: CGFloat(currentPlayingList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: scrollView.frame.height)
                for (index, tileData) in currentPlayingList.enumerated() {
                    let songTile = SongTileHomeSquareSongs(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
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
                
            } else if(styleType == 2) {
                scrollView.removeFromSuperview()
                var xLength: CGFloat = 10
                
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ((UIScreen.main.bounds.width-40)*1/3-10)+20))
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                self.addSubview(scrollView)
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(currentPlayingList.count) * (self.frame.height - 20 ), height: scrollView.frame.height))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: CGFloat(currentPlayingList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: scrollView.frame.height)
                for (index, tileData) in currentPlayingList.enumerated() {
                    let songTile = SongTileHomeSquareSongs(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
                    songTile.lblDescription.text = ""
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
                
            } else if(styleType == 3) {
                scrollView.removeFromSuperview()
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - 250))
                self.addSubview(scrollView)
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(currentPlayingList.count) * (self.frame.height - 20 ), height: self.frame.height))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: CGFloat(currentPlayingList.count)*(self.frame.height - 20 ), height: self.frame.height )
                for (index, tileData) in currentPlayingList.enumerated() {
                    let songTile = SongTileHomeSquareSongs(frame: CGRect(x: CGFloat(CGFloat(index)*(self.frame.height-80)), y: 0, width: self.frame.height-60, height: self.frame.height-60))
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
                    contentView.addSubview(songTile)
                    if index == 0 {
                        selectedTileSquareSongs = songTile
                        songTile.isSelected = true
                    }
                    tilesSquareSongs.append(songTile)
                }
            } else if(styleType == 12) { // scroll view of expanded you might like
                scrollView.removeFromSuperview()
                scrollView = UIScrollView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width - 250))
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.showsVerticalScrollIndicator = false
                //                scrollView.backgroundColor = UIColor.yellow
                self.addSubview(scrollView)
                let tileWidth = (UIScreen.main.bounds.width - 50) / 3
                let tileHeight = tileWidth + 20
                let rowsCount = currentPlayingList.count % 3 == 0 ? currentPlayingList.count / 3 : (currentPlayingList.count / 3) + 1
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat(rowsCount) * tileHeight))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: self.frame.width, height:  CGFloat(rowsCount) * tileHeight )
                for (index, tileData) in currentPlayingList.enumerated() {
                    let songTile = SongTilePlayer(frame: CGRect(x: 10 + CGFloat(index % 3) * (tileWidth + 10), y: CGFloat( index/3)*tileHeight, width: tileWidth, height: tileHeight))
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
                    contentView.addSubview(songTile)
                    if index == 0 {
                        selectedTile = songTile
                        songTile.isSelected = true
                    }
                    tiles.append(songTile)
                }
                
            } else if(styleType == 13) {
                scrollView.removeFromSuperview()
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-40))
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.showsVerticalScrollIndicator = false
                
                self.addSubview(scrollView)
                
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: CGFloat(currentPlayingList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(currentPlayingList.count)*20)+290))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(currentPlayingList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(currentPlayingList.count)*20)+290)
                
                var xLength: CGFloat = 10
                
                for (index, tileData) in currentPlayingList.enumerated() {
                    let songTile = SongTileHomeListSquareSongs(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
                    songTile.id = tileData.id
                    songTile.lblDescription.text = tileData.artist
                    songTile.lblTitle.text = tileData.name
                    songTile.index = index
                    
                    var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                    
                    let tapAdd = PlaylistTapGesture(target: self, action: #selector(buttonClick_Add))
                    tapAdd.title = tileData.name
                    tapAdd.id = String(tileData.id)
                    songTile.add.isUserInteractionEnabled = true
                    songTile.add.addGestureRecognizer(tapAdd)
                    
                    songTile.duration.text = timeString(time: TimeInterval(tileData.duration!))
                    songTile.year.text = String(tileData.date!)
                    let tapGestureRecognizer = playSongTapGesture(target: self, action: #selector(imageTappedYouMightLike(tapGestureRecognizer:)))
                    tapGestureRecognizer.id = index
                    songTile.isUserInteractionEnabled = true
                    songTile.addGestureRecognizer(tapGestureRecognizer)
                    songTile.styleType = self.styleType
                    songTile.line.isHidden = false
                    xLength += UIScreen.main.bounds.width/6+20
                    contentView.addSubview(songTile)
                    //print("WellDone")
                    if index == 0 {
                        selectedTileListSquareSongs = songTile
                        songTile.isSelected = true
                    }
                    tilesListSquareSongs.append(songTile)
                }
                
            } else if(styleType == 132){
                scrollView.removeFromSuperview()
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-40))
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.showsVerticalScrollIndicator = false
                               
                self.addSubview(scrollView)
                               
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: CGFloat(currentPlayingList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(currentPlayingList.count)*20)+290))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(currentPlayingList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(currentPlayingList.count)*20)+290)
                               
                var xLength: CGFloat = 10
                               
                for (index, tileData) in currentPlayingList.enumerated() {
                    let songTile = SongTileHomeListSquareSongs(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
                    songTile.id = tileData.id
                    songTile.lblDescription.text = tileData.artist
                    songTile.lblTitle.text = tileData.name
                    songTile.index = index
                                   
                    var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                                   
                    let tapAdd = PlaylistTapGesture(target: self, action: #selector(buttonClick_Add))
                    tapAdd.title = tileData.name
                    tapAdd.id = String(tileData.id)
                    songTile.add.isUserInteractionEnabled = true
                    songTile.add.addGestureRecognizer(tapAdd)
                                   
                    songTile.duration.text = timeString(time: TimeInterval(tileData.duration!))
                    songTile.year.text = String(tileData.date!)
                    let tapGestureRecognizer = playSongTapGesture(target: self, action: #selector(imageTappedYouMightLike(tapGestureRecognizer:)))
                                    tapGestureRecognizer.id = index
                    songTile.isUserInteractionEnabled = true
                    songTile.addGestureRecognizer(tapGestureRecognizer)
                    songTile.styleType = self.styleType
                    songTile.line.isHidden = false
                    xLength += UIScreen.main.bounds.width/6+20
                    contentView.addSubview(songTile)
                                   //print("WellDone")
                    if index == 0 {
                        selectedTileListSquareSongs = songTile
                        songTile.isSelected = true
                    }
                    tilesListSquareSongs.append(songTile)
                }
                
            } else if(styleType == 14) {
                scrollView.removeFromSuperview()
                scrollView = UIScrollView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-40))
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.showsVerticalScrollIndicator = false
                    
                self.addSubview(scrollView)
                    
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: CGFloat(currentPlayingList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(currentPlayingList.count)*20)+290))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(currentPlayingList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(currentPlayingList.count)*20)+290)
                    
                var xLength: CGFloat = 10
                    
                for (index, tileData) in currentPlayingList.enumerated() {
                    let songTile = SongTileLibraryListSquareSongs(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
                    songTile.id = tileData.id
                    songTile.lblDescription.text = tileData.artist
                    songTile.lblTitle.text = tileData.name
                    var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                    songTile.index = index
                        
                    let tapAdd = PlaylistTapGesture(target: self, action: #selector(buttonClick_Add))
                    tapAdd.title = tileData.name
                    tapAdd.id = String(tileData.id)
                    songTile.add.isUserInteractionEnabled = true
                    songTile.add.addGestureRecognizer(tapAdd)
                        
                    songTile.duration.text = timeString(time: TimeInterval(tileData.duration!))
                    songTile.year.text = String(tileData.date!)
                    let tapGestureRecognizer = playSongTapGesture(target: self, action: #selector(imageTappedYouMightLike(tapGestureRecognizer:)))
                    tapGestureRecognizer.id = index
                    songTile.isUserInteractionEnabled = true
                    songTile.addGestureRecognizer(tapGestureRecognizer)
                    songTile.styleType = self.styleType
                    xLength += UIScreen.main.bounds.width/6+20
                    contentView.addSubview(songTile)
                }
                
            } else if(styleType == 15) {
                scrollView.removeFromSuperview()
                scrollView = UIScrollView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-40))
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.showsVerticalScrollIndicator = false
                        
                self.addSubview(scrollView)
                        
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: CGFloat(currentPlayingList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(currentPlayingList.count)*20)+290))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(currentPlayingList.count)*(UIScreen.main.bounds.width/6)+(CGFloat(currentPlayingList.count)*20)+290)
                        
                var xLength: CGFloat = 10
                        
                for (index, tileData) in currentPlayingList.enumerated() {
                    let songTile = SongTileLibraryListSquareSongsAdd(frame: CGRect(x: 0, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
                    songTile.id = tileData.id
                    songTile.lblDescription.text = tileData.artist
                    songTile.lblTitle.text = tileData.name
                    var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                    songTile.index = index
                            
                    let tapAdd = PlaylistTapGesture(target: self, action: #selector(buttonClick_AddSongToPlaylist))
                    tapAdd.title = tileData.name
                    addAlertDialog.id = tileData.id
                    tapAdd.id = String(tileData.id)
                    songTile.add.isUserInteractionEnabled = true
                    songTile.add.addGestureRecognizer(tapAdd)
                            
                    songTile.duration.text = timeString(time: TimeInterval(tileData.duration!))
                    songTile.year.text = String(tileData.date!)
                    let tapGestureRecognizer = playSongTapGesture(target: self, action: #selector(imageTappedYouMightLike(tapGestureRecognizer:)))
                    tapGestureRecognizer.id = index
                    songTile.isUserInteractionEnabled = true
                    songTile.addGestureRecognizer(tapGestureRecognizer)
                    songTile.styleType = self.styleType
                    xLength += UIScreen.main.bounds.width/6+20
                    contentView.addSubview(songTile)
                }
                
            } else if(styleType == 22) {
                scrollView.removeFromSuperview()
                var xLength: CGFloat = 10
                
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ((UIScreen.main.bounds.width-40)*1/3-10)+20))
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                self.addSubview(scrollView)
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(currentPlayingList.count) * (self.frame.height - 20 ), height: scrollView.frame.height))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: CGFloat(currentPlayingList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: scrollView.frame.height)
                for (index, tileData) in currentPlayingList.enumerated() {
                    let songTile = SongTileHomeSquareSongs(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
                    songTile.lblDescription.text = ""
                    songTile.lblTitle.text = tileData.name
                    var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                    songTile.index = index
                    
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedRadio(tapGestureRecognizer:)))
                    songTile.image.isUserInteractionEnabled = true
                    songTile.image.addGestureRecognizer(tapGestureRecognizer)
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
            
            if (tiles.count > 0){
                scrollView.scrollRectToVisible(tiles[0].frame, animated: true)
            }
        }
    }
    
    @objc func buttonClick_Add(sender:PlaylistTapGesture) {
        showAddAlertDialog(title: sender.title, id: sender.id)
    }
    
    @objc func buttonClick_AddSongToPlaylist(sender:PlaylistTapGesture) {
        loadPlaylistsList()
        showAddToPlaylistAlertDialog(title: "Select Playlist", id: String(addAlertDialog.id))
    }
    
    @objc func buttonClick_AddToLibrary(sender:PlaylistPlayGesture) {
        addToLibrary(key: "S", songs: addAlertDialog.id)
    }
    
    @objc func cancelClickAddAlertDialog(sender:PlaylistTapGesture) {
        addAlertDialog.isHidden = true
        addAlertDialog.removeFromSuperview()
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
    
    func addToLibrary(key: String, songs: Int) {
        ProgressView.shared.show(addAlertDialog, mainText: nil, detailText: nil)
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
    
    @objc func cancelClickAddToPlaylistAlertDialog(sender:PlaylistTapGesture) {
        addToPlaylistAlertDialog.isHidden = true
        addToPlaylistAlertDialog.removeFromSuperview()
    }
    
    
    var libraryAllPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
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
        self.window!.rootViewController!.present(alert, animated: true, completion: nil)
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        playerView?.radioStatus = "song"
        playerView?.currentPlayingList = self.currentPlayingList
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let index = tappedImage.tag
        
        let fullString: String = tapGestureRecognizer.accessibilityHint!
        let fullStringArr = fullString.components(separatedBy: "|")

        let firstString: String = fullStringArr[0]
        let lastString: String = fullStringArr[1]
        
        mainInstance.currentPlayingId = Int(firstString)!
        mainInstance.currentPlayingName = lastString
        
        changeSong(index: index)
        playerView?.currentPlayingIndex = index
        playerView?.currentPlayingTime = 0
        playerView?.videoPlayer.pause()
        playerView?.videoPlayer.seek(to: CMTimeMake(value: 0, timescale: 1))
        if (playerView?.isPlaying ?? false){
            playerView?.videoPlayer.play()
        }
        
        for (ind, listData) in self.currentPlayingList.enumerated() {
            if ind == index {
                mainInstance.currentPlayingId = listData.id
                mainInstance.currentPlayingName = listData.name
            }
        }
    }
    
    @objc func imageTappedYouMightLike(tapGestureRecognizer: playSongTapGesture) {
        playerView?.radioStatus = "song"
        if (mainInstance.subscribeStatus) {
            subscribeAlert()
        } else {
            let index = tapGestureRecognizer.id
            print("ind", index)
            changeSong(index: index)
            playerView?.currentPlayingList = self.currentPlayingList
            print("ind", currentPlayingList)
            playerView?.currentPlayingIndex = index
            playerView?.currentPlayingTime = 0
            playerView?.videoPlayer.pause()
            playerView?.videoPlayer.seek(to: CMTimeMake(value: 0, timescale: 1))
            playerView?.scrollCollection.changeSong(index: index)
            playerView?.play()
        }
        
        
    }
    
    @objc func imageTappedRadio(tapGestureRecognizer: UITapGestureRecognizer) {
        
        playerView?.radioStatus = "radio"
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let index = tappedImage.tag
        changeSong(index: index)
        playerView?.currentPlayingList = self.currentPlayingList
        playerView?.currentPlayingIndex = index
        playerView?.currentPlayingTime = 0
        playerView?.videoPlayer.pause()
        playerView?.videoPlayer.seek(to: CMTimeMake(value: 0, timescale: 1))
        playerView?.scrollCollection.changeSong(index: index)
        playerView?.play()
        
    }
    
    func changeSong(index: Int) {
        if (styleType == 0) {
            tiles.forEach{tile in
                tile.isSelected = false //last change
            }
            
            if (playerView!.currentPlayingIndex < currentPlayingList.count-1) && (playerView!.currentPlayingIndex > 0){
                tiles[index].isSelected = true
            }
            
            
            scrollView.setContentOffset(CGPoint(x: CGFloat(index)*(UIScreen.main.bounds.width-60), y: 0), animated: true)
            
        } else if (styleType == 1) {
            tiles.forEach{tile in
                tile.isSelected = true
            }
        }
        
        for (ind, listData) in self.currentPlayingList.enumerated() {
            if index == ind {
                mainInstance.currentPlayingId = listData.id
                mainInstance.currentPlayingName = listData.name
            }
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
        scrollView.addSubview(contentView)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width-50)
        self.addSubview(scrollView)
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
    }
    
    func getCenteredFrameForOverlay(_ height: CGFloat) -> CGRect {
        return CGRect(x: 15, y: (UIScreen.main.bounds.height - 250 - height)/2, width: UIScreen.main.bounds.width - 30 , height: height)
    }
    
}
