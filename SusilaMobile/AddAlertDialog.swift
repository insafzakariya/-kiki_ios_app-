//
//  AddAlertDialog.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/20/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class AddAlertDialog: UIView {
    var id = 0
    var lblTitle:UILabel!
    var lblAddToLibrary:UILabel!
    var lblAddToPlaylist:UILabel!
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
        lblTitle.text = "Add Song to Playlist or Library"
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
        
        lblAddToLibrary = UILabel(frame: CGRect(x: 15, y: lblTitle.frame.height+45, width: self.frame.width - 30, height: 20))
        lblAddToLibrary.text = NSLocalizedString("Addtolibrary".localized(using: "Localizable"), comment: "")
        lblAddToLibrary.textAlignment = NSTextAlignment.center
        lblAddToLibrary.font = UIFont.systemFont(ofSize: 17)
        lblAddToLibrary.textColor = Constants.color_brand
        
        let line2 = UIView(frame: CGRect(x: 10, y: lblTitle.frame.height+lblAddToLibrary.frame.height+60, width: self.frame.width-20 , height: 0.5))
        line2.backgroundColor = UIColor.gray
        
        lblAddToPlaylist = UILabel(frame: CGRect(x: 15, y: lblTitle.frame.height+lblAddToLibrary.frame.height+75, width: self.frame.width - 30, height: 20))
        lblAddToPlaylist.text = NSLocalizedString("AddtoPlaylist".localized(using: "Localizable"), comment: "")+" >"
        lblAddToPlaylist.textAlignment = NSTextAlignment.center
        lblAddToPlaylist.font = UIFont.systemFont(ofSize: 17)
        lblAddToPlaylist.textColor = Constants.color_brand
  
        self.addSubview(lblTitle)
        self.addSubview(btnCancel)
        self.addSubview(lblAddToLibrary)
        self.addSubview(lblAddToPlaylist)
        self.addSubview(line)
        self.addSubview(line2)
        
        self.backgroundColor = Constants.color_background
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}
