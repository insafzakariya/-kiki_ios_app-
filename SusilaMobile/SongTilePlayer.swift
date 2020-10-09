//
//  SongTilePlayer.swift
//  SusilaMobile
//
//  Created by Kiroshan on 3/2/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class SongTilePlayer: UIView {
    var imageContainer = UIView(frame: CGRect.zero)
    var image = UIImageView(frame: CGRect.zero)
    var lblTitle = UILabel(frame: CGRect.zero)
    var lblDescription = UILabel(frame: CGRect.zero)
    //let selectedColor = UIColor(red: 198/255, green: 241/255, blue: 253/255, alpha: 1.0)
    let selectedColor = Constants.videoAppBackColor
    var styleType = 0 {
        didSet{
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
        willSet {}
        didSet {
            //image.downloadImageSongTilePlayer(from: URL(string: imageURL)!)
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
    private func commonInit(){
        
        imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-60, height: UIScreen.main.bounds.width-50))
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-80, height: UIScreen.main.bounds.width-80))
        
        let img : UIImage = UIImage(named:"logo_grayscale")!
        image = UIImageView(image: img)
        image.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.width-100, height: UIScreen.main.bounds.width-100)
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        
        lblTitle = UILabel(frame: CGRect(x: 30, y: image.frame.height+10, width: image.frame.width-20 , height: 20))
        lblDescription = UILabel(frame: CGRect(x: 30, y: image.frame.height+lblTitle.frame.height+5, width: image.frame.width-20, height: 20))
        
        //lblTitle.isHidden = true
        lblTitle.font = UIFont.boldSystemFont(ofSize: 12)
        lblTitle.textColor = UIColor.white
        lblTitle.textAlignment = .center
        //lblDescription.isHidden = true
        lblDescription.textAlignment = .center
        lblDescription.font = UIFont.systemFont(ofSize: 11)
        lblDescription.textColor = UIColor.white
        
        self.imageContainer.addSubview(image)
        self.imageContainer.addSubview(lblTitle)
        self.imageContainer.addSubview(lblDescription)
        self.addSubview(imageContainer)
        //self.addSubview(lblDescription)
    }
}

extension UIImageView {
    func getDataSongTilePlayer(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImageSongTilePlayer(from url: URL) {
        getDataSongTilePlayer(from: url) { data, response, error in
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
