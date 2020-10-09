//
//  SMResetSuccessController.swift
//  SusilaMobile
//
//  Created by Admin on 9/16/19.
//  Copyright © 2019 Kiroshan T. All rights reserved.
//

import UIKit

class SMResetSuccessController: BaseViewController {
    @IBOutlet weak var hiLabel: UILabel!
    
    override func viewDidLoad() {
        hiLabel.text = mainInstance.userName+" your password has been reset."
    }
        
    @IBAction func loginButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "SMLoginViewController") as! SMLoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
}
