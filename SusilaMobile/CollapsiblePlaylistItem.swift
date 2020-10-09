//
//  CollapsibleTableViewHeader.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsiblePlaylistItem, section: Int)
}

class CollapsiblePlaylistItem: UITableViewHeaderFooterView {
    var playerView:PlayerView!
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    var songs:[Song]!
    let imgVw = UIImageView(frame: CGRect(x: 10, y: 20, width: 60, height: 60))
    let btnPly = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 90, y: 30, width: 40, height: 40))
    
    
    let titleLabel = UILabel(frame: CGRect(x: 80, y: 39, width: UIScreen.main.bounds.width - 180, height: 22))
    let arrowImage = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width - 40, y: 35, width: 30, height: 30))
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Constants.color_background

        contentView.addSubview(arrowImage)
        arrowImage.image = UIImage(named: "down")
        
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.white
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsiblePlaylistItem.tapHeader(_:))))
        
        contentView.addSubview(imgVw)
        imgVw.layer.cornerRadius = 8
        imgVw.clipsToBounds = true
        imgVw.image = UIImage(named: "AppIcon")
        
        contentView.addSubview(btnPly)
        btnPly.setBackgroundImage(UIImage(named: "play_green"), for: UIControl.State.normal)
        btnPly.addTarget(self, action: #selector(self.actPlayAll(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @IBAction func actPlayAll(_ sender: UIButton) {
        if (self.songs.count < 1) {
            return
        }
        playerView.pause()
        playerView.videoPlayer.seek(to: CMTimeMake(value: 0, timescale: 1))
        playerView.currentPlayingList = self.songs
        playerView.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // Trigger toggle section when tapping on the header
    //
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsiblePlaylistItem else {
            return
        }
        
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        arrowImage.image = UIImage(named: collapsed ? "down":"up")
    }
    
}
