//
//  AdvertisementViewController.swift
//  SusilaMobile
//
//  Created by Meuru Muthuthanthri on 7/21/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import Foundation


class AdvertisementViewController: UIView {
    @IBOutlet weak var topLeft: UIView!
    @IBOutlet weak var topRight: UIView!
    @IBOutlet weak var scroll: UIView!
    @IBOutlet weak var fullScreen: UIView!
    
    @IBOutlet weak var topLeftImage: UIImageView!
    @IBOutlet weak var topRightImage: UIImageView!
    @IBOutlet weak var scrollImage: UIImageView!
    @IBOutlet weak var fullScreenImage: UIImageView!
    
    var delegatePlayer:IJKMediaPlayback? = nil
    
    var advertiesemntsToDisplay: [AdvertisementModel] = []
    var isFullScreenClickableAdvertisementVisibile: Bool = false
    @objc
    var isFullScreenAdvertisementVisibile: Bool = false
    
    var videoViewController: UIViewController?
    
    @objc
    func showAdvertisement(advertisements: [AdvertisementModel], delegatePlayer: IJKMediaPlayback) {
        self.delegatePlayer = delegatePlayer
        
        stopDisplayingAdvertisements()
        if advertisements.isEmpty {
            stopDisplayingAdvertisements()
        } else {
            self.advertiesemntsToDisplay = advertisements
            for ad in advertisements {
                let imageView = getImageView(position: ad.position)
                imageView.af_setImage(withURL: URL(string: ad.imageURL.removingPercentEncoding!)!)
            }
            
            displayAdvertisements()
        }
    }
    
    @objc
    func advertisementTapped(uiViewContoroller: UIViewController) {
        if (isFullScreenClickableAdvertisementVisibile) {
            var fullScreenAdvertisement:AdvertisementModel? = nil
            for ad in advertiesemntsToDisplay {
                if (ad.position == AdvertisementPosition.full_screen) {
                    fullScreenAdvertisement = ad
                }
            }
            if (fullScreenAdvertisement != nil) {
                if (fullScreenAdvertisement?.webUrl.elementsEqual("app://subscriptions.kiki.lk"))! {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "SMPackagePageViewController") as! SMPackagePageViewController
                    let navigationController = UINavigationController(rootViewController: controller)
                    navigationController.navigationBar.tintColor = UIColor.white
                    navigationController.navigationBar.barTintColor = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
                    navigationController.navigationBar.isTranslucent = false
                    navigationController.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue:UIColor.white])
                    self.videoViewController = uiViewContoroller
                    uiViewContoroller.present(navigationController, animated: true, completion: {() -> Void in
                        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(self.back))
                    } )
                } else {
                    UIApplication.shared.openURL(URL(string: (fullScreenAdvertisement?.webUrl)!)!)
                }
            }
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        (UIApplication.shared.delegate as! AppDelegate).gotoHomeView()
    }
    
    func webView(shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if navigationType == UIWebView.NavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
    
    @objc
    func stopDisplayingAdvertisements() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(displayAdvertisements), object: nil)
        topLeftImage.isHidden = true
        topRightImage.isHidden = true
        scrollImage.isHidden = true
        fullScreenImage.isHidden = true
        
        self.isFullScreenClickableAdvertisementVisibile = false
        self.isFullScreenAdvertisementVisibile = false
    }
    
    @objc func displayAdvertisements() {
        let currentTime = Int((self.delegatePlayer?.currentPlaybackTime)!)
        for ad in advertiesemntsToDisplay {
            let imageView = getImageView(position: ad.position)
            if (ad.startTime <= currentTime && currentTime <= ad.startTime + ad.duration) {
                imageView.isHidden = false
                if (ad.stopMainContent) {
                    self.delegatePlayer?.pause()
                }
                if (ad.position == AdvertisementPosition.full_screen) {
                    self.isFullScreenAdvertisementVisibile = true
                    if (ad.clickAction) {
                        self.isFullScreenClickableAdvertisementVisibile = true
                    }
                }
            } else {
                imageView.isHidden = true
                if (ad.position == AdvertisementPosition.full_screen) {
                    self.isFullScreenAdvertisementVisibile = false
                    self.isFullScreenClickableAdvertisementVisibile = false
                }
            }
        }
        self.perform(#selector(displayAdvertisements), with: nil, afterDelay: 1)
    }
    
    func getImageViewdd(position: AdvertisementPosition) -> UIImageView {
        switch position {
        case .top_left:
            return self.topLeftImage
        case .top_right:
            return self.topRightImage
        case .scroll:
            return self.scrollImage
        case .full_screen:
            return self.fullScreenImage
        default:
            return self.fullScreenImage
        }
    }
    
    func getImageView(position: AdvertisementPosition) -> UIImageView {
        switch position {
        case .top_left:
            return self.topLeftImage
        case .top_right:
            return self.topRightImage
        case .scroll:
            return self.scrollImage
        case .full_screen:
            return self.fullScreenImage
        default:
            return self.fullScreenImage
        }
    }
}
