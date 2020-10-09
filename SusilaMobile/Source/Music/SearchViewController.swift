//
//  SearchViewController.swift
//  SusilaMobile
//
//  Created by Meuru Muthuthanthri on 5/4/19.
//  Copyright © 2019 Isuru Jayathissa. All rights reserved.
//

import Foundation

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var barSwitch: Bool = false
    let libraryController = LibraryController()
    let searchViewModel: SearchViewModel = SearchViewModel()
    var addAlertDialog = AddAlertDialog()
    var addToPlaylistAlertDialog = AddToPlaylistAlertDialog()
    var overLayView = UIView(frame: UIScreen.main.bounds)
    var objSong: [Song] = [Song]()
    var songView: UIView!
    var artistView: UIView!
    var playlistView: UIView!
    var playerView: PlayerView?
    var scrollStatus = false
    var songsList: [Song] = []
    var historyView = UIView()
    var arry:[Int] = []
    var pSongs: [Song] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if mainInstance.searchStatus {
            //self.navigationController?.popViewController(animated: true)
        }
        mainInstance.searchStatus = false
        //print("SongPressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("SEARCH".localized(using: "Localizable"), comment: "")
        for (_, s) in pSongs.enumerated() {
            print("Selected song: ", s.name)
            arry.append(s.id)
        }
        
        view.backgroundColor = Constants.color_background
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        tableView.backgroundColor = Constants.color_background
        tableView.isHidden = true
        
        historyView = UIView(frame: CGRect(x: 0, y: searchBar.frame.height, width: UIScreen.main.bounds.width, height:180))
        
        let header = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width-20, height:30))
        header.text = NSLocalizedString("RECENT_SEARCH".localized(using: "Localizable"), comment: "")
        header.textColor = .white
        header.font = UIFont(name: "Roboto-Bold", size: 18.0)
        historyView.addSubview(header)
        
        view.addSubview(historyView)
        
        getSearchHistory()
        self.songsList.removeAll()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes
            .updateValue(UIColor.white, forKey: NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue))
        
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
        
        songView = UIView(frame: CGRect.zero)
        artistView = UIView(frame: CGRect.zero)
        playlistView = UIView(frame: CGRect.zero)
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
    
    
    @objc func buttonClick_searchHistory(sender:PlaylistTapGesture) {
        self.view.endEditing(true)
        searchBar.text = sender.title
        self.historyView.isHidden = true
        if barSwitch {
            self.songsList.removeAll()
            searchByWord(offset: 0)
        } else {
            ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
            searchViewModel.searchByWord(text: sender.title) { (status, error, isEmpty) in
                if (status && self.searchViewModel.songsList.isEmpty && self.searchViewModel.artistLists.isEmpty && self.searchViewModel.playlistList.isEmpty) {
                    let alert = UIAlertController(title: "Kiki", message: NSLocalizedString("NoSearchResultFound".localized(using: "Localizable"), comment: ""), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.tableView.reloadData()
                    ProgressView.shared.hide()
                } else {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    ProgressView.shared.hide()
                }
            }
        }
    }
    
    func showAddAlertDialog(title: String, id: Int) {
        overLayView.removeFromSuperview()
        view.addSubview(overLayView)
        view.addSubview(addAlertDialog)
        addAlertDialog.lblTitle.text = title
        addAlertDialog.id = id
        addAlertDialog.isHidden = false
    }
    
    func getSearchHistory() {
        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        searchViewModel.getSearchHistory(getSearchHistoryCallFinished: { (status, error, isEmpty) in
            if (status) {
                var h = 30
                if self.searchViewModel.searchHistory.count<6 {
                    for (index, _) in self.searchViewModel.searchHistory.enumerated() {
                        
                        let result = UILabel(frame: CGRect(x: 10, y: h, width: Int(UIScreen.main.bounds.width)-20, height:30))
                        result.text =  self.searchViewModel.searchHistory[index]
                        result.textColor = Constants.color_brand
                        result.font = UIFont(name: "Roboto-Bold", size: 15.0)
                        h = h+30
                        let tap = PlaylistTapGesture(target: self, action: #selector(self.buttonClick_searchHistory))
                        tap.title = self.searchViewModel.searchHistory[index]
                        result.isUserInteractionEnabled = true
                        result.addGestureRecognizer(tap)
                        self.historyView.addSubview(result)
                    }
                }
            }
            ProgressView.shared.hide()
        })
    }
    
    func searchByWord(offset: Int) {
        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        searchViewModel.searchByWordAll(key: searchBar.text!, type: "song", offset: offset, searchByWordAllCallFinished: { (status, error, isEmpty) in
            if (status && isEmpty) {
                let alert = UIAlertController(title: "Kiki", message: NSLocalizedString("NoSearchResultFound".localized(using: "Localizable"), comment: ""), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                ProgressView.shared.hide()
            }
            self.songsList.append(contentsOf: self.searchViewModel.songList)
            print("searchData: ", self.songsList)
            if status {
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
            
            ProgressView.shared.hide()
            self.scrollStatus = true
        })
    }
    
    /* UISearchBarDelegate */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.historyView.isHidden = true
        if barSwitch {
            self.songsList.removeAll()
            searchByWord(offset: 0)
        } else {
            ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
            searchViewModel.searchByWord(text: searchBar.text!) { (status, error, isEmpty) in
                if (status && self.searchViewModel.songsList.isEmpty && self.searchViewModel.artistLists.isEmpty && self.searchViewModel.playlistList.isEmpty) {
                    let alert = UIAlertController(title: "Kiki", message: NSLocalizedString("NoSearchResultFound".localized(using: "Localizable"), comment: ""), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.tableView.reloadData()
                    ProgressView.shared.hide()
                } else {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    ProgressView.shared.hide()
                }
            }
        }
    }
    
    /* Table view */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if barSwitch {
            return self.songsList.count
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.rowHeight = 100
        tableView.separatorColor = .clear
        /**/
        if barSwitch {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell")!
            cell.backgroundColor = Constants.color_background
            let songTile = PlayListSongsCardAddToPlaylist(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
            songTile.songData = self.songsList[indexPath.row]
            songTile.id =  self.songsList[indexPath.row].id
            
            if arry.contains(self.songsList[indexPath.row].id) {
                songTile.add.backgroundColor = Constants.color_brand
                songTile.add.setTitleColor( .white, for: .normal)
                songTile.add.setTitle(NSLocalizedString("AddedToPlayList".localized(using: "Localizable"), comment: ""), for: .normal)
            }
            
            var decodedImage =  self.songsList[indexPath.row].image!.replacingOccurrences(of: "%3A", with: ":")
            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
            songTile.imgVw.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
            //songTile.btnPlay.addTarget(self, action: #selector(self.actPlaySingleSong(_:)), for: UIControl.Event.touchUpInside)
            
            for view in cell.subviews {
                if (view is PlayListSongsCardAddToPlaylist) {
                    view.removeFromSuperview()
                }
            }
            cell.addSubview(songTile)
             return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell")!
            cell.backgroundColor = Constants.color_background
            if indexPath.row == 0 {
                var y = 0
                let h=Int(UIScreen.main.bounds.width/6+20)
                if self.searchViewModel.songsList.count>3 {
                    y=3
                } else{
                    y=self.searchViewModel.songsList.count
                }
                
                if !searchViewModel.songsList.isEmpty {
                    
                    songView.removeFromSuperview()
                    songView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: self.searchViewModel.songsList.count*h+50))
                    
                    let labelSongs = UILabel()
                    labelSongs.frame = CGRect(x: 10, y: 0, width: cell.frame.width-20, height:20)
                    labelSongs.text = NSLocalizedString("Song".localized(using: "Localizable"), comment: "")
                    labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
                    labelSongs.textColor = UIColor.white
                    songView.addSubview(labelSongs)
                    //cell.addSubview(labelSongs)
                    
                    
                    for (index, tileData) in self.searchViewModel.songsList.enumerated() {
                        if index<3 {
                        
                            let songTile = PlayListSongsCard(frame: CGRect(x: 0, y: index*h+30, width: Int(UIScreen.main.bounds.width), height: h))
                            songTile.id = tileData.id
                            songTile.lblDescription.text = tileData.description
                            songTile.lblTitle.text = tileData.name
                            songTile.index = index
                            
                            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                            songTile.duration.text = timeString(time: TimeInterval(tileData.duration!))//String(tileData.duration!/60)
                            if index != y-1 {
                                songTile.line.backgroundColor = .gray
                            }
                            let tapPlay = SearchSongTapGesture(target: self, action: #selector(actPlaySingleSong))
                            tapPlay.objSong = self.searchViewModel.songsList[index]
                            songTile.isUserInteractionEnabled = true
                            songTile.addGestureRecognizer(tapPlay)
                            
                            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClick_Add))
                            tap.id = String(self.searchViewModel.songsList[index].id)
                            tap.title = self.searchViewModel.songsList[index].name
                            songTile.add.isUserInteractionEnabled = true
                            songTile.add.addGestureRecognizer(tap)
                            
                            songView.addSubview(songTile)
                            cell.addSubview(songView)
                    
                        }
                    }
                    
                    let labelSongsSeeAll = UILabel()
                    labelSongsSeeAll.frame = CGRect(x: 0, y:y*h+30, width: Int(UIScreen.main.bounds.width)-100, height:30)
                    labelSongsSeeAll.center.x = cell.center.x
                    labelSongsSeeAll.text = NSLocalizedString("ViewAll".localized(using: "Localizable"), comment: "")
                    labelSongsSeeAll.textAlignment = .center
                    labelSongsSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
                    labelSongsSeeAll.layer.cornerRadius = 15
                    labelSongsSeeAll.textColor = UIColor.white
                    labelSongsSeeAll.layer.masksToBounds = true
                    labelSongsSeeAll.backgroundColor = Constants.color_brand
                    let tap = SearchTapGesture(target: self, action: #selector(buttonClickedSeeAllSongs))
                    tap.key = searchBar.text!
                    tap.type = "song"
                    labelSongsSeeAll.isUserInteractionEnabled = true
                    labelSongsSeeAll.addGestureRecognizer(tap)
                    
                    if self.searchViewModel.songsList.count>2 {
                        songView.addSubview(labelSongsSeeAll)
                        tableView.rowHeight = CGFloat(y*h+80)
                    } else {
                        tableView.rowHeight = CGFloat(y*h+40)
                    }
                    
                    
                    /*cell.backgroundColor = Constants.color_background
                    let songTile = PlayListSongsCard(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
                    songTile.songData = self.searchViewModel.songsList[indexPath.row]
                    let tap2 = SearchSongTapGesture(target: self, action: #selector(actPlaySingleSong))
                    tap2.objSong = self.searchViewModel.songsList[indexPath.row]
                    songTile.isUserInteractionEnabled = true
                    songTile.addGestureRecognizer(tap2)
                    
                    var decodedImage = self.searchViewModel.songsList[indexPath.row].image!.replacingOccurrences(of: "%3A", with: ":")
                    decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                    songTile.imgVw.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                    let tap = PlaylistTapGesture(target: self, action: #selector(buttonClick_Add))
                    tap.id = String(self.searchViewModel.songsList[indexPath.row].id)
                    tap.title = self.searchViewModel.songsList[indexPath.row].name
                    songTile.add.isUserInteractionEnabled = true
                    songTile.add.addGestureRecognizer(tap)
                    for view in cell.subviews {
                        if (view is PlayListSongsCard) {
                            view.removeFromSuperview()
                        }
                    }
                    cell.addSubview(songTile)*/
                   
                } else {
                    tableView.rowHeight = 0
                }
            }
            
            if indexPath.row == 1 {
                
                var y = 0
                let h=Int(UIScreen.main.bounds.width/6+20)
                if self.searchViewModel.artistLists.count>3 {
                    y=3
                } else{
                    y=self.searchViewModel.artistLists.count
                }
                
                if !searchViewModel.artistLists.isEmpty {
                    
                    
                    artistView.removeFromSuperview()
                    artistView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: self.searchViewModel.artistLists.count*h+50))
                    
                    let labelSongs = UILabel()
                    labelSongs.frame = CGRect(x: 10, y: 0, width: cell.frame.width-20, height:20)
                    labelSongs.text = NSLocalizedString("Artist".localized(using: "Localizable"), comment: "")
                    labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
                    labelSongs.textColor = UIColor.white
                    artistView.addSubview(labelSongs)
                    //cell.addSubview(labelSongs)
                    
                    
                    for (index, tileData) in self.searchViewModel.artistLists.enumerated() {
                        if index<3 {
                            
                            let songTile = ArtistTileSearch(frame: CGRect(x: 0, y: index*h+30, width: Int(UIScreen.main.bounds.width), height: h))
                            //songTile.songData = self.searchViewModel.artistLists[index]
                            songTile.lblTitle.text = tileData.name
                            var decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                            if tileData.songsCount! > 0 {
                                //songTile.songs.text = String(tileData.songsCount!)+" songs"
                                songTile.albums.text = String(tileData.songsCount!)+" songs"
                            }
                            if tileData.numberOfAlbums! > 0 {
                                //songTile.albums.text = String (tileData.numberOfAlbums!)+" albums"
                                //songTile.albums.text = String(tileData.songsCount!)+" songs"
                            }
                            if index != y-1 {
                                songTile.line.backgroundColor = .gray
                            }
                            let tap = MyTapGesture(target: self, action: #selector(buttonClickedArtist))
                            tap.id = tileData.id
                            tap.aname = tileData.name
                            tap.url = decodedImage
                            tap.songs = tileData.songsCount!
                            songTile.isUserInteractionEnabled = true
                            songTile.addGestureRecognizer(tap)
                            
                            let tapAdd = PlaylistPlayGesture(target: self, action: #selector(buttonClickedAddArtistToLibrary))
                            tapAdd.id = tileData.id
                            songTile.add.isUserInteractionEnabled = true
                            songTile.add.addGestureRecognizer(tapAdd)
                            
                            artistView.addSubview(songTile)
                            cell.addSubview(artistView)
                        }
                    }
                    
                    let labelSongsSeeAll = UILabel()
                    labelSongsSeeAll.frame = CGRect(x: 0, y: y*h+30, width: Int(UIScreen.main.bounds.width)-100, height:30)
                    labelSongsSeeAll.center.x = cell.center.x
                    labelSongsSeeAll.text = NSLocalizedString("ViewAll".localized(using: "Localizable"), comment: "")
                    labelSongsSeeAll.textAlignment = .center
                    labelSongsSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
                    labelSongsSeeAll.layer.cornerRadius = 15
                    labelSongsSeeAll.textColor = UIColor.white
                    labelSongsSeeAll.layer.masksToBounds = true
                    labelSongsSeeAll.backgroundColor = Constants.color_brand
                    let tap = SearchTapGesture(target: self, action: #selector(buttonClickedSeeAllSongs))
                    tap.key = searchBar.text!
                    tap.type = "artist"
                    labelSongsSeeAll.isUserInteractionEnabled = true
                    labelSongsSeeAll.addGestureRecognizer(tap)
                    
                    if self.searchViewModel.artistLists.count>2 {
                        artistView.addSubview(labelSongsSeeAll)
                        tableView.rowHeight = CGFloat(y*h+80)
                    } else {
                        tableView.rowHeight = CGFloat(y*h+40)
                    }
                    
                } else {
                    tableView.rowHeight = 0
                }
            }
            
            if indexPath.row == 2 {
                
                var y = 0
                let h=Int(UIScreen.main.bounds.width/6+20)
                if self.searchViewModel.playlistList.count>3 {
                    y=3
                } else{
                    y=self.searchViewModel.playlistList.count
                }
                
                if !searchViewModel.playlistList.isEmpty {
                   
                    playlistView.removeFromSuperview()
                    playlistView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: self.searchViewModel.playlistList.count*h+50))
                    
                    let labelSongs = UILabel()
                    labelSongs.frame = CGRect(x: 10, y: 0, width: cell.frame.width-20, height:20)
                    labelSongs.text = NSLocalizedString("Playlists".localized(using: "Localizable"), comment: "")
                    labelSongs.font = UIFont(name: "Roboto-Bold", size: 18.0)
                    labelSongs.textColor = UIColor.white
                    playlistView.addSubview(labelSongs)
                    
                    for (index, tileData) in self.searchViewModel.playlistList.enumerated() {
                        if index<3 {
                            
                            let songTile = PlaylistTileSearch(frame: CGRect(x: 0, y: index*h+30, width: Int(UIScreen.main.bounds.width), height: h))
                            //songTile.lblDescription.text = tileData.description
                            songTile.lblTitle.text = tileData.name
                            
                            var decodedImage: String = ""
                            decodedImage = tileData.image!.replacingOccurrences(of: "%3A", with: ":")
                            decodedImage = decodedImage.replacingOccurrences(of: "%2F", with: "/")
                            decodedImage = decodedImage.replacingOccurrences(of: "+", with: "%20")
                            
                            songTile.image.sd_setImage(with: URL(string: decodedImage), placeholderImage: UIImage(named: "logo_grayscale"))
                            songTile.index = index
                            songTile.songs.text = String(tileData.number_of_songs)+" songs"
                            
                            let dateArr = tileData.date!.components(separatedBy: "-")
                            songTile.year.text = dateArr[0]
                            //songTile.styleType = self.styleType
                            if index != y-1 {
                                songTile.line.backgroundColor = .gray
                            }
                            
                            let tap = PlaylistTapGesture(target: self, action: #selector(buttonClickedPlaylistDetails))
                            tap.id = String(self.searchViewModel.playlistList[index].id)
                            tap.image = decodedImage
                            tap.title = self.searchViewModel.playlistList[index].name
                            tap.songs = String(self.searchViewModel.playlistList[index].number_of_songs)
                            tap.year =  dateArr[0]
                            songTile.isUserInteractionEnabled = true
                            songTile.addGestureRecognizer(tap)
                            
                            let tapAdd = PlaylistPlayGesture(target: self, action: #selector(buttonClickedAddPlaylistToLibrary))
                            tapAdd.id = tileData.id
                            songTile.add.isUserInteractionEnabled = true
                            songTile.add.addGestureRecognizer(tapAdd)
                            
                            playlistView.addSubview(songTile)
                            cell.addSubview(playlistView)
                        }
                    }
                    
                    let labelSongsSeeAll = UILabel()
                    labelSongsSeeAll.frame = CGRect(x: 0, y: y*h+30, width: Int(UIScreen.main.bounds.width)-100, height:30)
                    labelSongsSeeAll.center.x = cell.center.x
                    labelSongsSeeAll.text = NSLocalizedString("ViewAll".localized(using: "Localizable"), comment: "")
                    labelSongsSeeAll.textAlignment = .center
                    labelSongsSeeAll.font = UIFont(name: "Roboto-Bold", size: 10.0)
                    labelSongsSeeAll.layer.cornerRadius = 15
                    labelSongsSeeAll.textColor = UIColor.white
                    labelSongsSeeAll.layer.masksToBounds = true
                    labelSongsSeeAll.backgroundColor = Constants.color_brand
                    let tap = SearchTapGesture(target: self, action: #selector(buttonClickedSeeAllSongs))
                    tap.key = searchBar.text!
                    tap.type = "playlist"
                    labelSongsSeeAll.isUserInteractionEnabled = true
                    labelSongsSeeAll.addGestureRecognizer(tap)
                    
                    if self.searchViewModel.playlistList.count>2 {
                        playlistView.addSubview(labelSongsSeeAll)
                        tableView.rowHeight = CGFloat(y*h+70)
                    } else {
                        tableView.rowHeight = CGFloat(y*h+30)
                    }
                    
                } else {
                    tableView.rowHeight = 0
                }
            }
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = Constants.color_background
            cell.selectedBackgroundView = backgroundView
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if barSwitch && indexPath.row == self.songsList.count-1 && self.songsList.count % 10 == 0 && scrollStatus {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if tableView.visibleCells.contains(cell) {
                    self.scrollStatus = false
                    self.searchByWord(offset: self.songsList.count)
                }
            }
            
        }
    }
    
    @objc func buttonClickedAddPlaylistToLibrary(recognizer: PlaylistPlayGesture) {
        addToLibrary(key: "P", songs: recognizer.id)
    }
    
    @objc func buttonClickedAddArtistToLibrary(recognizer: PlaylistPlayGesture) {
        addToLibrary(key: "A", songs: recognizer.id)
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
    
    @objc func buttonClickedArtist(recognizer: MyTapGesture) {
        let controller = ArtistDetailViewController()
        controller.id = recognizer.id
        controller.name = recognizer.aname
        controller.url =  recognizer.url
        controller.album = ""
        controller.song = String(recognizer.songs)+" Songs"
        controller.playerView = self.playerView
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonClickedSeeAllSongs(recognizer: SearchTapGesture) {
        print("Key "+recognizer.type)
        let controller = SearchResultViewController()
        controller.key = recognizer.key
        controller.type = recognizer.type
        controller.playerView = self.playerView
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonClickedSeeAllSong(recognizer: SearchTapGesture) {
        let controller = AllSongViewController()
        controller.key = recognizer.key
        controller.type = recognizer.type
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
    
    @objc func actPlaySingleSong(sender: SearchSongTapGesture) {
        if mainInstance.subscribeStatus {
            subscribeAlert()
        } else {
            //let songCard = sender.contentView as! PlayListSongsCard
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
        let title = NSLocalizedString("SubscribeToListen".localized(using: "Localizable"), comment: "")
        let alert = UIAlertController(title: title, message: NSLocalizedString("PleaseActivateaPackageToUnlockAccess".localized(using: "Localizable"), comment: "")+NSLocalizedString("toExclusiveContentFromKiki".localized(using: "Localizable"), comment: ""), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("SubscribeNow".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: { action in
            let mainMenu = self.getRootViewController().drawerViewController as! SMMainMenuViewController
            mainMenu.navigateToPackagePage()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("CLOSE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
