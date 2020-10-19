//
//  DashboardViewController.swift
//  SusilaMobile
//
//  Created by MacBookSH on 12/5/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var constPlayerHeight: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var searchBarBtn: UIButton!
    
    let notificationButton = MIBadgeButton(type: .system)
    let notificationListViewModel = NotificationListModel()
    
    var home: HomeViewController?
    var allSongs: BrowseViewController?
    var playlist: LibraryViewController?
    var isOn = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
            } else {
                // Fallback on earlier versions
            }
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.tabBar.delegate = self
        self.tabBar.selectedItem = self.tabBar.items?.first
        if home == nil {
            home = HomeViewController(frame: UIScreen.main.bounds)
        }
        if let viewWithTag1 = self.mainView.viewWithTag(100) {
            viewWithTag1.removeFromSuperview()
        }
        if let viewWithTag2 = self.mainView.viewWithTag(101) {
            viewWithTag2.removeFromSuperview()
        }
        let tempUI = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tempUI.tag = 101
        home?.tag = 100
        self.mainView.addSubview(home ?? tempUI)
        
        initializeVCs()
        
        self.title = "Home"
        
        tabBar.items?[0].title = "Home"//"Home".localizedString
        tabBar.items?[1].title = "Browse"//"Browse".localizedString
        tabBar.items?[2].title = "Library"//"MySongs".localizedString
        
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor(red:0.00, green:0.61, blue:0.62, alpha:1.0), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width:tabBar.frame.size.width, height: 0.5))
        lineView.backgroundColor = Constants.color_separator
        tabBar.addSubview(lineView)
        
        let lineView2 = UIView(frame: CGRect(x: UIScreen.main.bounds.width/3, y: 0, width:0.5, height: tabBar.frame.height))
        lineView2.backgroundColor = Constants.color_separator
        tabBar.addSubview(lineView2)
        
        let lineView3 = UIView(frame: CGRect(x: (UIScreen.main.bounds.width/3)*2, y: 0, width:0.5, height: tabBar.frame.height))
        lineView3.backgroundColor = Constants.color_separator
        tabBar.addSubview(lineView3)
        
        playerView.backgroundColor = Constants.videoAppBackColor
        
        
        
        
//        self.allSongs?.loadAllSongs()
//        self.home?.loadPopularSongsList()
//        self.playlist?.loadAllPlaylists(view: self.view)
//        self.home!.playLists = (self.playlist?.playlistModel.globalPlayList)!
        
        playerView.btnClickExpand.addTarget(self, action: #selector(self.actExpand(_:)), for: UIControl.Event.touchUpInside)
        playerView.btnCollapse.addTarget(self, action: #selector(self.actCollapse(_:)), for: UIControl.Event.touchUpInside)

        playerView.dashboardVC = self
        // home!.playListController = self.playlist!
        // playlist!.homeVC = self.home!
        home?.parentVC = self
        //playlist?.parentVC = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.logoutNotificationReceived(notfication:)), name: Notification.Name("LogoutNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playNotificationReceived(notfication:)), name: Notification.Name("PlaySong"), object: nil)
        self.setupNowPlayingInfoCenter()
        
        
        
        notificationButton.setImage(#imageLiteral(resourceName: "notification").withRenderingMode(.alwaysOriginal), for: .normal)
        notificationButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        notificationButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: 0, right: 6)
        notificationButton.badgeTextColor = UIColor(red:0.22, green:0.50, blue:0.51, alpha:1.0)
        notificationButton.badgeBackgroundColor = UIColor.clear
        notificationButton.contentMode = .scaleAspectFit
        notificationButton.addTarget(self, action: #selector(notifcicationBtn), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: searchBarBtn), UIBarButtonItem(customView: notificationButton)]
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadNotificationList()
        if notifyInstance.content_type == "songid" {
           expendePlayerView()
        }
    }
    
    @objc func notifcicationBtn(_ sender:AnyObject?) {
        let verificationViewController = storyboard?.instantiateViewController(withIdentifier: "SMNotificationViewController") as! SMNotificationViewController
        self.navigationController?.pushViewController(verificationViewController, animated: true)
    }
    
    func loadNotificationList(){
        self.notificationListViewModel.getNotificationCount(getNotificationCountCallFinished: { (status, error, count) in
            if status {
                self.notificationButton.badgeString = count == 0 ? "" : "\(count ?? 0)"
            } else {
                self.notificationButton.badgeString = ""
            }
        })
    }
    
    @objc func logoutNotificationReceived(notfication: Notification) {
        stopPlayingMusic()
    }
    
    @objc func playNotificationReceived(notfication: Notification) {
        self.playerView.pause()
        self.playerView.currentPlayingList = [notfication.object as! Song]
        self.playerView.currentPlayingIndex = 0
        self.playerView.currentPlayingTime = 0
        if (playerView.currentPlayingList.count > 0){
            self.playerView.play()
        }
    }
    
    @IBAction func actExpand(_ sender: UIButton) {
        self.navigationController?.navigationBar.isHidden = false
        var top = CGFloat(0)
        if #available(iOS 11.0, *) {
            top = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? CGFloat(0)) + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat(0))
            
        }
        constPlayerHeight.constant = UIScreen.main.bounds.height - top
        if playerView.radioStatus == "radio" {
            playerView.addSongs.isHidden = true
            playerView.btnExpanNext.isHidden = true
            playerView.lblTotalTime.isHidden = true
            playerView.lblCurrentTime.isHidden = true
            playerView.progressSlider.isHidden = true
            playerView.btnExpanPrevious.isHidden = true
            playerView.btnExpanShuffle.isHidden = true
            playerView.btnExpanRepeat.isHidden = true
        } else {
            playerView.addSongs.isHidden = false
            playerView.btnExpanNext.isHidden = false
            playerView.lblTotalTime.isHidden = false
            playerView.lblCurrentTime.isHidden = false
            playerView.progressSlider.isHidden = false
            playerView.btnExpanPrevious.isHidden = false
            playerView.btnExpanShuffle.isHidden = false
            playerView.btnExpanRepeat.isHidden = false
        }
        playerView.expandedView.isHidden = false
    }
    
    func expendePlayerView() {
        self.navigationController?.navigationBar.isHidden = false
        var top = CGFloat(0)
        if #available(iOS 11.0, *) {
            top = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? CGFloat(0)) + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat(0))
            
        }
        constPlayerHeight.constant = UIScreen.main.bounds.height - top
        if playerView.radioStatus == "radio" {
            playerView.addSongs.isHidden = true
            playerView.btnExpanNext.isHidden = true
            playerView.lblTotalTime.isHidden = true
            playerView.lblCurrentTime.isHidden = true
            playerView.progressSlider.isHidden = true
            playerView.btnExpanPrevious.isHidden = true
            playerView.btnExpanShuffle.isHidden = true
            playerView.btnExpanRepeat.isHidden = true
        } else {
            playerView.addSongs.isHidden = false
            playerView.btnExpanNext.isHidden = false
            playerView.lblTotalTime.isHidden = false
            playerView.lblCurrentTime.isHidden = false
            playerView.progressSlider.isHidden = false
            playerView.btnExpanPrevious.isHidden = false
            playerView.btnExpanShuffle.isHidden = false
            playerView.btnExpanRepeat.isHidden = false
        }
        
         
        playerView.expandedView.isHidden = false
    }
    
    @IBAction func actCollapse(_ sender: UIButton) {
       hidePlayerFullView()
    }
    
    func initializeVCs() {
        if home == nil {
            home = HomeViewController(frame: UIScreen.main.bounds)
            home?.playerView = self.playerView
        }
        if allSongs == nil {
            allSongs = BrowseViewController(frame: UIScreen.main.bounds)
            allSongs?.parentVC = self
        }
        if playlist == nil {
            
            //playlist = LibraryViewController(frame: UIScreen.main.bounds)
            //playlist?.playerView = self.playerView
            //libraryController.parentVC = self

            
        }
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    @IBAction func tappedVideoButton(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        (UIApplication.shared.delegate as! AppDelegate).gotoHomeView()
        self.isOn = false
        stopPlayingMusic()
    }
    
    func stopPlayingMusic() {
        playerView.pause()
        MPRemoteCommandCenter.shared().playCommand.isEnabled = false
        UIApplication.shared.endReceivingRemoteControlEvents();
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
                switch item.tag {
        
                case 1:
                    if let viewWithTag1 = self.mainView.viewWithTag(100) {
                        viewWithTag1.removeFromSuperview()
                    }
                    if let viewWithTag2 = self.mainView.viewWithTag(101) {
                        viewWithTag2.removeFromSuperview()
                    }
                    let tempUI = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                    tempUI.tag = 101
                    home!.tag = 100
                    
                    home?.viewAllPopularSongs.isHidden = true
                    home?.viewAllLatestSongs.isHidden = true
                    home?.viewAllPopularArtists.isHidden = true
                    home?.viewBrowseArtist.isHidden = true
                    home?.viewAllLatestPlaylists.isHidden = true
                    home?.viewAllPopularArtistSongs.isHidden = true
                    home?.viewLatestPlaylistDetails.isHidden = true
                    
                    self.mainView.addSubview(home ?? tempUI)
                    self.title = "Home"//"Home".localizedString
                     hidePlayerFullView()
                    
                    break
        
        
                case 2:
                    if let viewWithTag1 = self.mainView.viewWithTag(100) {
                        viewWithTag1.removeFromSuperview()
                    }
                    if let viewWithTag2 = self.mainView.viewWithTag(101) {
                        viewWithTag2.removeFromSuperview()
                    }
                    let tempUI = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                    tempUI.tag = 101
                    allSongs!.tag = 100
                    
                    allSongs?.genreSeeAllView.isHidden = true
                    allSongs?.genreViewSeeAllArtist.isHidden = true
                    allSongs?.viewAllBrowseArtists.isHidden = true
                    allSongs?.viewAllSongs.isHidden = true
                    allSongs?.viewLatestPlaylistDetails.isHidden = true
                    allSongs?.vi.isHidden = true
                    allSongs?.genreView.isHidden = true
                    allSongs?.viewAllPlayList.isHidden = true
                    
                    self.mainView.addSubview(allSongs ?? tempUI)
                    self.title = "Browse"//"Browse".localizedString
                    
                    //let browseController = BrowseController()
                    //browseController.playerView = self.playerView
                    //self.addChild(browseController)
                    //self.mainView.addSubview(browseController.view)
                    hidePlayerFullView()
                    break
        
                case 3:
                    /*if let viewWithTag1 = self.mainView.viewWithTag(100) {
                        viewWithTag1.removeFromSuperview()
                    }
                    if let viewWithTag2 = self.mainView.viewWithTag(101) {
                        viewWithTag2.removeFromSuperview()
                    }
                    let tempUI = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                    tempUI.tag = 101
                    playlist!.tag = 100*/
                    //playlist?.constructPlaylists()
                        //self.mainView.addSubview(playlist ?? tempUI)
                    //LibraryController.playerView = self.playerView
                    let libraryController = LibraryController()
                    libraryController.playerView = self.playerView
                    self.addChild(libraryController)
                    self.mainView.addSubview(libraryController.view)
                    //self.title = "Library"
                    //self.title = "MySongs".localizedString
                    
                    
                    hidePlayerFullView()
                    break
        
                default:
                    if let viewWithTag1 = self.mainView.viewWithTag(100) {
                        viewWithTag1.removeFromSuperview()
                    }
                    if let viewWithTag2 = self.mainView.viewWithTag(101) {
                        viewWithTag2.removeFromSuperview()
                    }
                    let tempUI = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                    tempUI.tag = 101
                    home?.tag = 100
                    self.mainView.addSubview(home ?? tempUI)
                    self.title = "Home".localizedString
                    hidePlayerFullView()
                    break
        
                }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Log("Memory Warning Issued!")
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tappedMenuButton(_ sender: Any) {
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        elDrawer.setDrawerState(KYDrawerController.DrawerState.opened, animated: true)
    }
    
    private func setupNowPlayingInfoCenter() {
        UIApplication.shared.beginReceivingRemoteControlEvents();
        MPRemoteCommandCenter.shared().playCommand.removeTarget(nil)
        MPRemoteCommandCenter.shared().playCommand.addTarget {event in
            self.playerView.play()
            return .success
        }
        MPRemoteCommandCenter.shared().pauseCommand.removeTarget(nil)
        MPRemoteCommandCenter.shared().pauseCommand.addTarget {event in
            self.playerView.pause()
            return .success
        }
        MPRemoteCommandCenter.shared().nextTrackCommand.removeTarget(nil)
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget {event in
            self.playerView.next()
            return .success
        }
        MPRemoteCommandCenter.shared().previousTrackCommand.removeTarget(nil)
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget {event in
            self.playerView.prev()
            return .success
        }
    }
    
    @IBAction func tappedSearchButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        newViewController.playerView = self.playerView
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func hidePlayerFullView() {
        self.navigationController?.navigationBar.isHidden = false
        constPlayerHeight.constant = 70
        playerView.expandedView.isHidden = true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
