//
//  SongTileSelectSong.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/13/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

class SongTileSelectSong: UIView {
    var libraryDataModel = LibraryDataModel()
    var id = 0
    var imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var image = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-40)*1/3, height: (UIScreen.main.bounds.width-40)*1/3))
    var lblTitle = UILabel(frame: CGRect(x: 0, y: 180, width: 200, height: 20))
    var lblDescription = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 20))
    var selectedFrame = UIView(frame: CGRect.zero)
    var unselectText = UILabel(frame: CGRect.zero)
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
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-40)*1/3-10, height: (UIScreen.main.bounds.width-40)*1/3-10))
        lblTitle = UILabel(frame: CGRect(x: 0, y: image.frame.height, width: self.frame.width-20 , height: 20))
        lblDescription = UILabel(frame: CGRect(x: 0, y: image.frame.height+lblTitle.frame.height, width: self.frame.width-20, height: 20))
        
        let img : UIImage = UIImage(named:"logo_grayscale")!
        image = UIImageView(image: img)
        image.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width-40)*1/3-10, height: (UIScreen.main.bounds.width-40)*1/3-10)
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        
        selectedFrame = UIView(frame: CGRect(x: 0, y: 0, width: image.frame.width , height: image.frame.width ))
        selectedFrame.layer.cornerRadius = 5
        selectedFrame.clipsToBounds = true
        
        unselectText = UILabel(frame: CGRect(x: 0, y: 0, width: selectedFrame.frame.width , height: selectedFrame.frame.width ))
        unselectText.textColor = .white
        unselectText.textAlignment = .center
        unselectText.font = UIFont(name: "Roboto", size: 11.0)
        unselectText.center = selectedFrame.center
        //unselectText.center.y = unselectText.center.y
        
        //lblTitle.isHidden = true
        lblTitle.font = UIFont.boldSystemFont(ofSize: 12)
        lblTitle.textColor = UIColor.white
        lblTitle.textAlignment = .center
        //lblDescription.isHidden = true
        lblDescription.textAlignment = .center
        lblDescription.font = UIFont.systemFont(ofSize: 11)
        lblDescription.textColor = UIColor.white
        
        let tap = PlaylistTapGesture(target: self, action: #selector(buttonClick_AddPlaylist))
        imageContainer.isUserInteractionEnabled = true
        imageContainer.addGestureRecognizer(tap)
        
        selectedFrame.addSubview(unselectText)
        
        self.imageContainer.addSubview(image)
        self.imageContainer.addSubview(selectedFrame)
        self.imageContainer.addSubview(lblTitle)
        self.addSubview(imageContainer)
        self.addSubview(lblDescription)
    }
    
    @objc func buttonClick_AddPlaylist(sender:PlaylistTapGesture) {
        
        addToTempPlaylistSongs(session_id: mainInstance.playlistSessionToken, ref_id: id, type: "S")
        print ("id ", id, " session_id "+mainInstance.playlistSessionToken)
        
        /*if status == true {
            selectedFrame.backgroundColor = Constants.color_selectedSong
            unselectText.text = "Unselect"
            status = false
        } else {
            selectedFrame.backgroundColor = .clear
            unselectText.text = ""
            status = true
        }*/
        /*if sender.titleLabel?.text == "+ Add to list" {
            add.setTitle("Added", for: .normal)
            playlistItem.isExists(id: id)
            print("Id ",id)
            print("Name ",name)
            print("Desc ",desc)
            print("Url ",url)
            playlistItem.add(id: id, name: name, desc: desc, url: url)
        } else {
            
            add.setTitle("- Remove", for: .normal)
            add.layer.borderColor = Constants.color_brand.cgColor
        }*/
    }
    
    func addToTempPlaylistSongs(session_id: String, ref_id: Int, type: String) {
        //ProgressView.shared.show(self, mainText: nil, detailText: nil)
        self.libraryDataModel.addToTempPlaylistSongs(session_id: session_id, ref_id: ref_id, type: type, addToTempPlaylistSongsCallFinished: { (status_r, error, userInfo) in
            if status_r {
                DispatchQueue.main.async(execute: {
                    if self.unselectText.text == "" {
                        self.selectedFrame.backgroundColor = Constants.color_selectedSong
                        self.unselectText.text = "Added"
                        mainInstance.songArray.append(ref_id)
                    } else {
                        self.selectedFrame.backgroundColor = .clear
                        self.unselectText.text = ""
                        if let idx = mainInstance.songArray.firstIndex(of:ref_id) {
                            mainInstance.songArray.remove(at: idx)
                        }
                    }
                    
                    //ProgressView.shared.hide()
                })
            } /*else{
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }*/
        })
    }
}
