//
//  ConfirmAlertDialog.swift
//  SusilaMobile
//
//  Created by Kiroshan on 4/13/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class ConfirmAlertDialog: UIView {
    var id = 0
    var key = ""
    var lblTitle:UILabel!
    var btnYes:UIButton!
    var btnNo:UIButton!

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
        
        lblTitle = UILabel(frame: CGRect(x: 15, y: 10, width: self.frame.width - 30, height: 80))
        lblTitle.text = "DO_YOU_WANT_TO_REMOVE".localizedString
        lblTitle.textAlignment = NSTextAlignment.left
        lblTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblTitle.numberOfLines = 3
        lblTitle.font = UIFont.boldSystemFont(ofSize: 15)
        lblTitle.textColor = .white
        
        btnYes = UIButton(frame: CGRect(x: 15, y:  self.frame.height-40, width: self.frame.width/2-22.5, height: 25))
        btnYes.setTitle("Yes", for: .normal)
        btnYes.setTitleColor(.white, for: .normal)
        btnYes.backgroundColor = .red
        btnYes.titleLabel?.baselineAdjustment = .alignCenters
        btnYes.layer.cornerRadius = 12
        btnYes.clipsToBounds = true
        
        btnNo = UIButton(frame: CGRect(x: self.frame.width/2+7.5, y: self.frame.height-40, width: self.frame.width/2-22.5, height: 25))
        btnNo.setTitle("No", for: .normal)
        btnNo.setTitleColor(.white, for: .normal)
        btnNo.backgroundColor = Constants.color_brand
        btnNo.titleLabel?.baselineAdjustment = .alignCenters
        btnNo.layer.cornerRadius = 12
        btnNo.clipsToBounds = true
        
  
        self.addSubview(lblTitle)
        self.addSubview(btnYes)
        self.addSubview(btnNo)
        
        self.backgroundColor = Constants.color_background
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}
