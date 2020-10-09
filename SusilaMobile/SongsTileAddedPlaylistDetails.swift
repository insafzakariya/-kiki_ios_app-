//
//  SongsTileAddedPlaylistDetails.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/17/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

class SongsTileAddedPlaylistDetails: UIView {
    var libraryDataModel = LibraryDataModel()
    var id = 0
    var imageContainer = UIView(frame: CGRect.zero)
    var image = UIImageView(frame: CGRect.zero)
    var lblTitle = UILabel(frame: CGRect.zero)
    var lblDescription = UILabel(frame: CGRect.zero)
    var add = UIButton(frame: CGRect.zero)
    var line = UIView(frame: CGRect.zero)
    
    var imageURL = "" {
        willSet{
            
        }
        didSet{
            //image.downloadImageBrowse(from: URL(string: imageURL)!)
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
        
        add = UIButton(frame: CGRect(x:  UIScreen.main.bounds.width-60, y: image.frame.height/2-15, width: 30, height: 30))
        add.setBackgroundImage(UIImage(named: "delete_faded"), for: .normal)
        //add.addTarget(self, action: #selector(buttonClick_AddPlaylist), for: .touchUpInside)
        
        lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
        lblTitle.textColor = Constants.color_brand
        lblDescription.font = UIFont.systemFont(ofSize: 13)
        lblDescription.textColor = UIColor.white
        
        line = UIView(frame: CGRect(x: 0, y: image.frame.height+10, width: UIScreen.main.bounds.width-20 , height: 0.5))
        line.backgroundColor = UIColor.gray
        
        let img : UIImage = UIImage(named:"logo_grayscale")!
        image = UIImageView(image: img)
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.width/6)
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        
        self.imageContainer.addSubview(image)
        self.imageContainer.addSubview(lblTitle)
        self.addSubview(imageContainer)
        self.addSubview(lblDescription)
        self.addSubview(add)
        self.addSubview(line)
    }
    
    /*@objc func buttonClick_AddPlaylist(sender:PlaylistTapGesture) {
        addToTempPlaylistSongs(id: id, session_id: mainInstance.playlistSessionToken)
    }
    
    func addToTempPlaylistSongs(id: Int, session_id: String) {
        self.libraryDataModel.addToTempPlaylistSongs(id: id, session_id: session_id, addToTempPlaylistSongsCallFinished: { (status_r, error, userInfo) in
            if status_r {
                DispatchQueue.main.async(execute: {
                    if self.add.titleLabel?.text == "+ Add to list" {
                        self.add.setTitle("Remove", for: .normal)
                        self.add.layer.borderColor = Constants.color_red.cgColor
                        self.add.setTitleColor(Constants.color_red, for: .normal)
                    } else {
                        self.add.setTitle("+ Add to list", for: .normal)
                        self.add.layer.borderColor = Constants.color_brand.cgColor
                        self.add.setTitleColor(Constants.color_brand, for: .normal)
                    }
                })
            }
        })
    }*/
}
