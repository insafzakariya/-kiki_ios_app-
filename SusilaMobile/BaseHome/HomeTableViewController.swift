//
//  ViewController.swift
//  horizontal collection view scroll
//
//  Created by Rashminda Bandara on 1/28/19.
//  Copyright © 2019 Rashminda kumara. All rights reserved.
//

import UIKit
import ImageSlideshow
import AudioToolbox
import AVFoundation
import SwiftyJSON

class HomeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var mainMenuViewController :SMMainMenuViewController!
    let viewModel = SMChannelListModel()
    let homeViewModel = SMHomeViewModel()
    fileprivate let chatInitPresenter = ChatInitilizationPresenter()
    let notificationListViewModel = NotificationListModel()
    let notificationButton = MIBadgeButton(type: .system)
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var SubscriptionPromotionView: UIView!
    @IBOutlet weak var myListBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var collectionViewMyList: UICollectionView!
    
    let subscribedListViewModel = SMSubscribedListViewModel()
    let gradientLayer = CAGradientLayer()
    var channelList: [Channel] = [Channel]()
    
    var chId = 0
    var totalPrg : Int = 0
    var MyListShow  = false
    
    let tableViewCellIdentifier = "HomeTableCell"
    let collectionViewCellIdentifier = "HomeCollectionCell"
    let tableViewHeaderNibName = "HomeTableViewHeaderView"
    let tableViewHeaderIdentifer = "HomeTableViewHeader"
    let tableViewSideShowCellIdentifier = "sideShowCell"
    
    var noSubscribedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20, height: 100))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        chatInitPresenter.getChatChannels()
        chatInitPresenter.getChatToken()
        ProgressView.shared.hide()
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        self.navigationController?.isNavigationBarHidden = false
        tableView.register(UINib.init(nibName: "SideShowTableViewCell", bundle: nil), forCellReuseIdentifier: tableViewSideShowCellIdentifier)
        tableView.register(UINib.init(nibName: "ChatHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "chatHomeTableViewCell")
        
        setupNavigationBarItems()
        
        IAPManager.shared.getSubscribedPackage {
            IAPManager.shared.getPackages()
        }
        
        DispatchQueue.main.async{
            if !AppDelegate.IS_APP_ICON_CHANGED{
                AppIconManager(remoteConfig: (UIApplication.shared.delegate as! AppDelegate).getRemoteConfig()).setAppIcon()
            }
        }
        
        noSubscribedLabel.center = self.view.center
        noSubscribedLabel.text = NSLocalizedString("NoSubscribed".localized(using: "Localizable"), comment: "")
        noSubscribedLabel.numberOfLines = 3
        noSubscribedLabel.textAlignment = .center
        noSubscribedLabel.lineBreakMode = .byWordWrapping
        noSubscribedLabel.textColor = .white
        noSubscribedLabel.font = UIFont(name: "Roboto-Bold", size: 12.0)
        self.view.addSubview(noSubscribedLabel)
        noSubscribedLabel.isHidden = true
    }
    
    private func setupNavigationBarItems() {
        
        let titleImageView = UIImageView(image: UIImage(named: "HeaderLogo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 30)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        
        notificationButton.setImage(#imageLiteral(resourceName: "notification").withRenderingMode(.alwaysOriginal), for: .normal)
        notificationButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        notificationButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: 0, right: 6)
        notificationButton.badgeTextColor = UIColor(red:0.22, green:0.50, blue:0.51, alpha:1.0)
        notificationButton.badgeBackgroundColor = UIColor.clear
        
        notificationButton.contentMode = .scaleAspectFit
        notificationButton.addTarget(self, action: #selector(notifcicationBtn), for: .touchUpInside)
        let menuButton = UIButton(type: .system)
        menuButton.addTarget(self, action: #selector(tappedMenubutton), for: .touchUpInside)
        menuButton.setImage(UIImage(named: "menuIcon"), for: .normal)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: notificationButton)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    
    @IBAction func tappedMusicButton(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        (UIApplication.shared.delegate as! AppDelegate).gotoMusicView()
        mainInstance.currentPlayingId = 0
    }
    
    func loadNotificationList() {
        self.notificationListViewModel.getNotificationCount(getNotificationCountCallFinished: { (status, error, count) in
            if status {
                self.notificationButton.badgeString = count == 0 ? "" : "\(count ?? 0)"
            } else {
                self.notificationButton.badgeString = ""
            }
        })
    }
    
    @objc func tappedMenubutton(_ sender:UIButton?) {
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        elDrawer.setDrawerState(KYDrawerController.DrawerState.opened, animated: true)
    }
    
    @objc func notifcicationBtn(_ sender:AnyObject?) {
        let verificationViewController = storyboard?.instantiateViewController(withIdentifier: "SMNotificationViewController") as! SMNotificationViewController
        self.navigationController?.pushViewController(verificationViewController, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressView.shared.hide()
        self.notificationButton.badgeString = ""
        if MyListShow == false {
            loadChannelImageList()
            loadChannelList();
            self.loadNotificationList()
        }
    }
    
    func loadChannelImageList() {
        self.viewModel.getCarouselProgramList(getCarouselProgramListCallFinished: { (status, error, userInfo) in
            if status {
                DispatchQueue.main.async(execute: {
                    if (self.viewModel.channelImageList.count > 0) {
                        
                    } else {
                        ProgressView.shared.hide()
                    }
                })
            } else {
                DispatchQueue.main.async(execute: { })
            }
        })
    }
    
    // MARK: - ProgramList
    func loadChannelList() {
        noSubscribedLabel.isHidden = true
        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        
        self.viewModel.getChannelList(getChannelListCallFinished: { (status, error, userInfo) in
            if status {
                DispatchQueue.main.async(execute: {
                    
                    if (self.viewModel.channelList.count > 0) {
                        
                        //for programListOne in programLists {
                        for (_, programListOne) in self.viewModel.channelList.enumerated() {
                            
                            self.viewModel.getChannelListEpisode(channelID: programListOne.id) { (status, error, userInfo) in
                                if status && !userInfo {
                                    self.channelList = self.viewModel.channelList
                                    let chatChannel = Channel(id: -1, name: "KiKi Chats", image: nil, description_c: nil)
                                    self.channelList.insert(chatChannel, at: 0)
                                    self.tableView.isHidden = false
                                    self.tableView.reloadData()
                                    ProgressView.shared.hide()
                                    if notifyInstance.status {
                                        notifyInstance.status = false
                                        self.selectNotify()
                                    }
                                }
                            }
                        }
                    } else {
                        self.tableView.isHidden = true
                        ProgressView.shared.hide()
                        Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("EMPTY_LIST".localized(using: "Localizable"), comment: ""), perent: self)
                    }
                })
                
                
            } else {
                if let error = error {
                    print("Error occurred while fetching the current package: \(error)")
                    if (error.code == 1017) {
                        Common.logout()
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.tableView.isHidden = true
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    @IBAction func homeBtnClick(_ sender: Any) {
        MyListShow = false
        collectionViewMyList.isHidden = true
        loadChannelImageList()
        loadChannelList();
        self.loadNotificationList()
        UIDevice.vibrate()
        myListBtn.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        homeBtn.backgroundColor = UIColor(red:0.00, green:0.61, blue:0.62, alpha:1.0)
        myListBtn.setTitleColor(UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0), for: .normal)
        homeBtn.setTitleColor(UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0), for: .normal)
        homeBtn.tintColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        myListBtn.tintColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0)
        
    }
    
    //MyList
    @IBAction func myListBtnClick(_ sender: Any) {
        self.collectionViewMyList.isHidden = false
        MyListShow = true
        loadSubscribedVideoList()
        UIDevice.vibrate()
        homeBtn.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        myListBtn.backgroundColor = UIColor(red:0.00, green:0.61, blue:0.62, alpha:1.0)
        homeBtn.setTitleColor(UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0), for: .normal)
        myListBtn.setTitleColor(UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0), for: .normal)
        myListBtn.tintColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        homeBtn.tintColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0)
    }
    
    func loadSubscribedVideoList() {
        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        self.subscribedListViewModel.getSubscribedListWithoutChannelID(getSubscribedListCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    if (self.subscribedListViewModel.programList.count > 0) {
                        self.collectionViewMyList.isHidden = false
                        self.collectionViewMyList.reloadData()
                    } else {
                        if self.MyListShow {
                            self.noSubscribedLabel.isHidden = false
                        }
                        self.collectionViewMyList.isHidden = false
                        self.collectionViewMyList.reloadData()
                    }
                    ProgressView.shared.hide()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.collectionViewMyList.isHidden = false
                    self.collectionViewMyList.reloadData()
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    /*myList*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if channelList.isEmpty{
            return 0
        } else {
            return channelList.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ?  500.0 :  250.0
        }else if indexPath.section == 1{
            return 82.0
        }else{
            return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ?  200.0 :  160.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = Constants.getFont(size: 18)
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            let channel = channelList[section - 1]
            Log("Section: \(section), Channel Name: \(channel.name)")
            return channel.name
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: tableViewSideShowCellIdentifier, for: indexPath) as! SideShowTableViewCell
            
            cell.vwCarousel.backgroundColor = Constants.videoAppBackColor
            cell.vwCarousel.slideshowInterval = 3.0
            cell.vwCarousel.pageControlPosition = PageControlPosition.underScrollView
            cell.vwCarousel.pageControl.currentPageIndicatorTintColor = UIColor.white
            cell.vwCarousel.pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.5)
            cell.vwCarousel.contentScaleMode = UIView.ContentMode.scaleAspectFill
            cell.vwCarousel.setImageInputs(self.viewModel.channelImageList)
            //            cell.playBtn.tag = indexPath.section
            cell.playBtn.addTarget(self, action: #selector(playClicked), for: .touchUpInside)
            
            // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
            cell.vwCarousel.activityIndicator = DefaultActivityIndicator()
            cell.vwCarousel.currentPageChanged = { page in
                //            print("current page:", page)
            }
            
            return cell
            
        }else if indexPath.section == 1{
            //MARK: KiKi Chat
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatHomeTableViewCell") as! ChatHomeTableViewCell
            cell.setupCell()
            cell.delegate = self
            cell.setChannels(for: chatInitPresenter.chatChannels)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! HomeTableViewCell
            cell.collectionVw.isHidden = false
            let channel = channelList[indexPath.section - 1]
            cell.collectionVw.tag = channel.id
            cell.collectionVw.reloadData()
            return cell
        }
    }
    
    
    func selectNotify() {
        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        self.homeViewModel.getEpisodeList(programID: Int(notifyInstance.content_id)!, offset: 0, programType: "vob", getEpisodeListCallFinished: { (status, error, userInfo) in
            if status {
                DispatchQueue.main.async(execute: {
                    if (self.homeViewModel.episodeList.count > 0) {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        //                            self.parentView.title = "Back"
                        let episodesViewController = storyboard.instantiateViewController(withIdentifier: "SMEpisodesViewController") as! SMEpisodesViewController
                        let program = notifyInstance.list
                        episodesViewController.program = program
                        episodesViewController.episodeList = self.homeViewModel.episodeList
                        //self.present(episodesViewController, animated: true, completion: nil)
                        self.navigationController?.pushViewController(episodesViewController, animated: true)
                        ProgressView.shared.hide()
                        self.view.isUserInteractionEnabled = true
                        
                    } else {
                        ProgressView.shared.hide()
                        self.view.isUserInteractionEnabled = true
                    }
                })
            } else {
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
                self.view.isUserInteractionEnabled = true
            }
        })
    }
    
    @objc func playClicked(sender: UIButton ) {
        self.view.isUserInteractionEnabled = false
        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! SideShowTableViewCell
        if (self.viewModel.carousalProgramList.count > 0){
            var selectedProgram = self.viewModel.carousalProgramList[0]
            if (cell.vwCarousel.currentPage <= self.viewModel.carousalProgramList.count) {
                // handle sudden taps on banner before loading the banner connted ( kid's modde)
                selectedProgram = self.viewModel.carousalProgramList[cell.vwCarousel.currentPage]
            }
            print("SelectedEdi: ", selectedProgram.id)
            self.viewModel.getEpisodeList(programID: selectedProgram.id, offset: 0, programType:"", getEpisodeListCallFinished: { (status, error, userInfo) in
                if status {
                    DispatchQueue.main.async(execute: {
                        if (self.viewModel.episodeList.count > 0) {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let episodesViewController = storyboard.instantiateViewController(withIdentifier: "SMEpisodesViewController") as! SMEpisodesViewController
                            episodesViewController.program = selectedProgram
                            episodesViewController.episodeList = self.viewModel.episodeList
                            //self.present(episodesViewController, animated: true, completion: nil)
                            self.navigationController?.pushViewController(episodesViewController, animated: true)
                            self.view.isUserInteractionEnabled = true
                            
                        } else {
                            ProgressView.shared.hide()
                            self.view.isUserInteractionEnabled = true
                        }
                    })
                } else {
                    self.view.isUserInteractionEnabled = true
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
}


//MARK: -UICollectionViewDatasource
extension HomeTableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if MyListShow == false {
            let programList = viewModel.programList
            let stringID = "\(collectionView.tag)"
            
            
            guard let number = viewModel.newCategroyProg[stringID]
            else {
                return 0
            }
            let totalProgram = (number as! NSArray).mutableCopy()
            if programList.isEmpty {
                return 0
            } else{
                return (totalProgram as AnyObject).count
            }
        } else {
            if subscribedListViewModel.programList.isEmpty {
                return 0
            } else {
                return subscribedListViewModel.programList.count
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerVw", for: indexPath) as! HeaderCollectionReusableView
        if MyListShow == true {
            headerView.headerLbl.text = NSLocalizedString("MY_LIST".localized(using: "Localizable"), comment: "")
            return headerView
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if MyListShow == false {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:collectionViewCellIdentifier , for: indexPath) as! HomeCollectionViewCell
            cell.tag = collectionView.tag
            configureCell(cell, indexPath: indexPath)
            return cell
        } else {
            let cell = collectionViewMyList.dequeueReusableCell(withReuseIdentifier:collectionViewCellIdentifier , for: indexPath) as! HomeCollectionViewCell
            cell.tag = collectionViewMyList.tag
            configureCell(cell, indexPath: indexPath)
            return cell
        }
    }
    
    fileprivate func configureCell(_ cell: HomeCollectionViewCell, indexPath: IndexPath) {
        if MyListShow == false {
            let stringID = "\(cell.tag)"
            guard let number = viewModel.newCategroyProg[stringID]
            else {
                return
            }
            
            
            let programList = number as! NSArray
            
            let program = programList[indexPath.row] as! Program
            
            cell.videoImageView.image = nil
            cell.videoImageView.image = UIImage(named: "logo_grayscale_video")
            let imageURL = program.image ?? ""
            let imageLink = imageURL.removingPercentEncoding ?? ""
            cell.videoImageView.contentMode = .scaleAspectFill
            cell.videoImageView.sd_setImage(with: URL(string: imageLink), placeholderImage: UIImage(named: "logo_grayscale_video"))
            
        } else {
            if subscribedListViewModel.programList.isEmpty {
                
            } else {
                func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
                    URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
                        (data, response, error) -> Void in
                        DispatchQueue.main.async(execute: {
                            cell.videoImageView.contentMode = contentMode
                            if let data = data {
                                if case let cellToUpdate as HomeCollectionViewCell = self.collectionViewMyList.cellForItem(at: indexPath) {
                                    cellToUpdate.videoImageView?.image = UIImage(data: data)
                                }
                            }
                        })
                    }).resume()
                }
                let program = subscribedListViewModel.programList[indexPath.row]
                cell.videoImageView.image = UIImage(named: "logo_grayscale_video")
                cell.videoImageView.contentMode = .scaleAspectFit
                cell.videoImageView.kf.setImage(with: URL(string: program.image!.removingPercentEncoding!)!)
                //                downloadImageFrom(link: program.image?.removingPercentEncoding ?? "", contentMode: UIView.ContentMode.scaleAspectFill)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if MyListShow == false {
            
            self.view.isUserInteractionEnabled = false
            ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
            
            let stringID = "\(collectionView.tag)"
            guard let number = viewModel.newCategroyProg[stringID]
            else {
                return
            }
            
            let programList = number as! NSArray
            let program = programList[indexPath.row] as! Program
            
            if notifyInstance.status {
                if program.id == Int(notifyInstance.content_id)! {
                    notifyInstance.list = program
                }
            }
            
            self.homeViewModel.getEpisodeList(programID: program.id, offset: 0, programType: program.type, getEpisodeListCallFinished: { (status, error, userInfo) in
                if status {
                    DispatchQueue.main.async(execute: {
                        if (self.homeViewModel.episodeList.count > 0) {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let episodesViewController = storyboard.instantiateViewController(withIdentifier: "SMEpisodesViewController") as! SMEpisodesViewController
                            
                            episodesViewController.program = program;
                            episodesViewController.episodeList = self.homeViewModel.episodeList
                            self.navigationController?.pushViewController(episodesViewController, animated: true)
                            ProgressView.shared.hide()
                            self.view.isUserInteractionEnabled = true
                            
                        } else {
                            ProgressView.shared.hide()
                            self.view.isUserInteractionEnabled = true
                        }
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        ProgressView.shared.hide()
                    })
                    self.view.isUserInteractionEnabled = true
                }
            })
        } else {
            self.view.isUserInteractionEnabled = false
            ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
            
            let program = subscribedListViewModel.programList[indexPath.row]
            
            let episodeNameString = program.episode?.name
            let programNameString = program.name
            
            print(episodeNameString ?? "")
            print(programNameString)
            
            homeViewModel.getEpisodeList(programID: program.id, offset: 0, programType: program.type , getEpisodeListCallFinished: { (status, error, userInfo) in
                if status {
                    DispatchQueue.main.async(execute: {
                        if (self.homeViewModel.episodeList.count > 0){
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let episodesViewController = storyboard.instantiateViewController(withIdentifier: "SMEpisodesViewController") as! SMEpisodesViewController
                            episodesViewController.episodeList = self.homeViewModel.episodeList
                            episodesViewController.program = program
                            self.navigationController?.pushViewController(episodesViewController, animated: true)
                            ProgressView.shared.hide()
                            self.view.isUserInteractionEnabled = true
                        } else {
                            ProgressView.shared.hide()
                            self.view.isUserInteractionEnabled = true
                        }
                    })
                } else {
                    ProgressView.shared.hide()
                    self.view.isUserInteractionEnabled = true
                }
            })
        }
    }
}

extension HomeTableViewController:ChatPickerViewDelegate{
    
    private func initializeChat(for channel:ChatChannel){
        ProgressView.shared.show(self.view)
        chatInitPresenter.initializeChat(for: channel) { (isCompleted) in
            ProgressView.shared.hide()
            if isCompleted{
                let chatNavController = UIHelper.makeViewController(in: .Chat, viewControllerName: .ChatNC) as! UINavigationController
                chatNavController.modalPresentationStyle = .fullScreen
                ChatViewController.channel = channel
                self.present(chatNavController, animated: true, completion: nil)
            }else{
                //TODO: Error for initialization failure
            }
        }
    }
    
    func didChatChannelTapped(for channel: ChatChannel) {
        ChatManager.shared.channelSID = channel.sid
        if channel.isBlocked{
            let blockedAlert = UIAlertController(title: "Access Revoked", message: "Your accees to this chat has been revoked due to inappropriate behavior", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            blockedAlert.addAction(okAction)
            self.present(blockedAlert, animated: true, completion: nil)
        }else{
            if channel.isMember{
                initializeChat(for: channel)
            }else{
                chatInitPresenter.createMember(for: channel) { (isCompleted) in
                    if isCompleted{
                        self.initializeChat(for: channel)
                    }else{
                        Log("Member creation failed")
                    }
                }
            }
        }
        
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func downloadedImg(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

