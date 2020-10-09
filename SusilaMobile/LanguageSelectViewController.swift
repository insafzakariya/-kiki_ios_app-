//
//  LanguageSelectViewController.swift
//  SusilaMobile
//
//  Created by Rashminda Bandara on 1/21/19.
//  Copyright © 2019 Isuru Jayathissa. All rights reserved.
//

import UIKit
class LanguageSelectViewController: UIViewController {

    @IBOutlet weak var sinhalaBtn: UIButton!
    @IBOutlet weak var tamilBtn: UIButton!
    @IBOutlet weak var englishBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Localize.setCurrentLanguage("en")

    }
    @IBAction func sinhalaBtn(_ sender: UIButton) {
        sinhalaBtn.backgroundColor = UIColor.white
        tamilBtn.backgroundColor = colorWithHexString(hex: "#4D4D4D")
        englishBtn.backgroundColor = colorWithHexString(hex: "#4D4D4D")
        sinhalaBtn.setTitleColor(.black, for: .normal)
        tamilBtn.setTitleColor(.white, for: .normal)
        englishBtn.setTitleColor(.white, for: .normal)
    }
    @IBAction func tamilBtn(_ sender: UIButton) {
        sinhalaBtn.backgroundColor = colorWithHexString(hex: "#4D4D4D")
        tamilBtn.backgroundColor = UIColor.white
        englishBtn.backgroundColor = colorWithHexString(hex: "#4D4D4D")
        tamilBtn.setTitleColor(.black, for: .normal)
        englishBtn.setTitleColor(.white, for: .normal)
        sinhalaBtn.setTitleColor(.white, for: .normal)
    }
    @IBAction func engBtn(_ sender: UIButton) {
        sinhalaBtn.backgroundColor = colorWithHexString(hex: "#4D4D4D")
        tamilBtn.backgroundColor = colorWithHexString(hex: "#4D4D4D")
        englishBtn.backgroundColor = UIColor.white
        englishBtn.setTitleColor(.black, for: .normal)
        tamilBtn.setTitleColor(.white, for: .normal)
        sinhalaBtn.setTitleColor(.white, for: .normal)
    }
    @IBAction func nextSelected(_ sender: UIButton) {
        if sinhalaBtn.backgroundColor == UIColor.white{
            UserDefaults.standard.set("sinhala", forKey: "Language")

            Localize.setCurrentLanguage("si-LK")
        }
        else if tamilBtn.backgroundColor == UIColor.white{
            UserDefaults.standard.set("tamil", forKey: "Language")
            Localize.setCurrentLanguage("ta-LK")

        }
        else{
            UserDefaults.standard.set("english", forKey: "Language")
            Localize.setCurrentLanguage("en")
        }
        UserDefaults.standard.set("true", forKey: "LanguageSelect")

        UserDefaults.standard.synchronize()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // Remove the LCLLanguageChangeNotification on viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

}
