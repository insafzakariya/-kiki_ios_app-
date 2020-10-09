//
//  MenuChiledViewController.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 2/17/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class MenuChiledViewController: UIViewController {

    override func viewDidLoad() {
        
//        let btn1 = UIButton(type: .custom)
//        btn1.setImage(UIImage(named: "menuIcon"), for: .normal)
//        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
//        btn1.addTarget(self, action: #selector(self.tappedMenubutton(_:)), for: .touchUpInside)
//        let item1 = UIBarButtonItem(customView: btn1)
//        
//        self.navigationItem.setLeftBarButtonItems([item1], animated: true)
        
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - Actions
    
    func tappedMenubutton(_ sender:AnyObject?)
    {
        //        hideKeyboard()
        let elDrawer: KYDrawerController = (UIApplication.shared.delegate as! AppDelegate).getRootViewController();
        elDrawer.setDrawerState(KYDrawerController.DrawerState.opened, animated: true)
    }

}
