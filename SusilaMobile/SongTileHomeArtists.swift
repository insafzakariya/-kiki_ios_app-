//
//  SongTileHomeArtists.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/24/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class SongTileHomeArtists: UIView {
    var imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var image = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-40)*1/3, height: (UIScreen.main.bounds.width-40)*1/3))
    var lblTitle = UILabel(frame: CGRect(x: 0, y: 180, width: 200, height: 20))
    var lblDescription = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 20))
    //let selectedColor = UIColor(red: 198/255, green: 241/255, blue: 253/255, alpha: 1.0)
    //let selectedColor = Constants.videoAppBackColor
   
    var index = 0{
        didSet{
            image.tag = index
        }
    }
    var imageURL = "" {
        willSet{
            
        }
        didSet{
            //image.downloadImageSongTileHomeArtists(from: URL(string: imageURL)!)
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
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-40)*1/3-10, height: (UIScreen.main.bounds.width-40)*1/3-10))
        lblTitle = UILabel(frame: CGRect(x: 0, y: image.frame.height, width: self.frame.width-20 , height: 20))
        lblDescription = UILabel(frame: CGRect(x: 0, y: image.frame.height+lblTitle.frame.height, width: self.frame.width-20, height: 20))
        
        let img : UIImage = UIImage(named:"logo_grayscale")!
        image = UIImageView(image: img)
        image.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-40)*1/3-10, height: (UIScreen.main.bounds.width-40)*1/3-10)
        image.layer.cornerRadius = image.frame.width/2
        image.clipsToBounds = true
        
        
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
        self.addSubview(imageContainer)
        //self.addSubview(lblDescription)
    }
}

extension UIImageView{
    func getDataSongTileHomeArtists(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImageSongTileHomeArtists(from url: URL) {
        getDataSongTileHomeArtists(from: url) { data, response, error in
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
