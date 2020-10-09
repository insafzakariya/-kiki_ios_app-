//
//  SongsTileSelectArtistDetails.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/14/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//
class SongsTileSelectArtistDetails: UIView {
    var libraryDataModel = LibraryDataModel()
    var id = 0
    var imageContainer = UIView(frame: CGRect.zero)
    var image = UIImageView(frame: CGRect.zero)
    var lblTitle = UILabel(frame: CGRect.zero)
    var lblDescription = UILabel(frame: CGRect.zero)
    var selectedFrame = UIView(frame: CGRect.zero)
    var unselectText = UILabel(frame: CGRect.zero)
    
    var imageURL = "" {
        willSet{
            
        }
        didSet{
            //image.downloadImage(from: URL(string: imageURL)!)
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
        
        lblTitle.font = UIFont.boldSystemFont(ofSize: 12)
        lblTitle.textColor = UIColor.white
        lblTitle.textAlignment = .center
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
    }
    
    func addToTempPlaylistSongs(session_id: String, ref_id: Int, type: String) {
        self.libraryDataModel.addToTempPlaylistSongs(session_id: session_id, ref_id: ref_id, type: type, addToTempPlaylistSongsCallFinished: { (status_r, error, userInfo) in
            if status_r {
                DispatchQueue.main.async(execute: {
                    if self.unselectText.text == "" {
                        mainInstance.songArray.append(ref_id)
                        self.selectedFrame.backgroundColor = Constants.color_selectedSong
                        self.unselectText.text = "Added"
                    } else {
                        if let idx = mainInstance.songArray.firstIndex(of:ref_id) {
                            mainInstance.songArray.remove(at: idx)
                        }
                        self.selectedFrame.backgroundColor = .clear
                        self.unselectText.text = ""
                    }
                })
            }
        })
    }
}
