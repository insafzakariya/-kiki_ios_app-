//
//  SMVerificationViewController.swift
//  SusilaMobile
//
//  Created by Admin on 9/12/19.
//  Copyright © 2019 Kiroshan T. All rights reserved.
//

import UIKit

class SMVerificationViewController: BaseViewController {
    
    fileprivate let resetViewModel = SMVerificationViewModel()
    fileprivate let resendViewModel = SMResetViewModel()
    
    var fromVerificationResetViewController : String = ""
    
    @IBOutlet weak var codeText: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var lblConfirmPhoneNo: UILabel!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    
    override func viewDidLoad() {
        if navigationController?.isNavigationBarHidden == true {
            backBtn.isHidden = false
        } else{
            if fromVerificationResetViewController != "true" {
                backBtn.isHidden = true
            }
        }
        lblConfirmPhoneNo.text = NSLocalizedString("PLEASE_CONFIRM_YOUR_CODE".localized(using: "Localizable"), comment: "")
        hiLabel.text = NSLocalizedString("A_CONFIRMATION_CODE_HAS_BEEN_SENT_TO_YOUR_NUMBER".localized(using: "Localizable"), comment: "")+mainInstance.userName
        btnReset.setTitle(NSLocalizedString("RESET_PASSWORD".localized(using: "Localizable"), comment: ""), for: .normal)
        btnResend.setTitle(NSLocalizedString("RESEND_CODE".localized(using: "Localizable"), comment: ""), for: .normal)
        
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.white.cgColor
        borderLayer.frame = CGRect(x: 0, y: codeText.frame.size.height - 1, width:  codeText.frame.width+60, height: 2)
        codeText.layer.addSublayer(borderLayer)
    }
    
    fileprivate func smsCodeVerify(viwerId: String, otp: String) {
        
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        
        if let smsCodeString = codeText.text, !smsCodeString.isEmpty {
            codeText.resignFirstResponder()
            
            self.resetViewModel.passwordResetCodeSend(viwer_id:viwerId, otp:otp, callFinished: { (status, error) in
                if status {
                    self.goToResetView()
                    
                } else {
                    self.alert(message: "Invalid OTP, Please enter valid OTP number.")
                    ProgressView.shared.hide()
                }
            })
            
        } else{
            ProgressView.shared.hide()
            Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("ENTER_VALID_MOBILENO", comment: ""), perent: self)
        }
    }
    
    func goToResetView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resetViewController = storyboard.instantiateViewController(withIdentifier: "SMNewPasswordController") as! SMNewPasswordController
        self.navigationController?.pushViewController(resetViewController, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resetViewController = storyboard.instantiateViewController(withIdentifier: "SMResetViewController") as! SMResetViewController
        self.navigationController?.pushViewController(resetViewController, animated: true)
    }
    
   
    @IBAction func resetPasswordPressed(_ sender: Any) {
        print(mainInstance.viwerId, codeText.text!)
        if codeText.text!.count != 4 {
            self.alert(message: NSLocalizedString("OTP_CHARACTERS".localized(using: "Localizable"), comment: ""))
        } else {
            smsCodeVerify(viwerId: String(mainInstance.viwerId), otp: codeText.text!)
        }
        
    }
    
    @IBAction func resendCodeButtonPressed(_ sender: Any) {
        var num = mainInstance.mobileNo
        num.remove(at: num.startIndex)
        resendSmsCodeVerify(number: num)
    }
    
    fileprivate func resendSmsCodeVerify(number: String) {
        
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        
        self.resendViewModel.passwordResetCodeRequest(genre:number,callFinished: { (status, error) in
            if status {
                ProgressView.shared.hide()
            } else {
                ProgressView.shared.hide()
                
            }
        })
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
