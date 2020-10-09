//
//  SMCustomSwitchAV.swift
//  SusilaMobile
//
//  Created by MacBookSH on 12/4/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import UIKit
import AudioToolbox
class SMCustomSwitchAV: UIView {
    var isOn = true;
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var btnToggle: UIButton!
    
    @IBOutlet weak var constHeadHeight: NSLayoutConstraint!
    @IBOutlet weak var constHeadWidth: NSLayoutConstraint!
    @IBOutlet weak var constHeadLeading: NSLayoutConstraint!
    @IBOutlet weak var constImgInsideLeading: NSLayoutConstraint!
    @IBOutlet weak var imgInside: UIImageView!
    @IBOutlet weak var imgBack: UIView!
    @IBOutlet weak var imgHead: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("SMCustomSwitchAV", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
