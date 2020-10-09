//
//  SMSettingsPageViewController.swift
//  SusilaMobile
//
//  Created by Meuru Muthuthanthri on 8/26/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class SMSettingsPageViewController: MenuChiledViewController {
    
    @IBOutlet weak var onBtn: UIButton!
    @IBOutlet weak var offBtn: UIButton!
    @IBOutlet weak var onImage: UIImageView!
    @IBOutlet weak var offImage: UIImageView!
    @IBOutlet weak var lblChildMode: UILabel!
    
//    @IBOutlet weak var kidsModeButton: UIButton!
    weak var kidsModeSetPasswordAction: UIAlertAction?
    
    fileprivate let packageViewModel = SMPackageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(backAction))
        lblChildMode.text = NSLocalizedString("CHILD_MODE".localized(using: "Localizable"), comment: "")
    }
    
    @objc func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
   
    
    @IBAction func tappedKidsModeButton(_ sender: Any) {
        let kidsMode = Preferences.getSettingKidsMode()
        if (kidsMode) {
            let alert = UIAlertController(title: "KiKi", message: NSLocalizedString("PleaseEnterPasswordToDeactivateChildMode".localized(using: "Localizable"), comment: ""), preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = ""
                textField.isSecureTextEntry = true
            }
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action: UIAlertAction!) in
                let password = alert.textFields![0].text
                
                if (password == Preferences.getKidsModePassword()){
                    Preferences.setSettingKidsModePassword("")
                    Preferences.setSettingKidsMode(false)
                    self.setKidsModeButtonText(false)
                    self.displaySimpleAlert(NSLocalizedString("ChildModeIsDeactivated".localized(using: "Localizable"), comment: ""))
                } else {
                   self.displaySimpleAlert("Invalid password")
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
           let alert = UIAlertController(title: "KiKi", message: NSLocalizedString("PleaseEnterPasswordToActivateChildMode".localized(using: "Localizable"), comment: "")+".\nPassword must be of minimum 4 characters length.", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { textField in
                textField.text = ""
                textField.isSecureTextEntry = true
                NotificationCenter.default.addObserver(self, selector: #selector(self.handleTextFieldTextDidChangeNotification(notification:)), name: UITextField.textDidChangeNotification, object: textField)
            })
            
            func removeTextFieldObserver() {
                NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: alert.textFields?[0])
            }
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action: UIAlertAction!) in
                let password = alert.textFields![0].text
                Preferences.setSettingKidsModePassword(password)
                Preferences.setSettingKidsMode(true)
                self.setKidsModeButtonText(true)
                self.displaySimpleAlert(NSLocalizedString("ChildModeIsActivated".localized(using: "Localizable"), comment: ""))
                removeTextFieldObserver()
            }))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .cancel, handler: {  (action: UIAlertAction!) in
                removeTextFieldObserver()
            }))
            alert.actions[0].isEnabled = false
            kidsModeSetPasswordAction = alert.actions[0]
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        kidsModeSetPasswordAction!.isEnabled = (textField.text?.count)! >= 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setKidsModeButtonText(Preferences.getSettingKidsMode())
    }
    
    func setKidsModeButtonText(_ kidsMode: Bool) {
//        kidsModeButton.setTitle(kidsMode ? "ON" : "OFF", for: .normal)
        if kidsMode {
            onImage.image = UIImage(named: "checkCircle")
            offImage.image = UIImage(named: "")
            onBtn.isEnabled = false
            offBtn.isEnabled = true

        }
        else{
            onImage.image = UIImage(named: "")
            offImage.image = UIImage(named: "checkCircle")
            onBtn.isEnabled = true
            offBtn.isEnabled = false

        }
    }
    
    func displaySimpleAlert(_ msg: String) {
        let alertController = UIAlertController(title: "KiKi", message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

