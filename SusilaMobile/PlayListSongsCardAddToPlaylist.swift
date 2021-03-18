//
//  PlayListSongsCardAddToPlaylist.swift
//  SusilaMobile
//
//  Created by Kiroshan on 3/10/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class PlayListSongsCardAddToPlaylist: UIView {
    
    var libraryDataModel = LibraryDataModel()
    var id = 0
    var imgVw:UIImageView!
    var lblTitle:UILabel!
    var lblArtist:UILabel!
    var btnPlay:UIButton!
    var add = UIButton(frame: CGRect.zero)
    
    var imageURL = "" {
        willSet{
            
        }
        didSet{
            if (imageURL != ""){
                //imgVw.downloadImage(from: URL(string: imageURL)!)
            }
        }
    }
    
    var songData = Song(id: 0, name: "", duration: 0, date: "", description: "", image: "", blocked: false, url: "", artist: ""){
        didSet{
            imageURL = songData.image!
            lblTitle.text = songData.name
            lblArtist.text = songData.description
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
        var x = CGFloat(15)
        
        imgVw = UIImageView(frame: CGRect(x: x, y: CGFloat(15), width: self.frame.height - 30, height: self.frame.height - 30))
        imgVw.layer.cornerRadius = 5
        imgVw.clipsToBounds = true
        x = x + self.frame.height - 30 + 10
        
        lblTitle = UILabel(frame: CGRect(x: x, y: self.frame.height/2 - 25, width: self.frame.width - x - 100, height: 25))
        lblTitle.textColor = UIColor.white
        lblTitle.font = UIFont.boldSystemFont(ofSize: 16)
        lblArtist = UILabel(frame: CGRect(x: x, y: self.frame.height/2, width: self.frame.width - x - 100, height: 25))
        lblArtist.textColor = UIColor.gray
        lblArtist.font = UIFont.systemFont(ofSize: 13)
        
        x = self.frame.width - 60
        btnPlay = UIButton(frame: CGRect(x: x, y: self.frame.height/2 - 35/2, width: 35, height: 35))
        btnPlay.setBackgroundImage(UIImage(named: "play_green"), for: UIControl.State.normal)
        btnPlay.layer.cornerRadius = 17.5
        btnPlay.clipsToBounds = true
        btnPlay.layer.borderWidth = 1
        btnPlay.layer.borderColor = UIColor.gray.cgColor
        
        add = UIButton(frame: CGRect(x:  UIScreen.main.bounds.width-120, y: self.frame.height/2-10, width: 110, height: 20))
        add.layer.cornerRadius = 10
        add.layer.borderWidth = 1
        add.setTitle("AddtoPlaylistPlus".localizedString, for: .normal)
        add.layer.borderColor = Constants.color_brand.cgColor
        add.setTitleColor(Constants.color_brand, for: .normal)
        add.clipsToBounds = true
        add.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 9.0)
        add.addTarget(self, action: #selector(buttonClick_AddPlaylist), for: .touchUpInside)
        
        x = self.frame.width - 50
        
        self.addSubview(imgVw)
        self.addSubview(lblTitle)
        self.addSubview(lblArtist)
        self.addSubview(add)
    }
    
    @objc func buttonClick_AddPlaylist(sender:PlaylistTapGesture) {
        addToTempPlaylistSongs(session_id: mainInstance.playlistSessionToken, ref_id: id, type: "S")
        if self.add.titleLabel?.text == "AddtoPlaylistPlus".localizedString {
            self.add.backgroundColor = Constants.color_brand
            self.add.setTitleColor( .white, for: .normal)
            self.add.setTitle("AddedToPlayList".localizedString, for: .normal)
        } else {
            self.add.setTitle("AddtoPlaylistPlus".localizedString, for: .normal)
            self.add.backgroundColor = .clear
            self.add.setTitleColor( Constants.color_brand, for: .normal)
        }
    }

    func addToTempPlaylistSongs(session_id: String, ref_id: Int, type: String) {
        self.libraryDataModel.addToTempPlaylistSongs(session_id: session_id, ref_id: ref_id, type: type, addToTempPlaylistSongsCallFinished: { (status_r, error, userInfo) in
            if status_r {
                DispatchQueue.main.async(execute: {
                    
                })
            }
        })
    }
}
