//
//  SettingViewController.swift
//  SusilaMobile
//
//  Created by Rashminda Bandara on 2/18/19.
//  Copyright © 2019 Isuru Jayathissa. All rights reserved.
//

import UIKit
import FirebaseRemoteConfig

class SettingViewController: UIViewController {
    
    @IBOutlet weak var hideVw: UIView!
    
    var remoteConfig:RemoteConfig = RemoteConfig.remoteConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppStoreManager.IS_ON_REVIEW{
            self.hideVw.isHidden = true
        }
        setupUI()
        //        goToHomeView()
    }
    
    private func setupUI(){
        // Do any additional setup after loading the view.
        self.title = "Setting"
        let menuButton = UIButton(type: .system)
        menuButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        menuButton.setImage(UIImage(named: "backIcon"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        menuButton.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    
    @objc func backAction(){
        (UIApplication.shared.delegate as! AppDelegate).goToCorrespondingHomeView(isAfterLogin: false)
    }
}
