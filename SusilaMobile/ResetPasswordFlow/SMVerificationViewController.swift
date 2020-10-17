//
//  SMVerificationViewController.swift
//  SusilaMobile
//
//  Created by Admin on 9/12/19.
//  Copyright © 2019 Kiroshan T. All rights reserved.
//

import UIKit

class SMVerificationViewController: UIViewController {
    
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
        borderLayer.frame = CGRect(x: 0, y: codeText.frame.size.height - 1, width:  codeText.frame.width, height: 2)
        codeText.layer.addSublayer(borderLayer)
    }
    
    fileprivate func smsCodeVerify(viwerId: String, otp: String) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        if let smsCodeString = codeText.text, !smsCodeString.isEmpty {
            codeText.resignFirstResponder()
            self.resetViewModel.passwordResetCodeSend(viwer_id:viwerId, otp:otp, onComplete: { (status, error) in
                if status {
                    self.goToResetView()
                } else {
                    ProgressView.shared.hide()
                    let alert = UIHelper.getAlert(title:"Invalid Code",message: "Looks like you have entered an expired or an invalid code. Please resend a new code.")
                    let resendAction = UIAlertAction(title: "Resend Code", style: .default) { _ in
                        self.resendCode()
                    }
                    alert.addAction(resendAction)
                    self.present(alert, animated: true, completion: nil)
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
            UIHelper.makeOKAlert(title: "", message: NSLocalizedString("OTP_CHARACTERS".localized(using: "Localizable"), comment: ""), viewController: self)
        } else {
            smsCodeVerify(viwerId: String(mainInstance.viwerId), otp: codeText.text!)
        }
    }
    
    @IBAction func resendCodeButtonPressed(_ sender: Any) {
        resendCode()
    }
    
    private func resendCode(){
        if let num = UserDefaultsManager.getMobileNo(){
            Log("Mobile number retrieved from UserDef: \(num)")
            resendSmsCodeVerify(number: num)
        }else{
            Log("Couldn't get the user Mobile No", type: .CRITICAL)
        }
    }
    
    fileprivate func resendSmsCodeVerify(number: String) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        self.resendViewModel.passwordResetCodeRequest(genre:number,onComplete: { (status, error) in
            if status {
                ProgressView.shared.hide()
            } else {
                ProgressView.shared.hide()
            }
        })
    }
}
