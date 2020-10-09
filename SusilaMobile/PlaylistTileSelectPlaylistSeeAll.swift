//
//  PlaylistTileSelectPlaylistSeeAll.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/11/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//
class PlaylistTileSelectPlaylistSeeAll: UIView {
    var imageContainer = UIView(frame: CGRect.zero)
    var image = UIImageView(frame: CGRect.zero)
    var lblTitle = UILabel(frame: CGRect.zero)
    var lblDescription = UILabel(frame: CGRect.zero)
    var songs = UILabel(frame: CGRect.zero)
    var year = UILabel(frame: CGRect.zero)
    var add = UIButton(frame: CGRect.zero)
    var line = UIView(frame: CGRect.zero)
    let selectedColor = Constants.color_background
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
            //image.downloadImagePlaylistTileSelectPlaylistSeeAll(from: URL(string: imageURL)!)
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
        
        imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width , height: self.frame.width ))
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.width/6))
        lblTitle = UILabel(frame: CGRect(x: image.frame.width+10, y: 10, width: self.frame.width-20 , height: 20))
        lblDescription = UILabel(frame: CGRect(x: image.frame.width+10, y: lblTitle.frame.height, width: self.frame.width-20, height: 20))
        
        songs = UILabel(frame: CGRect(x: image.frame.width+10, y: lblTitle.frame.height+lblDescription.frame.height, width: self.frame.width-20, height: 20))
        songs.text = "4 songs"
        songs.font = UIFont.systemFont(ofSize: 13)
        songs.textColor = UIColor.gray
        
        year = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2, y: lblTitle.frame.height+lblDescription.frame.height, width: self.frame.width-20, height: 20))
        year.text = "2014"
        year.font = UIFont.systemFont(ofSize: 13)
        year.textColor = UIColor.gray
        
        add = UIButton(frame: CGRect(x:  UIScreen.main.bounds.width-80, y: image.frame.height/2-10, width: 55, height: 20))
        add.setTitle(NSLocalizedString("Add".localized(using: "Localizable"), comment: ""), for: .normal)
        add.backgroundColor = Constants.color_brand
        add.layer.cornerRadius = 10
        add.clipsToBounds = true
        add.setTitleColor(.white, for: .normal)
        add.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 9.0)
        add.addTarget(self, action: #selector(buttonClick_AddPlaylist), for: .touchUpInside)
        
        
        line = UIView(frame: CGRect(x: 0, y: image.frame.height+10, width: UIScreen.main.bounds.width-20 , height: 0.5))
        line.backgroundColor = UIColor.gray
        
        //let img : UIImage = UIImage(named:"logo_grayscale")!
        //image = UIImageView(image: img)
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
        //self.addSubview(add)
        self.addSubview(line)
    }
    
    @objc func buttonClick_AddPlaylist(sender:UIButton) {
        if sender.titleLabel?.text == NSLocalizedString("Add".localized(using: "Localizable"), comment: "") {
            add.setTitle("Added", for: .normal)
        } else {
            add.setTitle(NSLocalizedString("Add".localized(using: "Localizable"), comment: ""), for: .normal)
        }
    }
}

extension UIImageView{
    func getDataPlaylistTileSelectPlaylistSeeAll(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImagePlaylistTileSelectPlaylistSeeAll(from url: URL) {
        getDataPlaylistTileSelectPlaylistSeeAll(from: url) { data, response, error in
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
