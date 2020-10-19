//
//  SongTileHomeSquareSongs.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/20/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class SongTileHomeSquareSongs: UIView {
    var imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var image = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-40)*1/3, height: (UIScreen.main.bounds.width-40)*1/3))
    var lblTitle = UILabel(frame: CGRect(x: 0, y: 180, width: 200, height: 20))
    var lblDescription = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 20))
    //let selectedColor = UIColor(red: 198/255, green: 241/255, blue: 253/255, alpha: 1.0)
    let selectedColor = Constants.videoAppBackColor
    var styleType = 0{
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
        willSet{
            
        }
        didSet{
            /*Alamofire.request(imageURL).responseImage { response in
                debugPrint(response)
                //print(response.request)
                //print(response.response)
                debugPrint(response.result)

                if case .success(let img) = response.result {
                    print("image downloaded: \(img)")
                    //let image = UIImage(data: img.images)
                   
                }
            }*/
            //loadImage(fromURL: imageURL, toImageView: image)
            //image.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "logo_grayscale"))
            //image.downloadImageSongTileHomeSquareSongs(from: URL(string: imageURL)!)
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
        //self.commonInit()
    }
    private func commonInit(){
        
        
        imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width , height: self.frame.width ))
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-40)*1/3-10, height: (UIScreen.main.bounds.width-40)*1/3-10))
        lblTitle = UILabel(frame: CGRect(x: 0, y: image.frame.height, width: self.frame.width-20 , height: 20))
        lblDescription = UILabel(frame: CGRect(x: 0, y: image.frame.height+lblTitle.frame.height, width: self.frame.width-20, height: 20))
        
        let img : UIImage = UIImage(named:"logo_grayscale")!
        image = UIImageView(image: img)
        image.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-40)*1/3-10, height: (UIScreen.main.bounds.width-40)*1/3-10)
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        
        lblTitle.font = UIFont.boldSystemFont(ofSize: 12)
        lblTitle.textColor = UIColor.white
        lblTitle.textAlignment = .center

        lblDescription.textAlignment = .center
        lblDescription.font = UIFont.systemFont(ofSize: 11)
        lblDescription.textColor = UIColor.white
        
        self.imageContainer.addSubview(image)
        self.imageContainer.addSubview(lblTitle)
        self.addSubview(imageContainer)
        self.addSubview(lblDescription)
    }
}

extension UIImageView {
    
    func getDataSongTileHomeSquareSongs(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImageSongTileHomeSquareSongs(from url: URL) {
        var delay: Double = 0
        getDataSongTileHomeSquareSongs(from: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async() {
                    self.image = UIImage(named: "logo_grayscale")
                }
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                // Put your code which should be executed with a delay here
                if let img = UIImage(data: data) {
                    self.image = img
                } else {
                    self.image = UIImage(named: "logo_grayscale")
                }
            })
            delay += 0.8
            /*DispatchQueue.main.async() {
                if let img = UIImage(data: data) {
                    self.image = img
                } else {
                    self.image = UIImage(named: "logo_grayscale")
                }
            }*/
        }
    }
    
    
}

/*extension UIImageView {
    func downloadImageSongTileHomeSquareSongs(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("logo_grayscale"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloadImageSongTileHomeSquareSongs(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloadImageSongTileHomeSquareSongs(from: url, contentMode: mode)
    }
}*/
