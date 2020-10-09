//
//  PlaylistTileSearch.swift
//  SusilaMobile
//
//  Created by Kiroshan on 6/2/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class PlaylistTileSearch: UIView {
    
    var imageContainer = UIView(frame: CGRect.zero)
    var image = UIImageView(frame: CGRect.zero)
    var lblTitle = UILabel(frame: CGRect.zero)
    var lblDescription = UILabel(frame: CGRect.zero)
    var songs = UILabel(frame: CGRect.zero)
    var year = UILabel(frame: CGRect.zero)
    //let selectedColor = UIColor(red: 198/255, green: 241/255, blue: 253/255, alpha: 1.0)
    var add = UIButton(frame: CGRect.zero)
    var line = UIView(frame: CGRect.zero)
    let selectedColor = Constants.color_background
    var styleType = 0 {
        didSet {
            //lblTitle.isHidden = styleType == 0 ? true:false
            //lblDescription.isHidden = styleType == 0 ? true:false
        }
        
    }
    var index = 0{
        didSet{
            image.tag = index
        }
    }
    var imageURL = "" {
        willSet{
            
        }
        didSet{
            if imageURL != "" {
                //image.downloadImagePlayListSongsTileAll(from: URL(string: imageURL)!)
            }
            
            
        }
    }
    
    var isSelected = false{
        willSet{
            self.backgroundColor = UIColor.clear
            
            
        }
        didSet{
            if (styleType == 0){
                self.imageContainer.backgroundColor = isSelected ? selectedColor : UIColor.clear
                //self.lblDescription.isHidden = !isSelected
                //self.lblTitle.isHidden = !isSelected
            }
        }
    }
    
    
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
        
        imageContainer = UIView(frame: CGRect(x: 10, y: 0, width: self.frame.width , height: self.frame.width ))
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.width/6))
        lblTitle = UILabel(frame: CGRect(x: image.frame.width+10, y: 0, width: self.frame.width-20 , height: 20))
        lblDescription = UILabel(frame: CGRect(x: image.frame.width+10, y: lblTitle.frame.height, width: self.frame.width-20, height: 20))
        
        songs = UILabel(frame: CGRect(x: image.frame.width+20, y: lblTitle.frame.height+lblDescription.frame.height+10, width: self.frame.width-20, height: 20))
        songs.text = "0 songs"
        songs.font = UIFont.systemFont(ofSize: 13)
        songs.textColor = UIColor.gray
        
        year = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2+10, y: lblTitle.frame.height+lblDescription.frame.height+10, width: self.frame.width-20, height: 20))
        year.text = "2020"
        year.font = UIFont.systemFont(ofSize: 13)
        year.textColor = UIColor.gray
        
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
        //line.backgroundColor = UIColor.gray
        
        let img : UIImage = UIImage(named:"logo_grayscale")!
        image = UIImageView(image: img)
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.width/6)
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        
        //lblTitle.isHidden = true
        lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
        lblTitle.textColor = Constants.color_brand
        //lblDescription.isHidden = true
        lblDescription.font = UIFont.systemFont(ofSize: 13)
        lblDescription.textColor = UIColor.white
        
        self.imageContainer.addSubview(image)
        self.imageContainer.addSubview(lblTitle)
        self.addSubview(imageContainer)
        self.addSubview(lblDescription)
        self.addSubview(songs)
        self.addSubview(year)
        self.addSubview(add)
        self.addSubview(line)
    }
}
