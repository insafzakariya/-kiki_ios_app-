//
//  SMSVerificationViewController.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/26/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class SMSVerificationViewController: BaseViewController {

    @IBOutlet weak var textFieldHightChangre: NSLayoutConstraint!
    @IBOutlet fileprivate var smsCodeTextField: UITextField!
    @IBOutlet fileprivate var doneButton: UIButton!
    
    fileprivate let smsVerificationViewModel = SMSVerificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        smsCodeTextField.underlined()
        smsVerificationViewModel.delegate = self
        
        if #available(iOS 9.0, *) {
            if smsCodeTextField.responds(to: #selector(getter: UIResponder.inputAssistantItem)){
                
                let inputAssistantItem = smsCodeTextField.inputAssistantItem
                inputAssistantItem.leadingBarButtonGroups = [];
                inputAssistantItem.trailingBarButtonGroups = [];
                
                
            }
        } else {
            // Fallback on earlier versions
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tappedDoneButton(_ sender: AnyObject) {
        smsCodeVerify()
    }
    
    fileprivate func smsCodeVerify() {
        
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        
        if let smsCodeString = smsCodeTextField.text, !smsCodeString.isEmpty {
            smsCodeTextField.resignFirstResponder()
            
            smsVerificationViewModel.smsCodeVerify(smsCode: smsCodeTextField.text ?? "")
            
            
        }else{
            ProgressView.shared.hide()
            Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("ENTER_VALID_SMSCODE", comment: ""), perent: self)
        }
    }
    
    // MARK: - Navigation
    fileprivate func goToHomeView() {
        
        (UIApplication.shared.delegate as! AppDelegate).gotoHomeView()
    }
    

}




// MARK: - LoginDelegate
extension SMSVerificationViewController: SMSVerificationDelegate {
    func smsVerificationCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?) {
        ProgressView.shared.hide()
        if status {
            goToHomeView()
        } else {
            if let error = error {
                switch error.code {
                case ResponseCode.noNetwork.rawValue:
                    Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""), perent: self)
                    
                case ResponseCode.userAlreadyRegistered.rawValue:
                    Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                    
                case ResponseCode.inValidCredentials.rawValue:
                    Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                case ResponseCode.Verificationfailed.rawValue:
                    let alert = UIAlertController(title: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action) -> Void in
                        let view = self.navigationController?.popViewController(animated: true)
                        print(view ?? "")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    //                case 1001, 1003, 1031:
                    //                    Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE", comment: ""), alertMessage: error.localizedDescription, perent: self)
                    
                default: Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                    
                }

            }
        }
    }
    
    
}

// MARK: - UITextFieldDelegate
extension SMSVerificationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case smsVerificationViewModel:
//            smsCodeTextField.resignFirstResponder()
//        default:()
            smsCodeTextField.resignFirstResponder()

        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        textFieldHightChangre.constant = 30
        //        textField.layer.borderColor = kAPPThemeOrangeColor.cgColor
        //
        //        textField.layer.borderWidth = 1
        
//        let border = CALayer()
//        let width = CGFloat(1.0)
//        border.borderColor = kAPPThemeOrangeColor.cgColor
//        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
//
//        border.borderWidth = width
//        textField.layer.addSublayer(border)
//        textField.layer.masksToBounds = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//<<<<<<< HEAD
//        textField.layer.borderColor = kAPPThemeWhiteColor//textField.layer.borderColor
//        textField.layer.borderWidth = 1
//=======
//        let border = CALayer()
//        let width = CGFloat(1.0)
//        border.borderColor = UIColor.white.cgColor
//        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
//        
//        border.borderWidth = width
//        textField.layer.addSublayer(border)
//        textField.layer.masksToBounds = true
//>>>>>>> df32938c5b5cfddbdb164428005f39f1d5a61c72
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
        if textField.tag == smsCodeTextField.tag {
            let quantityLength = 4
            if string.count == 0 {
                return true
            }
            
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // alternative: not case sensitive
            if prospectiveText.lowercased().range(of: "e") != nil {
                return false
            }else{
                return prospectiveText.isNumeric() &&
                    prospectiveText.count <= quantityLength
            }
            
        }
        
        return true
    }
    
}
