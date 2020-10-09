//
//  SMBaseViewController.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 2/8/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class SMHomeBaseViewController: UIViewController {

//    var overlayVC : AVPlayerOverlayVC!
//    weak var playerVC : AVPlayerVC!
    
    weak var playerHEVC : IJKVideoViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //        self.overlayVC.player.pause()
        stopPlayer()
        ProgressView.shared.hide()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        notificationCenter.addObserver(self,selector: #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)),name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func applicationDidEnterBackground(_ notification: Notification){
        
        stopPlayer()
        ProgressView.shared.hide()
    }
    
    func applicationWillEnterForeground(_ notification: Notification){
        
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func stopPlayer(){
//        if (self.playerVC) != nil{
//            if (self.playerVC.player) != nil{
//                if (self.playerVC.player?.currentItem != nil)
//                {
//                    if (self.playerVC.player?.rate == 0)
//                    {
//
//
//                    } else {
//                        self.playerVC.overlayVC.didPlayButtonSelected(nil)
//                    }
//                }
//            }
//
//        }

        
    }
    

}
