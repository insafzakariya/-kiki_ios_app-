//
//  SearchResultViewController.swift
//  SusilaMobile
//
//  Created by Kiroshan on 6/2/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

import Foundation

class SearchResultViewController: UIViewController {
    
    var searchViewModel = SearchViewModel()
    var tableView = UITableView()
    var type: String?
    var key: String?
    var addAlertDialog = AddAlertDialog()
    var addToPlaylistAlertDialog = AddToPlaylistAlertDialog()
    var overLayView = UIView(frame: UIScreen.main.bounds)
    var playerView: PlayerView?
    var songList: [Song] = []
    var scrollStatus = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = Constants.color_background
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.frame.height-60))
        search(key: key!, type: type!, offset: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        tableView.backgroundColor = Constants.color_background
        tableView.isHidden = true
        view.addSubview(tableView)
        
        overLayView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        addAlertDialog = AddAlertDialog(frame: getCenteredFrameForOverlay(150))
        addAlertDialog.isHidden = true
        addAlertDialog.layer.zPosition = 1002
        addAlertDialog.btnCancel.addTarget(self, action: #selector(cancelClickAddAlertDialog), for: .touchUpInside)
        
        let tapAddToLibrary = PlaylistPlayGesture(target: self, action: #selector(buttonClick_AddToLibrary))
        addAlertDialog.lblAddToLibrary.isUserInteractionEnabled = true
        addAlertDialog.lblAddToLibrary.addGestureRecognizer(tapAddToLibrary)
        
        let tapAddToPlaylist = PlaylistPlayGesture(target: self, action: #selector(buttonClick_AddToPlaylist))
        //tapAddToPlaylist.id =
        addAlertDialog.lblAddToPlaylist.isUserInteractionEnabled = true
        addAlertDialog.lblAddToPlaylist.addGestureRecognizer(tapAddToPlaylist)
        
        addToPlaylistAlertDialog = AddToPlaylistAlertDialog(frame: getCenteredFrameForOverlay(300))
        addToPlaylistAlertDialog.isHidden = true
        addToPlaylistAlertDialog.layer.zPosition = 2002
        //addToPlaylistAlertDialog.scrollCollection = self
        addToPlaylistAlertDialog.btnCancel.addTarget(self, action: #selector(cancelClickAddToPlaylistAlertDialog), for: .touchUpInside)
        
        view.addSubview(addAlertDialog)
        view.addSubview(addToPlaylistAlertDialog)
    }
    
    func getCenteredFrameForOverlay(_ height: CGFloat) -> CGRect {
        return CGRect(x: 15, y: (UIScreen.main.bounds.height - 250 - height)/2, width: UIScreen.main.bounds.width - 30 , height: height)
    }
    
    @objc func cancelClickAddAlertDialog(sender:PlaylistTapGesture) {
        addAlertDialog.isHidden = true
        addAlertDialog.removeFromSuperview()
        overLayView.removeFromSuperview()
    }
    
    @objc func cancelClickAddToPlaylistAlertDialog(sender:PlaylistTapGesture) {
        addToPlaylistAlertDialog.isHidden = true
        addToPlaylistAlertDialog.removeFromSuperview()
    }
    
    @objc func buttonClick_AddToLibrary(sender:PlaylistPlayGesture) {
        addToLibrary(key: "S", songs: addAlertDialog.id)
    }
    
    @objc func buttonClickedAddPlaylistToLibrary(recognizer: PlaylistPlayGesture) {
        addToLibrary(key: "P", songs: recognizer.id)
    }
    
    var homeDataModel = HomeDataModel()
    func addToLibrary(key: String, songs: Int) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        
        self.homeDataModel.addToLibrary(key: key, songs: songs, addToLibraryCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    self.alert(message: NSLocalizedString("AddedToLibrary".localized(using: "Localizable"), comment: ""))
                    self.addAlertDialog.isHidden = true
                    self.addAlertDialog.removeFromSuperview()
                    self.overLayView.removeFromSuperview()
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    @objc func buttonClick_AddToPlaylist(sender:PlaylistPlayGesture) {
        addToPlaylistAlertDialog.removeFromSuperview()
        loadPlaylistsList()
        showAddToPlaylistAlertDialog(title: "Select Playlist", id: String(sender.id))
    }
    
    func showAddToPlaylistAlertDialog(title: String, id: String) {
        view.addSubview(addToPlaylistAlertDialog)
        addToPlaylistAlertDialog.id = addAlertDialog.id
        addToPlaylistAlertDialog.isHidden = false
    }
    
    var libraryAllPlaylists: [GlobalPlaylistItem] = [GlobalPlaylistItem]()
    var libraryDataModel = LibraryDataModel()
    func loadPlaylistsList() {
        self.libraryDataModel.getPlaylists(getPlaylistCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async {
                    self.libraryAllPlaylists = self.libraryDataModel.playlists
                    self.loadList(view: self.addToPlaylistAlertDialog.scrollList)
                }
            } else {
                DispatchQueue.main.async(execute: {})
            }
        })
    }
    
    var uiAlert = UIView(frame: CGRect.zero)
    func loadList(view: UIView) {
        uiAlert.removeFromSuperview()
        uiAlert = UIView(frame: CGRect(x: 0, y: 0, width: self.addToPlaylistAlertDialog.scrollList.frame.width, height: CGFloat(libraryAllPlaylists.count)*(UIScreen.main.bounds.width/6)+CGFloat(libraryAllPlaylists.count)*20))
        
        var xLength: CGFloat = 0
        for (_, tileData) in libraryAllPlaylists.enumerated(){
            
            
            let songTile = PlaylistTileAlertAllPlaylist(frame: CGRect(x: 10, y: xLength, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width/6))
            songTile.lblTitle.text = tileData.name
            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickAddSongToPlaylists))
            tap.id = String(tileData.id)
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            xLength += UIScreen.main.bounds.width/6+20
            uiAlert.addSubview(songTile)
        }
        view.addSubview(uiAlert)
        
        self.addToPlaylistAlertDialog.scrollList.contentSize = CGSize(width: self.addToPlaylistAlertDialog.scrollList.frame.width, height: CGFloat(libraryAllPlaylists.count)*(UIScreen.main.bounds.width/6)+CGFloat(libraryAllPlaylists.count)*20)
    }
    
    @objc func buttonClickAddSongToPlaylists(recognizer: PlaylistTapGesture) {
        print("PlaylistId ", recognizer.id," SongId ", self.addAlertDialog.id)
        var songsid = [String]()
        songsid.append(String(self.addAlertDialog.id))
        addSongToPlaylist(playlistId: recognizer.id, songs: songsid)
        self.alert(message: NSLocalizedString("AddedToPlayList".localized(using: "Localizable"), comment: ""))
        self.addToPlaylistAlertDialog.isHidden = true
        self.addToPlaylistAlertDialog.removeFromSuperview()
        
        self.addAlertDialog.isHidden = true
        self.addAlertDialog.removeFromSuperview()
        self.overLayView.removeFromSuperview()
        
    }
    
    func addSongToPlaylist(playlistId: String, songs: [String]) {
        ProgressView.shared.show(addToPlaylistAlertDialog, mainText: nil, detailText: nil)
        self.libraryDataModel.addToPlaylist(playlistId: playlistId, songs: songs, addToPlaylistCallFinished: { (status, error, userInfo) in
            if status {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func buttonClick_Add(sender:PlaylistTapGesture) {
        showAddAlertDialog(title: sender.title, id: Int(sender.id)!)
    }
    
    func showAddAlertDialog(title: String, id: Int) {
        overLayView.removeFromSuperview()
        view.addSubview(overLayView)
        view.addSubview(addAlertDialog)
        addAlertDialog.lblTitle.text = title
        addAlertDialog.id = id
        addAlertDialog.isHidden = false
    }
    
    func search(key: String, type: String, offset: Int) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        searchViewModel.searchByWordAll(key: key, type: type, offset: offset) { (status, error, isEmpty) in
            if (status && isEmpty) {
                let alert = UIAlertController(title: "Kiki", message: "No results available", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.tableView.reloadData()
                ProgressView.shared.hide()
            } else {
                if type == "song" {
                    self.songList.append(contentsOf: self.searchViewModel.songList)
                }
                self.tableView.isHidden = false
                self.tableView.reloadData()
                ProgressView.shared.hide()
                self.scrollStatus = true
            }
        }
    }
    
    @objc func actPlaySingleSong(sender: SearchSongTapGesture) {
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            mainInstance.searchStatus = true
            NotificationCenter.default.post(name: Notification.Name("PlaySong"), object: sender.objSong)
            print("songCard.songData: ", sender.objSong as Any)
            //self.navigationController?.popViewController(animated: true)
        }
    }
    
    var windows = UIApplication.shared.keyWindow!
    func getRootViewController() -> KYDrawerController{
        return windows.rootViewController as! KYDrawerController
    }
    
    func subscribeAlert() {
        if AppStoreManager.IS_ON_REVIEW{
            UIHelper.makeNoContentAlert(on: self.view.window!)
        }else{
            UIHelper.makeSubscribeToListenAlert(on: self.view.window!)
        }
    }
    
    @objc func buttonClickedAddArtistToLibrary(recognizer: PlaylistPlayGesture) {
        addToLibrary(key: "A", songs: recognizer.id)
    }
    
    @objc func buttonClickedArtist(recognizer: MyTapGesture) {
        //self.loadPopularArtistSongsList(id: recognizer.id)
        // self.createArtistDetails(id: recognizer.id, name: recognizer.aname, url: recognizer.url, album: "", song: String(recognizer.songs)+" Songs")
        let controller = ArtistDetailViewController()
        controller.id = recognizer.id
        controller.name = recognizer.aname
        controller.url =  recognizer.url
        controller.album = ""
        controller.song = String(recognizer.songs)+" Songs"
        controller.playerView = self.playerView
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonClickedPlaylistDetails(recognizer: PlaylistTapGesture) {
        print("Printer ", recognizer.id," ", recognizer.title," ", recognizer.image)
        let controller = PlaylistDetailViewController()
        controller.id = recognizer.id
        controller.image = recognizer.image
        controller.name = recognizer.title
        controller.songs = recognizer.songs
        controller.year = recognizer.year
        controller.playerView = self.playerView
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func timeString(time: TimeInterval) -> String {
        /*let hour = Int(time) / 3600
         let minute = Int(time) / 60 % 60
         let second = Int(time) % 60*/
        
        let t = time*60
        
        let minute = Int(t) / 60
        let second = Int(t) % 60
        
        // return formated string
        return String(format: "%02i:%02i", minute, second)
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == "song" {
            return self.songList.count
        } else if type == "artist" {
            return self.searchViewModel.artistListsAll.count
        } else {
            return self.searchViewModel.playlistListAll.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if type == "song" {
            
            tableView.rowHeight = UIScreen.main.bounds.width/6+20
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell")!
            cell.backgroundColor = Constants.color_background
            let songTile = SongTileHomeListSquareSongs(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/6+20))
            //songTile.songData = self.searchViewModel.songList[indexPath.row]
            songTile.id = self.songList[indexPath.row].id
            songTile.lblTitle.text = self.songList[indexPath.row].name
            songTile.lblDescription.text = self.songList[indexPath.row].description
            songTile.duration.text = timeString(time: TimeInterval(self.songList[indexPath.row].duration!))
            
            var decodedImage = self.songList[indexPath.row].image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            
            let tapPlay = SearchSongTapGesture(target: self, action: #selector(actPlaySingleSong))
            tapPlay.objSong = self.songList[indexPath.row]
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tapPlay)
            
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClick_Add))
            tap.id = String(self.songList[indexPath.row].id)
            tap.title = self.songList[indexPath.row].name
            songTile.add.isUserInteractionEnabled = true
            songTile.add.addGestureRecognizer(tap)
            
            
            
            //songTile.btnPlay.addTarget(self, action: #selector(self.actPlaySingleSong(_:)), for: UIControl.Event.touchUpInside)
            
            for view in cell.subviews {
                if (view is SongTileHomeListSquareSongs) {
                    view.removeFromSuperview()
                }
            }
            cell.addSubview(songTile)
            return cell
            
        } else if type == "artist" {
            
            tableView.rowHeight = UIScreen.main.bounds.width/6+20
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell")!
            cell.backgroundColor = Constants.color_background
            let songTile = ArtistTileSearch(frame: CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/6+20))
            //songTile.songData = self.searchViewModel.artistLists[index]
            songTile.lblTitle.text = self.searchViewModel.artistListsAll[indexPath.row].name
            var decodedImage = self.searchViewModel.artistListsAll[indexPath.row].image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            if self.searchViewModel.artistListsAll[indexPath.row].songsCount! > 0 {
                songTile.albums.text = String(self.searchViewModel.artistListsAll[indexPath.row].songsCount!)+" songs"
            }
            
            let tap = MyTapGesture(target: self, action: #selector(buttonClickedArtist))
            tap.id = self.searchViewModel.artistListsAll[indexPath.row].id
            tap.aname = self.searchViewModel.artistListsAll[indexPath.row].name
            tap.url = decodedImage
            tap.songs = self.searchViewModel.artistListsAll[indexPath.row].songsCount!
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            let tapAdd = PlaylistPlayGesture(target: self, action: #selector(buttonClickedAddArtistToLibrary))
            tapAdd.id = self.searchViewModel.artistListsAll[indexPath.row].id
            songTile.add.isUserInteractionEnabled = true
            songTile.add.addGestureRecognizer(tapAdd)
            
            for view in cell.subviews {
                if (view is ArtistTileSearch) {
                    view.removeFromSuperview()
                }
            }
            cell.addSubview(songTile)
            return cell
            
        } else {
            
            tableView.rowHeight = UIScreen.main.bounds.width/6+20
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell")!
            cell.backgroundColor = Constants.color_background
            let songTile = PlaylistTileSearch(frame: CGRect(x: 0, y: 10, width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.width)/6+20))
            songTile.lblTitle.text = self.searchViewModel.playlistListAll[indexPath.row].name
            
            var decodedImage: String = ""
            decodedImage = self.searchViewModel.playlistListAll[indexPath.row].image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
            
            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            songTile.index = indexPath.row
            songTile.songs.text = String(self.searchViewModel.playlistListAll[indexPath.row].number_of_songs)+" songs"
            
            let dateArr = self.searchViewModel.playlistListAll[indexPath.row].date!.components(separatedBy: "-")
            songTile.year.text = dateArr[0]
            
            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickedPlaylistDetails))
            tap.id = String(self.searchViewModel.playlistListAll[indexPath.row].id)
            tap.image = decodedImage
            tap.title = self.searchViewModel.playlistListAll[indexPath.row].name
            tap.songs = String(self.searchViewModel.playlistListAll[indexPath.row].number_of_songs)
            tap.year =  dateArr[0]
            songTile.isUserInteractionEnabled = true
            songTile.addGestureRecognizer(tap)
            
            let tapAdd = PlaylistPlayGesture(target: self, action: #selector(buttonClickedAddPlaylistToLibrary))
            tapAdd.id = self.searchViewModel.playlistListAll[indexPath.row].id
            songTile.add.isUserInteractionEnabled = true
            songTile.add.addGestureRecognizer(tapAdd)
            
            cell.addSubview(songTile)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if type == "song" && indexPath.row == self.songList.count-1 && self.songList.count % 10 == 0 && scrollStatus {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if tableView.visibleCells.contains(cell) {
                    self.scrollStatus = false
                    self.search(key: self.key!, type: self.type!, offset: self.songList.count)
                }
            }
            
        }
    }
    
}
