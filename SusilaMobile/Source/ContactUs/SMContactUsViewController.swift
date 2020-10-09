//
//  SMContactUsViewController.swift
//  SusilaMobile
//
//  Created by Isuru_Jayathissa on 5/6/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import MessageUI

class SMContactUsViewController: MenuChiledViewController {

    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var emailAddressBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(backAction))
        
        self.title = "Contact"

    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc func backAction(){
        let view = self.navigationController?.popViewController(animated: true)
        print(view ?? "")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        enableTPButtons()
        //NotificationCenter.default.addObserver(self,
                                            ///   selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)),
                                             //  name: UIApplication.didBecomeActiveNotification,
                                              // object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let attributes = [NSUnderlineStyleAttributeName : 1] as [String : Any]
//        let phoneNumberButtonTitle = NSMutableAttributedString(string:phoneNumberString!, attributes:attributes)
//        let emailButtonTitle = NSMutableAttributedString(string:emailAddressString!, attributes:attributes)
//        phoneNumber.setAttributedTitle(phoneNumberButtonTitle, for: .normal)
//        emailAddressBtn.setAttributedTitle(emailButtonTitle, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func applicationDidBecomeActive(_ notification: Notification){
        
        enableTPButtons()
    }
    
    private func enableTPButtons(){
        phoneNumber.isEnabled = true
        
    }
    
    @IBAction func tappedTelephoneButton(_ sender: Any) {
//        let phoneNumberString = phoneNumber.titleLabel!.text!
        
        phoneNumber.isEnabled = false
        if Common.callNumber(phoneNumber: "+94117696300"){
            
        }
        
    }

    @IBAction func tappedEmailButton(_ sender: Any) {
        //"care@kiki.lk"
    
       let supportEmail = "abc@xyz.com"
        let appURL = URL(string: "mailto:TEST@EXAMPLE.COM")!
        if let emailURL = URL(string: "mailto:\(supportEmail)"), UIApplication.shared.canOpenURL(emailURL)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
        }
        
        /*func configuredMailComposeViewController(emailString: String) -> MFMailComposeViewController {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
            
            mailComposerVC.setToRecipients([emailString])
            //            mailComposerVC.setSubject("Sending you an in-app e-mail...")
            //            mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
            
            return mailComposerVC
        }
        
//        let emailString = (sender as! UIButton).title(for: .normal) ?? ""
        let mailComposeViewController = configuredMailComposeViewController(emailString: emailAddressString ?? "")
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
//            Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE", comment: ""), alertMessage: NSLocalizedString("EMAIL_SEND_ERROR", comment: ""))
        }*/
        
    }
}
