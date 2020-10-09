//
//  PlayerExpandedView.swift
//  SusilaMobile
//
//  Created by MacBookSH on 1/11/19.
//  Copyright © 2019 Isuru Jayathissa. All rights reserved.
//

import UIKit
import AVKit
import Foundation
import AVFoundation

class PlayerExpandedView: UIView {
    
    @IBOutlet weak var constPlayerProgress: NSLayoutConstraint!
    public  var songURLString: String = "" {
        willSet(newSongUrl) {
            videoPlayer.seek(to: CMTimeMake(0,1))
            videoPlayer.pause()
            let fileURL = NSURL(string: newSongUrl)
            let avAsset = AVURLAsset(url: fileURL! as URL, options: nil)
            let playerItem = AVPlayerItem(asset: avAsset)
            videoPlayer = AVPlayer(playerItem: playerItem)
            
            //            isPlaying = false
            currentPlayingTime = 0
            totalDuration = 235//TODO-Change to max sent
        }
        didSet {
            
        }
    }
    var currentPlayingList:[Song] = [Song](){
        willSet(newSongList) {
            self.totalSongsCount = newSongList.count
        }
        didSet {
            self.currentPlayingIndex = 0
        }
    }
    var videoPlayer:AVPlayer!
    var isPlaying = false
    var currentPlayingTime = 0
    var totalDuration = 235//TODO-Change to max sent
    var currentPlayingIndex = 0{
        willSet(newIndex) {
            if (newIndex > 0){
                self.btnPrevious.isEnabled = true;
                self.btnPrevious.setBackgroundImage(UIImage(named: "previous"), for: UIControlState.normal)
            }
            else {
                self.btnPrevious.isEnabled = false;
                self.btnPrevious.setBackgroundImage(UIImage(named: "previous_gray"), for: UIControlState.normal)
            }
            if (newIndex < totalSongsCount-1){
                self.btnNext.isEnabled = true;
                self.btnNext.setBackgroundImage(UIImage(named: "next"), for: UIControlState.normal)
            }
            else {
                self.btnNext.isEnabled = false;
                self.btnNext.setBackgroundImage(UIImage(named: "next_gray"), for: UIControlState.normal)
            }
        }
        didSet {
            lblSongName.text = currentPlayingList[self.currentPlayingIndex].name
            lblSinger.text = currentPlayingList[self.currentPlayingIndex].description
            if let url = URL(string: currentPlayingList[self.currentPlayingIndex].image ?? "") {
                imgSongThumb.contentMode = .scaleAspectFit
                downloadImage(from: url)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imgSongThumb.image = UIImage(data: data)
            }
        }
    }
    var totalSongsCount = 0 {
        willSet(newTotal) {
            
        }
        didSet {
            
        }
    }
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgSongThumb: UIImageView!
    
    @IBOutlet weak var lblSongName: UILabel!
    
    @IBOutlet weak var lblSinger: UILabel!
    
    func play() {
        if (songURLString != ""){
            isPlaying = true
            videoPlayer.play()
            btnPlay.setBackgroundImage(UIImage(named: "pause_black"), for: UIControlState.normal)
        }
    }
    func pause(){
        if (songURLString != "" && isPlaying){
            isPlaying = false
            videoPlayer.pause()
            btnPlay.setBackgroundImage(UIImage(named: "play_black"), for: UIControlState.normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    @IBAction func actPlayPause(_ sender: UIButton) {
        if (self.isPlaying){
            self.pause()
        }
        else {
            self.play()
        }
    }
    
    @IBAction func actNext(_ sender: UIButton) {
        self.currentPlayingIndex = self.currentPlayingIndex+1
        if (self.isPlaying){
            self.play()
        }
    }
    
    @IBAction func actPrevious(_ sender: UIButton) {
        self.currentPlayingIndex = self.currentPlayingIndex-1
        if (self.isPlaying){
            self.play()
        }
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("PlayerExpandedView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let fileURL = NSURL(string: songURLString)
        let avAsset = AVURLAsset(url: fileURL! as URL, options: nil)
        
        let playerItem = AVPlayerItem(asset: avAsset)
        videoPlayer = AVPlayer(playerItem: playerItem)
        self.btnPrevious.isEnabled = false;
        
    }
    
}

