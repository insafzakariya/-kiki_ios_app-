//
//  PlayListTileAll.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/24/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class PlayListTileAll: UIView {
    var imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var image = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-40)*1/3, height: (UIScreen.main.bounds.width-40)*1/3))
    var lblTitle = UILabel(frame: CGRect(x: 0, y: 180, width: 200, height: 20))
    var lblDescription = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 20))
    var songs = UILabel(frame: CGRect.zero)
    var year = UILabel(frame: CGRect.zero)
    var add = UIButton(frame: CGRect.zero)
    var line = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5))
    
    var index = 0{
        didSet{
            image.tag = index
        }
    }
    var imageURL = "" {
        willSet{
            
        }
        didSet {
            if imageURL != "" {
                //image.downloadImagePlayListTileAll(from: URL(string: imageURL)!)
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
        
        imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width , height: self.frame.width ))
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.width/6))
        lblTitle = UILabel(frame: CGRect(x: image.frame.width+10, y: 0, width: self.frame.width-20 , height: 20))
        lblDescription = UILabel(frame: CGRect(x: image.frame.width+10, y: lblTitle.frame.height, width: self.frame.width-20, height: 20))
        
        songs = UILabel(frame: CGRect(x: image.frame.width+10, y: lblTitle.frame.height+lblDescription.frame.height+10, width: self.frame.width-20, height: 20))
        songs.text = ""
        songs.font = UIFont.systemFont(ofSize: 13)
        songs.textColor = UIColor.gray
        
        year = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2, y: lblTitle.frame.height+lblDescription.frame.height+10, width: self.frame.width-20, height: 20))
        year.text = "Genre"
        year.font = UIFont.systemFont(ofSize: 13)
        year.textColor = UIColor.gray
        
        add = UIButton(frame: CGRect(x:  UIScreen.main.bounds.width-80, y: image.frame.height/2-10, width: 60, height: 20))
        add.layer.cornerRadius = 10
        add.layer.borderWidth = 1
        add.setTitle(NSLocalizedString("Add".localized(using: "Localizable"), comment: ""), for: .normal)
        add.backgroundColor = Constants.color_brand
        add.layer.borderColor = Constants.color_brand.cgColor
        add.setTitleColor(.white, for: .normal)
        add.clipsToBounds = true
        add.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 9.0)
        
        line = UIView(frame: CGRect(x: 0, y: image.frame.height+10, width: UIScreen.main.bounds.width-20 , height: 0.5))
        line.backgroundColor = UIColor.gray
        
        let img : UIImage = UIImage(named:"logo_grayscale")!
        image = UIImageView(image: img)
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.width/6)
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        
        lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
        lblTitle.textColor = Constants.color_brand
        
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

extension UIImageView{
    func getDataPlayListTileAll(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImagePlayListTileAll(from url: URL) {
        getDataPlayListTileAll(from: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async() {
                    self.image = UIImage(named: "logo_grayscale")
                }
                return }
            DispatchQueue.main.async() {
                if let img = UIImage(data: data) {
                    self.image = img
                } else {
                    self.image = UIImage(named: "logo_grayscale")
                }
            }
        }
    }
}
