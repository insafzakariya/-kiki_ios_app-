//
//  MainHomeViewController.swift
//  SusilaMobile
//
//  Created by Rashminda Bandara on 1/24/19.
//  Copyright © 2019 Isuru Jayathissa. All rights reserved.
//

import UIKit
import ImageSlideshow

class MainHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var mainMenuViewController :SMMainMenuViewController!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var vwCarousel: ImageSlideshow!
    @IBOutlet weak var SubscriptionPromotionView: UIView!
    
    let viewModel = SMChannelListModel()
    var customSwitch: SMCustomSwitchAV!
    var isOn = false;
    var screenWidth:CGFloat = 320
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarItems()
    }
    
    private func setupNavigationBarItems() {
        
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        
        let notificationButton = UIButton(type: .system)
        notificationButton.setImage(#imageLiteral(resourceName: "notification").withRenderingMode(.alwaysOriginal), for: .normal)
        notificationButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        notificationButton.contentMode = .scaleAspectFit
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: Selector(("search")))
//        let searchButton = UIButton(type: .system)
//        searchButton.setImage(#imageLiteral(resourceName: "notification").withRenderingMode(.alwaysOriginal), for: .normal)
//        searchButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        searchButton.contentMode = .scaleAspectFit
        
        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(named: "menuIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        menuButton.contentMode = .scaleAspectFit
        
        navigationItem.rightBarButtonItems = [searchButton,UIBarButtonItem(customView: notificationButton)]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
//    override func tappedMenubutton(_ sender:AnyObject?)
//    {
//        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
//        elDrawer.setDrawerState(KYDrawerController.DrawerState.opened, animated: true)
//    }
    
    func notifcicationBtn(_ sender:AnyObject?)
    {
        let verificationViewController = storyboard?.instantiateViewController(withIdentifier: "SMNotificationViewController") as! SMNotificationViewController
        self.navigationController?.pushViewController(verificationViewController, animated: true)
    }
    
    func backAction(){
        let view = self.navigationController?.popViewController(animated: true)
        print(view ?? "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        vwCarousel.circular = true
        loadChannelImageList()
        loadChannelList();
    }
    
    func displaySubscriptionPromotionMessage() {
        self.SubscriptionPromotionView.isHidden = false
    }
    
    @IBAction func tappedSubscriptionPromotionCloseBtn(_ sender: Any) {
        self.SubscriptionPromotionView.isHidden = true
    }
    
    @IBAction func tappedSubscriptionPromotionSubscribeBtn(_ sender: Any) {
        self.SubscriptionPromotionView.isHidden = true
        mainMenuViewController.navigateToPackagePage()
    }
    
    func loadChannelImageList(){
        
        //        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        
        self.viewModel.getCarouselProgramList(getCarouselProgramListCallFinished: { (status, error, userInfo) in
            if status{
                
                DispatchQueue.main.async(execute: {
                    //                    ProgressView.shared.hide()
                    
                    if (self.viewModel.channelImageList.count > 0){
                        
                        self.vwCarousel.setImageInputs(self.viewModel.channelImageList)
                        
                    }else{
                        
                        //                        Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE", comment: ""), alertMessage: NSLocalizedString("EMPTY_LIST", comment: ""), perent: self)
                    }
                    
                })
            }else{
                
                DispatchQueue.main.async(execute: {
                    
                    //                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    
    func loadChannelList(){
        
        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        
        self.viewModel.getChannelList(getChannelListCallFinished: { (status, error, userInfo) in
            if status{
                
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                    
                    if (self.viewModel.channelList.count > 0){
                        
                        self.collectionView.isHidden = false
                        self.collectionView.reloadData()
                        
                    }else{
                        self.collectionView.isHidden = true
                        Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("EMPTY_LIST".localized(using: "Localizable"), comment: ""), perent: self)
                    }
                    
                })
            }else{
                
                DispatchQueue.main.async(execute: {
                    self.collectionView.isHidden = true
                    ProgressView.shared.hide()
                })
            }
        })
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //UICollectionViewDataSource Methods (Remove the "!" on variables in the function prototype)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if viewModel.channelList.isEmpty{
            return 0
        }else{
            return viewModel.channelList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        if indexPath.row == 0
        //        {
        //            return CGSize(width: screenWidth, height: screenWidth/3)
        //        }
        let width = ((screenWidth - 30)/3 - 5)
        return CGSize(width: width, height: width);
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell: SMChannelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SMChannelCollectionViewCell.identifier(), for: indexPath) as! SMChannelCollectionViewCell
        
        
        if viewModel.channelList.isEmpty{
            
        }else{
            
            let channel = viewModel.channelList[indexPath.row]
            //            cell.name.text = channel.name
            cell.videoImageView.image = nil
            cell.videoImageView.image = UIImage(named: "logo_grayscale_video")
            
            cell.videoImageView.contentMode = UIView.ContentMode.scaleAspectFit
            cell.videoImageView.loadImage(urlString: channel.image?.removingPercentEncoding ?? "")
            
        }
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if viewModel.channelList.isEmpty{
            
        }else{
            //            let url = URL(string: "http://220.247.201.162:1935/vod/smil:Test_171.smil/playlist.m3u8")
            //            IJKVideoViewController.present(from: self, withTitle: "test", url: url, completion: {
            //                self.navigationController?.popViewController(animated: true)
            //            })
            
            
            let channel = viewModel.channelList[indexPath.row]
            UserDefaultsManager.setChannelID(channel.id)
            UserDefaultsManager.setChannelName(channel.name)
        }
    }
}

