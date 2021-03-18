//
//  ScrollCollectionLibrary.swift
//  SusilaMobile
//
//  Created by Kiroshan T on 12/2/19.
//  Copyright © 2019 Isuru Jayathissa. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import SDWebImage

class ScrollCollectionLibrary: UIView, UIScrollViewDelegate {
    
    var playerView:PlayerView?
    
    var tiles:[SongTileLibrarySquareSongs] = [SongTileLibrarySquareSongs]()
    
    var scrollView = UIScrollView(frame: CGRect.zero)
    var contentView = UIView(frame: CGRect.zero)
    
    var selectedTileSquareSongs:SongTileLibrarySquareSongs?
    var tilesSquareSongs:[SongTileLibrarySquareSongs] = [SongTileLibrarySquareSongs]()
    
    var styleType = 0{
        didSet{
            tilesSquareSongs.forEach{tile in
                tile.styleType = self.styleType
            }
        }
    }
    
    var libraryPlayingList:[Song] = [Song](){
        willSet{
            contentView.subviews.forEach{ viewSub in
                viewSub.removeFromSuperview()
            }
        }
        didSet{
            contentView.removeFromSuperview()
            tilesSquareSongs = [SongTileLibrarySquareSongs]()
            
            if(styleType == 1){
                scrollView.removeFromSuperview()
                
                var xLength: CGFloat = 10
                
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ((UIScreen.main.bounds.width-40)*1/3-10)+40))
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                self.addSubview(scrollView)
                contentView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(libraryPlayingList.count) * (self.frame.height - 20 ), height: scrollView.frame.height))
                scrollView.addSubview(contentView)
                scrollView.contentSize = CGSize(width: CGFloat(libraryPlayingList.count)*((UIScreen.main.bounds.width-10)*1/3-10)+10, height: scrollView.frame.height)
                for (index, tileData) in libraryPlayingList.enumerated(){
                    let songTile = SongTileLibrarySquareSongs(frame: CGRect(x: xLength, y: 0, width: (UIScreen.main.bounds.width)*1/3, height: (UIScreen.main.bounds.width)*1/3))
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
                    xLength += ((UIScreen.main.bounds.width-40)*1/3)
                    contentView.addSubview(songTile)
                    if index == 0 {
                        selectedTileSquareSongs = songTile
                        songTile.isSelected = true
                    }
                    tilesSquareSongs.append(songTile)
                }
            }
        }
    }
    
    @objc func imageTappedYouMightLike(tapGestureRecognizer: playSongTapGesture) {
        playerView?.radioStatus = "song"
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let index = tappedImage.tag
        print("ind", index)
        changeSong(index: index)
        playerView?.currentPlayingList = self.libraryPlayingList
        print("ind", libraryPlayingList)
        playerView?.currentPlayingIndex = index
        playerView?.currentPlayingTime = 0
        playerView?.videoPlayer.pause()
        playerView?.videoPlayer.seek(to: CMTimeMake(value: 0, timescale: 1))
        playerView?.scrollCollection.changeSong(index: index)
        playerView?.play()
        print("ind Tester")
        
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
    
}
