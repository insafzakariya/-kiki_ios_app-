//
//  SMResetViewController.swift
//  SusilaMobile
//
//  Created by Admin on 9/9/19.
//  Copyright © 2019 Kiroshan T. All rights reserved.
//
import UIKit
import Crashlytics
import Firebase
import PhoneNumberKit

class SMResetViewController: BaseViewController,CountryPickerDelegate,UIGestureRecognizerDelegate {
    
    fileprivate let resetViewModel = SMResetViewModel()
    
    var fromLoginView : String = ""
    
    @IBOutlet weak var countryPicker: CountryPicker!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var phoneNoText: UITextField!
    @IBOutlet weak var countryHeightChanger: NSLayoutConstraint!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var lblOne: UILabel!
    @IBOutlet weak var lblTwo: UILabel!
    @IBOutlet weak var lblEnterPhoneNo: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    
    let z = 4, intervalString = ""
    var regionCode: String = ""
    
    override func viewDidLoad() {
       
        self.setText()
        if navigationController?.isNavigationBarHidden == true {
            backBtn.isHidden = false
        } else{
            if fromLoginView != "true" {
                backBtn.isHidden = true
            }
        }
        lblEnterPhoneNo.text = "EnterYourPhoneNumber".localized(using: "Localizable")
        lblOne.text = "A_CONFIRMATION_CODE_WILL_SENT".localized(using: "Localizable")
        lblTwo.text = "TO_YOUR_NUMBER_TO_RESET_THE_PASSWORD".localized(using: "Localizable")
        btnConfirm.setTitle("Confirm".localized(using: "Localizable"), for: .normal)
        
        phoneNoText.setLeftPaddingPoints(10)
        
        var phoneNum = "\(Preferences.getMobileNo() ?? "")"
        var countryCode: String? = nil
        do {
            let phoneNumber = try PhoneNumberKit().parse(Preferences.getMobileNo() ?? "", withRegion: PhoneNumberKit.defaultRegionCode(), ignoreType: true)
            phoneNum = "\(phoneNumber.nationalNumber)"
            countryCode = "+\(phoneNumber.countryCode)"
        } catch {
            if (phoneNum.hasPrefix("94")) {
                phoneNum = String(phoneNum.dropFirst(2))
            } else if (phoneNum.hasPrefix("+94")) {
                phoneNum = String(phoneNum.dropFirst(3))
            }
        }
        
        phoneNoText.text = phoneNum
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        phoneNoText.leftView = paddingView
        phoneNoText.leftViewMode = .always
        
        if #available(iOS 9.0, *) {
            if phoneNoText.responds(to: #selector(getter: UIResponder.inputAssistantItem)){
                
                let inputAssistantItem = phoneNoText.inputAssistantItem
                inputAssistantItem.leadingBarButtonGroups = [];
                inputAssistantItem.trailingBarButtonGroups = [];
            }
        } else {
            // Fallback on earlier versions
        }
        
        self.countryPicker.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true
        if (countryCode != nil) {
            countryPicker.setCountryByPhoneCode(countryCode!)
        } else {
            countryPicker.setCountry(code!)
        }
    }
    
    fileprivate func goToHomeView() {
        if (self.navigationController?.viewControllers.last(where: { $0 is SMProfileViewController })) != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            (UIApplication.shared.delegate as! AppDelegate).gotoHomeView()
        }
    }
    
    @objc func setText(){
        //headingLabel.text = "EnterYourPhoneNumber".localized(using: "Localizable")
        phoneNoText.placeholder = "TypeYourNumber".localized(using: "Localizable")
        
        //confirmBtn.setTitle("Confirm".localized(using: "Localizable"), for: UIControl.State.normal)
        
        let color = UIHelper.colorWithHexString(hex: "#999999")
        phoneNoText.attributedPlaceholder = NSAttributedString(string: phoneNoText.placeholder ?? "", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : color]))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (countryLabel.text! == "+94") {
            phoneNoText.placeholder = (Preferences.getMobeCode()?.isEmpty)! ? "123456789" : Preferences.getMobeCode()
        }
    }
    
    //MARK: - Tap Gesture Handler
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.countryPicker.isHidden = true
    }
    
    //MARK: - Country Code Picker
    func donePicker(_ sender:UIBarButtonItem) -> Void {
        self.countryPicker.isHidden = true
        
    }
    
    func cancelPicker(_ sender:UIBarButtonItem) -> Void {
        self.countryPicker.isHidden = true
    }
    
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        
        print(phoneCode, countryCode)
        
        self.countryLabel.text = phoneCode
        self.regionCode = countryCode
        
        self.countryImage.image = flag
        if (countryLabel.text! == "+94" && phoneNoText.text == "") {
            phoneNoText.placeholder = (Preferences.getMobeCode()?.isEmpty)! ? "123456789" : Preferences.getMobeCode()
        }
    }
    
    func getPhoneNumber() -> String {
        var phoneNo = (phoneNoText.text ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if phoneNo.hasPrefix("0")
        {
            phoneNo.remove(at: phoneNo.startIndex)
            phoneNo = countryLabel.text! + phoneNo
        }
        else if phoneNo.hasPrefix(countryLabel.text!.replacingOccurrences(of: "+", with: ""))
        {
            phoneNo = "+" + phoneNo
            
        } else {
            phoneNo = countryLabel.text! + phoneNo
            
        }
        phoneNo.remove(at: phoneNo.startIndex)
        return phoneNo
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "SMLoginViewController") as! SMLoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    
    @IBAction func countryCodePickerButtonPrssed(_ sender: Any) {
        
        view.endEditing(true)
        
        self.countryPicker.isHidden = false
    }
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        let phoneNo = getPhoneNumber()
        if phoneNo.contains("*") || phoneNo.contains("#"){
            print("Invalid mobile number, Please enter a valid mobile number")
        }
        smsCodeVerify(number: phoneNo)
        
    }
    
    fileprivate func smsCodeVerify(number: String) {
        
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        
        if let smsCodeString = phoneNoText.text, !smsCodeString.isEmpty {
            phoneNoText.resignFirstResponder()
            
            self.resetViewModel.passwordResetCodeRequest(genre:number,callFinished: { (status, error) in
                if status {
                    self.goToVerificationView()
                    
                } else {
                    self.alert(message: "It seems the mobile number you entered is incorrect or not registered with any existing username. Please type in the correct number.")
                    ProgressView.shared.hide()
                }
            })
            
        } else{
            ProgressView.shared.hide()
            Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("ENTER_VALID_MOBILENO", comment: ""), perent: self)
        }
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func goToVerificationView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "SMVerificationViewController") as! SMVerificationViewController
        loginViewController.fromVerificationResetViewController = "true"
        
        ProgressView.shared.hide()
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
}


// MARK: - UITextFieldDelegate
extension SMResetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case phoneNoText:
            phoneNoText.resignFirstResponder()
        default:()
        phoneNoText.resignFirstResponder()
        }
        
        return false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.countryPicker.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNoText
        {
            let nsText = textField.text! as NSString
            
            if range.length == 0 && canInsert(atLocation: range.location) {
                textField.text! = textField.text! + intervalString + string
                return false
            }
            
            if range.length == 1 && canRemove(atLocation: range.location) {
                textField.text! = nsText.replacingCharacters(in: NSMakeRange(range.location-1, 2), with: "")
                return false
            }
            
            let currentCharacterCount = textField.text?.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 10
        }
        else
        {
            return true
        }
    }
    
    func canInsert(atLocation y:Int) -> Bool { return ((1 + y)%(z + 1) == 0) ? true : false }
    
    func canRemove(atLocation y:Int) -> Bool { return (y != 0) ? (y%(z + 1) == 0) : false }
    
    
}

// MARK: - UIPopoverPresentationControllerDelegate
extension SMResetViewController: UIPopoverPresentationControllerDelegate {
    //    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    //        return .None
    //    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
}

