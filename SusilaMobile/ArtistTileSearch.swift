//
//  ArtistTileSearch.swift
//  SusilaMobile
//
//  Created by Kiroshan on 6/1/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation
class ArtistTileSearch: UIView {
    var imageContainer = UIView(frame: CGRect.zero)
    var image = UIImageView(frame: CGRect.zero)
    var lblTitle = UILabel(frame: CGRect.zero)
    var lblDescription = UILabel(frame: CGRect.zero)
    var albums = UILabel(frame: CGRect.zero)
    var songs = UILabel(frame: CGRect.zero)
    var add = UIButton(frame: CGRect.zero)
    var line = UIView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
        
        imageContainer = UIView(frame: CGRect(x: 10, y: 0, width: self.frame.width , height: self.frame.width ))
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.width/6))
        lblTitle = UILabel(frame: CGRect(x: image.frame.width+10, y: 10, width: self.frame.width-150 , height: 20))
        lblDescription = UILabel(frame: CGRect(x: image.frame.width+10, y: lblTitle.frame.height, width: self.frame.width-20, height: 20))
        
        albums = UILabel(frame: CGRect(x: image.frame.width+20, y: lblTitle.frame.height+lblDescription.frame.height, width: self.frame.width-20, height: 20))
        albums.text = ""
        albums.font = UIFont.systemFont(ofSize: 13)
        albums.textColor = UIColor.gray
        
        songs = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2, y: lblTitle.frame.height+lblDescription.frame.height, width: self.frame.width-20, height: 20))
        songs.text = ""
        songs.font = UIFont.systemFont(ofSize: 13)
        songs.textColor = UIColor.gray
        
        add = UIButton(frame: CGRect(x:  UIScreen.main.bounds.width-70, y: image.frame.height/2-10, width: 60, height: 20))
        add.layer.cornerRadius = 10
        add.layer.borderWidth = 1
        add.setTitle(NSLocalizedString("Add".localized(using: "Localizable"), comment: ""), for: .normal)
        add.backgroundColor = Constants.color_brand
        add.layer.borderColor = Constants.color_brand.cgColor
        add.setTitleColor(.white, for: .normal)
        add.clipsToBounds = true
        add.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 9.0)
        
        line = UIView(frame: CGRect(x: 10, y: image.frame.height+10, width: UIScreen.main.bounds.width-20 , height: 0.5))
        
        
        let img : UIImage = UIImage(named:"logo_grayscale")!
        image = UIImageView(image: img)
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.width/6)
        image.layer.cornerRadius = (UIScreen.main.bounds.width/6)/2
        image.clipsToBounds = true
        
        lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
        lblTitle.textColor = Constants.color_brand
        lblDescription.font = UIFont.systemFont(ofSize: 13)
        lblDescription.textColor = UIColor.white
        
        self.imageContainer.addSubview(image)
        self.imageContainer.addSubview(lblTitle)
        self.addSubview(imageContainer)
        self.addSubview(lblDescription)
        self.addSubview(albums)
        self.addSubview(songs)
        self.addSubview(add)
        self.addSubview(line)
    }
}
