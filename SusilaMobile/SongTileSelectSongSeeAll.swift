//
//  SongTileSelectSongSeeAll.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/11/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

class SongTileSelectSongSeeAll: UIView {
    var libraryDataModel = LibraryDataModel()
    var id = 0
    var imageContainer = UIView(frame: CGRect.zero)
    var image = UIImageView(frame: CGRect.zero)
    var lblTitle = UILabel(frame: CGRect.zero)
    var lblDescription = UILabel(frame: CGRect.zero)
    var time = UILabel(frame: CGRect.zero)
    var add = UIButton(frame: CGRect.zero)
    var line = UIView(frame: CGRect.zero)
    
    var imageURL = "" {
        willSet{
            
        }
        didSet{
            //image.downloadImageSongTileSelectSongSeeAll(from: URL(string: imageURL)!)
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
        lblTitle = UILabel(frame: CGRect(x: image.frame.width+10, y: 0, width: self.frame.width-( UIScreen.main.bounds.width/6+100) , height: 20))
        lblDescription = UILabel(frame: CGRect(x: image.frame.width+10, y: lblTitle.frame.height, width: self.frame.width-( UIScreen.main.bounds.width/6+100), height: 20))
        
        time = UILabel(frame: CGRect(x: image.frame.width+10, y: lblTitle.frame.height+30, width: self.frame.width-100, height: 20))
        time.textColor = .gray
        time.font = UIFont.systemFont(ofSize: 13)
        
        add = UIButton(frame: CGRect(x:  UIScreen.main.bounds.width-110, y: image.frame.height/2-10, width: 90, height: 20))
        add.layer.cornerRadius = 10
        add.layer.borderWidth = 1
        add.setTitle(NSLocalizedString("Add".localized(using: "Localizable"), comment: ""), for: .normal)
        add.layer.borderColor = Constants.color_brand.cgColor
        add.setTitleColor(Constants.color_brand, for: .normal)
        add.clipsToBounds = true
        add.setTitleColor(Constants.color_brand, for: .normal)
        add.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 9.0)
        add.addTarget(self, action: #selector(buttonClick_AddPlaylist), for: .touchUpInside)
        
        line = UIView(frame: CGRect(x: 0, y: image.frame.height+10, width: UIScreen.main.bounds.width-20 , height: 0.5))
        line.backgroundColor = UIColor.gray
        
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
        self.addSubview(time)
        self.addSubview(add)
        self.addSubview(line)
    }
    
    @objc func buttonClick_AddPlaylist(sender:PlaylistTapGesture) {
        addToTempPlaylistSongs(session_id: mainInstance.playlistSessionToken, ref_id: id, type: "S")
    }
    
    func addToTempPlaylistSongs(session_id: String, ref_id: Int, type: String) {
        self.libraryDataModel.addToTempPlaylistSongs(session_id: session_id, ref_id: ref_id, type: type, addToTempPlaylistSongsCallFinished: { (status_r, error, userInfo) in
            if status_r {
                DispatchQueue.main.async(execute: {
                    if self.add.titleLabel?.text == NSLocalizedString("Add".localized(using: "Localizable"), comment: "") {
                        mainInstance.songArray.append(ref_id)
                        self.add.setTitle("Added", for: .normal)
                        self.add.backgroundColor = Constants.color_brand
                        self.add.layer.borderColor = Constants.color_brand.cgColor
                        self.add.setTitleColor(.white, for: .normal)
                    } else {
                        if let idx = mainInstance.songArray.firstIndex(of:ref_id) {
                            mainInstance.songArray.remove(at: idx)
                        }
                        self.add.setTitle(NSLocalizedString("Add".localized(using: "Localizable"), comment: ""), for: .normal)
                        self.add.backgroundColor = .clear
                        self.add.layer.borderColor = Constants.color_brand.cgColor
                        self.add.setTitleColor(Constants.color_brand, for: .normal)
                    }
                })
            }
        })
    }
}

extension UIImageView{
    func getDataSongTileSelectSongSeeAll(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImageSongTileSelectSongSeeAll(from url: URL) {
        getDataSongTileSelectSongSeeAll(from: url) { data, response, error in
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
