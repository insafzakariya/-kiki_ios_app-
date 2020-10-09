//
//  CollapsibleTableViewCell.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 7/17/17.
//  Copyright © 2017 Yong Su. All rights reserved.
//

import UIKit

class CollapsibleTableViewCell: UITableViewCell {
    var playerView:PlayerView!
    var song:Song!{
        didSet {
            self.nameLabel.text = song.name
            self.detailLabel.text = song.description
            self.imgVw.downloadImage(from: URL(string: song.image!)!)
        }
    }
    var index: Int!
    var playList: [Song]!
    let nameLabel = UILabel(frame: CGRect(x: 110, y: 20, width: UIScreen.main.bounds.width - 180, height: 22))
    let detailLabel = UILabel(frame: CGRect(x: 110, y: 42, width: UIScreen.main.bounds.width - 180, height: 40))
    let imgVw = UIImageView(frame: CGRect(x: 40, y: 20, width: 60, height: 60))
    
    let btnPly = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 70, y: 30, width: 40, height: 40))
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imgVw)
        imgVw.layer.cornerRadius = 8
        imgVw.clipsToBounds = true
        
        contentView.addSubview(btnPly)
        btnPly.setBackgroundImage(UIImage(named: "play_green"), for: UIControl.State.normal)
        btnPly.addTarget(self, action: #selector(self.actPlaySong(_:)), for: UIControl.Event.touchUpInside)
        
        contentView.addSubview(nameLabel)
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.textColor = UIColor.white

        contentView.addSubview(detailLabel)
        detailLabel.lineBreakMode = .byWordWrapping
        detailLabel.numberOfLines = 2
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.textColor = UIColor.lightGray
        detailLabel.backgroundColor = UIColor.clear
        contentView.backgroundColor = Constants.color_background
    }
    
    @IBAction func actPlaySong(_ sender: UIButton) {
        playerView.pause()
        playerView.videoPlayer.seek(to: CMTimeMake(value: 0, timescale: 1))
        playerView.currentPlayingList = self.playList
        playerView.currentPlayingIndex = self.index
        playerView.currentPlayingTime = 0
        playerView.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
