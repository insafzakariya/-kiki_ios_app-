//
//  SMEpisodesViewController.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 3/6/17.
//  Modified by Kiroshan
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class SMEpisodesViewController: UIViewController {

    let homeViewModel = SMHomeViewModel()
    let playerViewModel = SMPlayerViewModel()

    @IBOutlet var tableView: UITableView!
    
    var episodeList: [Episode]!
    var program: Program!
    var parentVC:UIViewController!
    var currentEpisodeIndex: Int!
    var sortOrderDescending = true
    var iSTrailer = false
    
    var playerHEVC : IJKVideoViewController!
    let EpisodesTableViewCellIdentifier = "EpisodesTableViewCell"
    
    var listAdd = UIImage(named: "plus") as UIImage?
    var listRemove = UIImage(named: "checkbox_marked_outline_blue") as UIImage?

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name(rawValue: "VideoPlaybackReachedEnd"), object:nil)
        
    }
    
    func applicationDidEnterBackground(_ notification: Notification) {
        stopPlayer()
        ProgressView.shared.hide()
    }
    
    func applicationWillEnterForeground(_ notification: Notification) {
    }
    
    private func stopPlayer(){if (self.playerHEVC != nil && self.playerHEVC.player != nil) {
            self.playerHEVC.player.shutdown()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trailer(programId: self.program.id)
        self.navigationController?.isNavigationBarHidden = true
        tableView.register(UINib.init(nibName: "EpisodesTableViewCell", bundle: nil), forCellReuseIdentifier: EpisodesTableViewCellIdentifier)
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.tableFooterView = UIView()

        self.playerHEVC = self.storyboard?.instantiateViewController(withIdentifier: "IJKVideoViewController") as? IJKVideoViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopPlayer()
        ProgressView.shared.hide()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.playNextEpisode(_:)), name: NSNotification.Name(rawValue: "VideoPlaybackReachedEnd"), object: nil)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPlayer()
        ProgressView.shared.hide()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @objc func playTrailer(sender: UIButton ) {
        iSTrailer = true
        let epidode = episodeList[0]
            
        mainInstance.epPlayingStatus = true
        mainInstance.epPlayingId = epidode.id
            
        if let videoLink = epidode.previewLink {
            defaults.set("false", forKey: "trailer_only")
            defaults.synchronize()
            currentEpisodeIndex = 0
            let episodeNameString = epidode.name
            let videoTitle = (program != nil ? program.name : "") + " - " + episodeNameString;
            let player: IJKVideoViewController = self.playerHEVC
            
            let videoString = videoLink.removingPercentEncoding ?? ""
            let videoURL = NSURL(string: videoString)
            
            player.url = videoURL! as URL
            program.episode = epidode
            
            player.program = program
            player.setupToPlay(withTitle: videoTitle)
            player.onClickFullScreen(tableView)
            let subtitleLink = epidode.subtitleLink
            self.homeViewModel.fetchSubtitle(url: subtitleLink!, fetchSubtitleCallFinished: { (status, error, xmlString) in
                if status {
                    player.addSubtiles(xmlString)
                } else {
                    player.notifyNoSubtitleAvailable()
                }
            })
            
            self.homeViewModel.fetchAdvertisement(programId: epidode.id, fetchAdvertisementeCallFinished: {(status, error, data) in
                if status {
                    player.showAdvertisements(data)
                } else {
                    player.showAdvertisements([])
                }
            })
        }
    }
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        (UIApplication.shared.delegate as! AppDelegate).gotoHomeView()
    }
    
    func dismissLoader() {

        dismiss(animated: true) {
            print("Dismissing Loader view Controller")
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("Playing next episode")
        
        if segue.identifier == "AVPlayerEpisodeVC_segue" {
            self.playerHEVC = segue.destination as? IJKVideoViewController
        }
    }
    
    //MARK: - IBAction Methods
    @IBAction func tappedSortButton(_ sender: Any) {
        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        self.episodeList.reverse()
        self.tableView.reloadData()
        sortOrderDescending = !sortOrderDescending
        (sender as! UIButton).setImage(UIImage(named: sortOrderDescending ? "sort_down" : "sort_up"), for: .normal)
        ProgressView.shared.hide()
    }
    
    @objc func tappedSubcriptionButton(_ sender: Any) {
        self.unsubscribeProgram(sender)
    }
    func trailer(programId: Int) {
        self.homeViewModel.trailer(programId: programId, trailerProgramCallFinished: { (status, error) in
            if status {
                let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! EpisodesTableViewCell
                if mainInstance.like {
                    cell.likeBtn.isSelected = true
                    cell.likeBtn.setTitle("Already Liked", for: .normal)
                } else {
                    cell.likeBtn.isSelected = false
                    cell.likeBtn.setTitle(NSLocalizedString("LIKE_THIS_VIDEO".localized(using: "Localizable"), comment: ""), for: .normal)
                }
                
                if mainInstance.list {
                    cell.subscribeButton.setTitle("Remove from my list", for: .normal)
                    cell.subscribeButton.setImage(self.listRemove, for: .normal)
                } else {
                    cell.subscribeButton.setTitle(NSLocalizedString("ADD_TO_MY_LIST".localized(using: "Localizable"), comment: ""), for: .normal)
                    cell.subscribeButton.setImage(self.listAdd, for: .normal)
                }
            } else {
                if let error = error {
                    switch error.code {
                    case ResponseCode.noNetwork.rawValue:
                        Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""), perent: self)
                    default:
                        Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                    }
                }
            }
            DispatchQueue.main.async(execute: { ProgressView.shared.hide() })
        })
    }
    
    @objc func tappedLikeButton(_ sender: UIButton!) {
        
        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! EpisodesTableViewCell
               
        if mainInstance.like {
            cell.likeBtn.isSelected = false
            cell.likeBtn.setTitle(NSLocalizedString("LIKE_THIS_VIDEO".localized(using: "Localizable"), comment: ""), for: .normal)
        } else {
            cell.likeBtn.isSelected = true
            cell.likeBtn.setTitle("Already Liked", for: .normal)
            
        }
        likeProgran_v2()
        mainInstance.like = !mainInstance.like
        
    }
    
    func likeProgran_v2() {
        self.homeViewModel.likeProgram_v2(contentType: 2, contentId: program.id, actionType: 1, likeProgramCallFinished: { (status, error) in
            if !status {
                if let error = error {
                    switch error.code {
                    case ResponseCode.noNetwork.rawValue:
                        Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""), perent: self)
                    default:
                        Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                    }
                }
            }
            DispatchQueue.main.async(execute: { ProgressView.shared.hide() })
        })
    }

    @objc func tappedPlayAllButton(sender: UIButton ) {
        let epidode = episodeList[0]
        
        if let videoLink = epidode.videoLink{
            
            currentEpisodeIndex = 0
            let episodeNameString = epidode.name
            let videoTitle = (program != nil ? program.name : "") + " - " + episodeNameString;
            let player: IJKVideoViewController = self.playerHEVC
            
            let videoString = videoLink.removingPercentEncoding ?? ""
            let videoURL = NSURL(string: videoString)
           
            mainInstance.epPlayingStatus = true
            mainInstance.epPlayingId = epidode.id
            
            player.url = videoURL! as URL
            program.episode = epidode
            player.program = program
            player.setupToPlay(withTitle: videoTitle)
            player.onClickFullScreen(tableView)
            let subtitleLink = epidode.subtitleLink
            self.homeViewModel.fetchSubtitle(url: subtitleLink!, fetchSubtitleCallFinished: { (status, error, xmlString) in
                
                if status {
                    player.addSubtiles(xmlString)
                } else {
                    player.notifyNoSubtitleAvailable()
                }
            })
            
            self.homeViewModel.fetchAdvertisement(programId: epidode.id, fetchAdvertisementeCallFinished: {(status, error, data) in
                if status {
                    player.showAdvertisements(data)
                } else {
                    player.showAdvertisements([])
                }
            })
        }
    }
    
    func unsubscribeProgram(_ sender: Any) {
        let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! EpisodesTableViewCell
        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        if mainInstance.list {
            var alertController = UIAlertController()
            
            alertController = UIAlertController(title: "Kiki", message: NSLocalizedString("UNSUBSCRIBE_THIS_PROGRAM".localized(using: "Localizable"), comment: ""), preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "YES", style: .default) { (action) in
                print("In yes button")
                
                let program = self.program!
                self.homeViewModel.likeProgram_v2(contentType: 2, contentId: program.id, actionType: 2, likeProgramCallFinished: { (status, error) in
                    if status {
                        cell.subscribeButton.isSelected = false
                        cell.subscribeButton.setTitle(NSLocalizedString("ADD_TO_MY_LIST".localized(using: "Localizable"), comment: ""), for: .normal)
                        cell.subscribeButton.setImage(self.listAdd, for: .normal)
                        mainInstance.list = !mainInstance.list
                    } else {
                        if let error = error {
                            switch error.code {
                            case ResponseCode.noNetwork.rawValue:
                                Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""), perent: self)
                            default:
                                Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                            }
                        }
                    }
                    DispatchQueue.main.async(execute: {
                        ProgressView.shared.hide()
                    })
                })
            }

            let NoAction = UIAlertAction(title: "NO", style: .default) { (action) in
                print("In no button")
            }
            alertController.addAction(NoAction)
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                print("Present view controller")
            }
        } else {
            self.homeViewModel.likeProgram_v2(contentType: 2, contentId: program.id, actionType: 2, likeProgramCallFinished: { (status, error) in
                if status {
                    cell.subscribeButton.isSelected = true
                    cell.subscribeButton.setTitle("Remove from my list", for: .normal)
                    cell.subscribeButton.setImage(self.listRemove, for: .normal)
                    mainInstance.list = !mainInstance.list
                } else {
                    if let error = error {
                        switch error.code {
                        case ResponseCode.noNetwork.rawValue:
                            Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""), perent: self)
                        default:
                            Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                        }
                    }
                }
                DispatchQueue.main.async(execute: { ProgressView.shared.hide() })
            })
        }
    }
    
    @objc func playNextEpisode(_ object:Any) -> Void {
       
        if iSTrailer == false{
        let newIndex: Int
        if (currentEpisodeIndex == episodeList.count - 1) {
            newIndex = 0
        } else {
            newIndex = currentEpisodeIndex + 1
            self.playEpisodeAtIndex(newIndex)

        }
        NSLog("Playing next episode after finishing the current episode, index: %d", currentEpisodeIndex)
        }
        iSTrailer = false
    }
    
    func playEpisodeAtIndex(_ index:Int) {
        
        if (episodeList.isEmpty || episodeList.count <= index || episodeList[index].videoLink!.isEmpty) {
            return;
        }
        let prevIndex = currentEpisodeIndex
        currentEpisodeIndex = index
        let episode = episodeList[index]
        let videoTitle = program.name + " - " + episode.name;
        let player: IJKVideoViewController = self.playerHEVC
        
        let videoString = episode.videoLink!.removingPercentEncoding ?? ""
        let videoURL = NSURL(string: videoString)
        
        player.url = videoURL! as URL
        program.episode = episode
        
        //used hardcoded channel ID
        player.program = program
        player.setupToPlay(withTitle: videoTitle)
        if let cell = tableView.cellForRow(at: IndexPath(row: prevIndex ?? -1, section: 1)) as? SMEpisodesTableViewCell {
            cell.playingIndicationImg.isHidden = true
        }
        
        let subtitleLink = episode.subtitleLink
        self.homeViewModel.fetchSubtitle(url: subtitleLink!, fetchSubtitleCallFinished: { (status, error, xmlString) in
            if status {
                player.addSubtiles(xmlString)
            } else {
                player.notifyNoSubtitleAvailable()
            }
        })
        
        self.homeViewModel.fetchAdvertisement(programId: episode.id, fetchAdvertisementeCallFinished: {(status, error, data) in
            if status {
                player.showAdvertisements(data)
            } else {
                player.showAdvertisements([])
            }
        })
    }
}

// MARK: - UITableViewDelegate

extension SMEpisodesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = UIColor.clear
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "Roboto-Bold", size:18)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            if !episodeList.isEmpty {
                let epidode = episodeList[indexPath.row]
                
                if let videoLink = epidode.videoLink {
                    
                    currentEpisodeIndex = indexPath.row
                    defaults.set("false", forKey: "trailer_only")
                    defaults.synchronize()
                    
                    if epidode.trailer_only == true {
                        let defaults = UserDefaults.standard
                        defaults.set("true", forKey: "trailer_only")
                        defaults.synchronize()
                    }
                    
                    let episodeNameString = epidode.name
                    let videoTitle = program.name + " - " + episodeNameString;
                    let player: IJKVideoViewController = self.playerHEVC
                    
                    let videoString = videoLink.removingPercentEncoding ?? ""
                    let videoURL = NSURL(string: videoString)
                    
                    mainInstance.epPlayingStatus = true
                    mainInstance.epPlayingId = epidode.id
                    
                    player.url = videoURL! as URL
                    program.episode = epidode
                    player.program = program
                    player.setupToPlay(withTitle: videoTitle)
                    player.onClickFullScreen(tableView)
                    let subtitleLink = epidode.subtitleLink
                    self.homeViewModel.fetchSubtitle(url: subtitleLink!, fetchSubtitleCallFinished: { (status, error, xmlString) in
                        if status {
                            player.addSubtiles(xmlString)
                        } else {
                            player.notifyNoSubtitleAvailable()
                        }
                    })
                    
                    self.homeViewModel.fetchAdvertisement(programId: epidode.id, fetchAdvertisementeCallFinished: {(status, error, data) in
                        if status {
                            player.showAdvertisements(data)
                        } else {
                            player.showAdvertisements([])
                        }
                    })
                }
            }
        }
    }
}

extension SMEpisodesViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let shouldRequestForRemaingEpisodes = !(self.episodeList.last?.name.contains(" 01"))! && offsetY > contentHeight - scrollView.frame.size.height
        if (shouldRequestForRemaingEpisodes) {
            ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
            self.homeViewModel.getEpisodeList(programID: program.id, offset: self.episodeList.count, programType: program != nil ? program.type : "", getEpisodeListCallFinished: { (status, error, userInfo) in
                if status {
                    DispatchQueue.main.async(execute: {
                        self.episodeList.append(contentsOf: self.homeViewModel.episodeList)
                        self.tableView.reloadData()
                        ProgressView.shared.hide()
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        ProgressView.shared.hide()
                    })
                }
            })
        }
    }
}

// MARK: - UITableViewDataSource
extension SMEpisodesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if episodeList.isEmpty{
                return 0
            } else {
                return episodeList.count
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: EpisodesTableViewCellIdentifier, for: indexPath) as! EpisodesTableViewCell
            configureCellTop(cell, indexPath: indexPath)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SMEpisodesTableViewCell.identifier(), for: indexPath) as! SMEpisodesTableViewCell
            cell.playingIndicationImg.isHidden = true
            configureCell(cell, indexPath: indexPath)
            return cell
        }
        
    }
    fileprivate func configureCellTop(_ cell: EpisodesTableViewCell, indexPath: IndexPath) {
        cell.playNowBtn.addTarget(self, action: #selector(tappedPlayAllButton), for: .touchUpInside)
        cell.playTrailer.addTarget(self, action: #selector(playTrailer), for: .touchUpInside)
        cell.subscribeButton.addTarget(self, action: #selector(tappedSubcriptionButton), for: .touchUpInside)
        cell.likeBtn.addTarget(self, action: #selector(tappedLikeButton), for: .touchUpInside)
        
        /*trailer(programId: program.id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if mainInstance.like {
                cell.likeBtn.isSelected=true
                cell.likeBtn.setTitle("Already Liked", for: .normal)
            }; if !mainInstance.like {
                cell.likeBtn.isSelected=false
            };if mainInstance.list {
                cell.subscribeButton.isSelected=true
                cell.subscribeButton.setTitle("Remove from my list", for: .normal)
            };if !mainInstance.list {
                cell.subscribeButton.isSelected=false
            }
        }*/
        
        cell.lblMoreEpisodes.text = NSLocalizedString("MORE_EPISODES".localized(using: "Localizable"), comment: "")
        cell.name.text = program.name
        cell.descriptionHeader.text = program.description_p
        cell.playNowBtn.setTitle(NSLocalizedString("PLAY_NOW".localized(using: "Localizable"), comment: ""), for: .normal)
        cell.playTrailer.setTitle(NSLocalizedString("PLAY_TRAILER".localized(using: "Localizable"), comment: ""), for: .normal)
        
        let imageLink = !episodeList.isEmpty ? episodeList[0].image?.removingPercentEncoding ?? "" : ""
        cell.trailerImage.sd_setImage(with: URL(string: imageLink), placeholderImage: UIImage(named: "logo_grayscale_video"))
    }
    
    fileprivate func configureCell(_ cell: SMEpisodesTableViewCell, indexPath: IndexPath) {
        if !episodeList.isEmpty {
            func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
                URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
                    (data, response, error) -> Void in
                    DispatchQueue.main.async(execute: {
                        cell.videoImageView.contentMode = contentMode
                        if let data = data {
                            if case let cellToUpdate as SMEpisodesTableViewCell = self.tableView.cellForRow(at: indexPath) {
                                cellToUpdate.videoImageView?.image = UIImage(data: data)
                            }
                        }
                    })
                }).resume()
            }
            let episode = episodeList[indexPath.row]
            cell.name.text = "\(episode.name)"
            cell.descriptionLable.text = episode.description_e
            cell.videoImageView.image = nil
            cell.playingIndicationImg.isHidden = indexPath.row != currentEpisodeIndex
            
            downloadImageFrom(link: episode.image?.removingPercentEncoding ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
        }
    }
}
