//
//  AddToPlaylistDialog.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/20/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class AddToPlaylistAlertDialog: UIView {
    var id = 0
    var lblTitle:UILabel!
    var scrollList:UIScrollView!
    var btnCancel:UIButton!
    
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
        
        lblTitle = UILabel(frame: CGRect(x: 15, y: 15, width: self.frame.width - 50, height: 20))
        lblTitle.text = "Select Playlist"
        lblTitle.textAlignment = NSTextAlignment.left
        lblTitle.font = UIFont.boldSystemFont(ofSize: 18)
        lblTitle.textColor = .white
        
        btnCancel = UIButton(frame: CGRect(x: self.frame.width-35, y: 10, width: 25, height: 25))
        btnCancel.setBackgroundImage(UIImage(named: "Subscription Promote Close Button"), for: .normal)
        btnCancel.setTitleColor(.white, for: .normal)
        btnCancel.titleLabel?.baselineAdjustment = .alignCenters
        btnCancel.layer.cornerRadius = 25/2
        btnCancel.clipsToBounds = true
        
        let line = UIView(frame: CGRect(x: 10, y: lblTitle.frame.height+30, width: self.frame.width-20 , height: 0.5))
        line.backgroundColor = UIColor.gray
        scrollList = UIScrollView(frame: CGRect(x: 0, y: lblTitle.frame.height+40, width: self.frame.width, height: 230))
  
        self.addSubview(lblTitle)
        self.addSubview(btnCancel)
        self.addSubview(line)
        self.addSubview(scrollList)
        
        self.backgroundColor = Constants.color_background
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}
