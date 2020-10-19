//
//  SMRegisterInfoViewController.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/19/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import Firebase
import PhoneNumberKit

class SMRegisterInfoViewController: BaseViewController,CountryPickerDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var ivFlag: UIImageView!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var countryPicker: CountryPicker!
    @IBOutlet weak var textFieldHightChangre: NSLayoutConstraint!
    @IBOutlet fileprivate var mobileNoTextField: UITextField!
    @IBOutlet fileprivate var birthdateButton: UIButton!
    @IBOutlet fileprivate var genderButton: UIButton!
    @IBOutlet fileprivate var languageButton: UIButton!
    @IBOutlet fileprivate var nextButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var countryCodeButton: UIButton!
    fileprivate var datePicker: UIDatePicker!
    
    fileprivate let registerInfoViewModel = SMRegisterInfoViewModel()
    var regionCode: String = ""
    var selectedGender : Gender = .None
    var selectedLanguage : Language = .None
    var fromRegisterVwe : String = ""
    let z = 4, intervalString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setText()
        if navigationController?.isNavigationBarHidden == true {
            backBtn.isHidden = false
        }
        else{
        if fromRegisterVwe != "true"{
            backBtn.isHidden = true
        }
        }
//        mobileNoTextField.underlined()
        mobileNoTextField.setLeftPaddingPoints(10)

//        var phoneNum = Preferences.getMobeCode() ?? ""
        var phoneNum = "\(UserDefaultsManager.getMobileNo() ?? "")"
        var countryCode: String? = nil
        do {
            let phoneNumber = try PhoneNumberKit().parse(UserDefaultsManager.getMobileNo() ?? "", withRegion: PhoneNumberKit.defaultRegionCode(), ignoreType: true)
            phoneNum = "\(phoneNumber.nationalNumber)"
            countryCode = "+\(phoneNumber.countryCode)"
        } catch {
            if (phoneNum.hasPrefix("94")) {
                phoneNum = String(phoneNum.dropFirst(2))
            } else if (phoneNum.hasPrefix("+94")) {
                phoneNum = String(phoneNum.dropFirst(3))
            }
        }

        
        mobileNoTextField.text = phoneNum
//        print("wdada",Preferences.getMobeCode())
//        smsCodeTextField.text = Preferences.getMobeCode()
        registerInfoViewModel.delegate = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        mobileNoTextField.leftView = paddingView
        mobileNoTextField.leftViewMode = .always
        
        if #available(iOS 9.0, *) {
            if mobileNoTextField.responds(to: #selector(getter: UIResponder.inputAssistantItem)){
                
                let inputAssistantItem = mobileNoTextField.inputAssistantItem
                inputAssistantItem.leadingBarButtonGroups = [];
                inputAssistantItem.trailingBarButtonGroups = [];                
            }
        } else {
            // Fallback on earlier versions
        }
        
        //setCurrentUserName()
        self.countryPicker.isHidden = true
        
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
//        toolBar.sizeToFit()
//
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
//
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
        
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
    
    @objc func setText(){
        headingLabel.text = "EnterYourPhoneNumber".localized(using: "Localizable")
        mobileNoTextField.placeholder = "TypeYourNumber".localized(using: "Localizable")
        
        confirmBtn.setTitle("Confirm".localizedString, for: UIControl.State.normal)
        
        let color = UIHelper.colorWithHexString(hex: "#999999")
        mobileNoTextField.attributedPlaceholder = NSAttributedString(string: mobileNoTextField.placeholder ?? "", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : color]))
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if (lblCode.text! == "+94") {
            mobileNoTextField.placeholder = (UserDefaultsManager.getMobeCode()?.isEmpty)! ? "123456789" : UserDefaultsManager.getMobeCode()
        }
    }
    @IBAction func tappedBackButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verificationViewController = storyboard.instantiateViewController(withIdentifier: "SMRegisterViewController") as! SMRegisterViewController
        self.navigationController?.pushViewController(verificationViewController, animated: true)
        
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
    
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        self.lblCode.text = phoneCode
        self.regionCode = countryCode
        self.ivFlag.image = flag
        if (lblCode.text! == "+94" && mobileNoTextField.text == "") {
            mobileNoTextField.placeholder = (UserDefaultsManager.getMobeCode()?.isEmpty)! ? "123456789" : UserDefaultsManager.getMobeCode()
        }
    }
    
    func getPhoneNumber() -> String {
        var phoneNo = (mobileNoTextField.text ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if phoneNo.hasPrefix("0")
        {
            phoneNo.remove(at: phoneNo.startIndex)
            phoneNo = lblCode.text! + phoneNo
        }
        else if phoneNo.hasPrefix(lblCode.text!.replacingOccurrences(of: "+", with: ""))
        {
            phoneNo = "+" + phoneNo
        } else {
            phoneNo = lblCode.text! + phoneNo
        }
        return phoneNo
    }
    
    fileprivate func validateUpdateUserInfoForm() -> Bool {
        let phoneNo = getPhoneNumber()
    
//        genderButton.setTitle("Male", for: .normal)
//        birthdateButton.setTitle("22-01-2018", for: .normal)
//        17 Jan 1987
        let preferredLanguage = NSLocale.preferredLanguages[0]

        var language = ""
        if preferredLanguage == "si-LK"{
            language = "SINHALA"
        }
        else if preferredLanguage == "ta-LK"{
            language = "TAMIL"
        }
        else{
            language = "ENGLISH"
        }
        
        
        let validateInfo = registerInfoViewModel.validateRegisterInfo(gender: "Male", birthdate: "22 Jan 2019", language: language, country: lblCode.text, mobile: phoneNo, regionCode: regionCode)
        
        if validateInfo != StatusCode.passedValidation {
            let message = validateInfo.getFailedMessage()
            
            let alert = UIAlertController(title:"LOGIN_ERROR_ALERT_TITLE".localizedString, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK_BUTTON_TITLE".localizedString, style: .default, handler: { (action) -> Void in
                ProgressView.shared.hide()
            }))
            showDetailViewController(alert, sender: nil)
            
            return false
        }
        
        return true
    }
    
    //MARK: - IBAction Methods
    @IBAction func btnSelectCountryClicked(_ sender: Any) {
        view.endEditing(true)

        self.countryPicker.isHidden = false
        
    }
    
    @IBAction func tappedBirthdateButton(_ sender: AnyObject) {
        mobileNoTextField.resignFirstResponder()
        
        let viewDatePicker: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 180))
        viewDatePicker.backgroundColor = UIColor.clear
        
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 300, height: 180))
        datePicker.datePickerMode = UIDatePicker.Mode.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        let selectedDate = dateFormatter.date(from: birthdateButton.titleLabel?.text ?? "")
        if let selectedDate = selectedDate{
            datePicker.date = selectedDate
        }else{
            datePicker.date = Date()
        }
        
        datePicker.maximumDate = NSDate() as Date
        
        datePicker.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        viewDatePicker.addSubview(datePicker)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let detailPopoverViewController = storyboard.instantiateViewController(withIdentifier: "DetailPopoverViewController") as! DetailPopoverViewController
        
        detailPopoverViewController.preferredContentSize = CGSize(width: 300, height: 180)
        detailPopoverViewController.title = ""
        detailPopoverViewController.returnView = viewDatePicker
        detailPopoverViewController.modalPresentationStyle = .popover
        
        let popoverController = detailPopoverViewController.popoverPresentationController
        popoverController!.permittedArrowDirections = .up
        popoverController!.delegate = self
        popoverController!.sourceView = sender as! UIButton
        popoverController!.sourceRect = sender.bounds //CGRectMake(100,100,0,0)
        popoverController?.backgroundColor = UIColor.white///ThemeManager.ThemeColors.LighterGrayColor
        
        self.showDetailViewController(detailPopoverViewController, sender: nil)
        
        detailPopoverViewController.titleView.isHidden = true
        detailPopoverViewController.titleViewHeight.constant = 0
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        birthdateButton.setTitle(dateFormatter.string(from: sender.date), for: UIControl.State())
        
    }
    
    @IBAction func tappedGenderButton(_ sender: AnyObject) {
        mobileNoTextField.resignFirstResponder()
        
        let genderList = [PopoverTableCellModel](arrayLiteral: (PopoverTableCellModel(id: Gender.MALE.hashValue, userId: 0, name: Gender.MALE.rawValue, parentID: 0)),
                                                 (PopoverTableCellModel(id: Gender.FEMALE.hashValue, userId: 0, name: Gender.FEMALE.rawValue, parentID: 0)))
        
        Common.shwoPopupTableView(listItem: genderList, sender: sender as! UIButton, objectTag: 1, viewController: self)
    }
    @IBAction func tappedLanguageButton(_ sender: AnyObject) {
        
        mobileNoTextField.resignFirstResponder()
        
        let languageList = [PopoverTableCellModel](arrayLiteral:
            (PopoverTableCellModel(id: Language.SINHALA.hashValue, userId: 0, name: Language.SINHALA.rawValue, parentID: 0)),
            (PopoverTableCellModel(id: Language.TAMIL.hashValue, userId: 0, name: Language.TAMIL.rawValue, parentID: 0)),
            (PopoverTableCellModel(id: Language.ENGLISH.hashValue, userId: 0, name: Language.ENGLISH.rawValue, parentID: 0)))
        
        Common.shwoPopupTableView(listItem: languageList, sender: sender as! UIButton, objectTag: 2, viewController: self)
    }
    
    @IBAction func tappedNextButton(_ sender: AnyObject) {
        mobileNoTextField.resignFirstResponder()
        updateUserInfo()
    }
    
    fileprivate func updateUserInfo() {
       
        
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        
        if validateUpdateUserInfoForm() {
            if let token = Messaging.messaging().fcmToken {
                self.updateFCMToken(deviceId: token)
            }
            mobileNoTextField.resignFirstResponder()
            
            let phoneNo = getPhoneNumber()
            let countryCode = lblCode.text!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            let date = dateFormatter.date(from: "22 Jan 2019")
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let strDate = dateFormatter.string(from: date!)

//            registerInfoViewModel.requestMobileCode(mobileNo: phoneNo)

            
            //registerInfoViewModel.updateUserDetails(mobileNo: phoneNo, country: lblCode.text!, birthdate: strDate , gender: selectedGender, language: selectedLanguage)
            registerInfoViewModel.updateUserDetails(mobileNo: phoneNo, country: countryCode, birthdate: strDate , gender: selectedGender, language: selectedLanguage)


            
        }else{
            ProgressView.shared.hide()
        }
    }
    
    func updateFCMToken(deviceId: String) {
        SMLaunchViewController().updateFCMToken(deviceId: deviceId, updateFCMTokenCallFinished: { (status, error, userInfo) in
            if status{
                DispatchQueue.main.async(execute: {
                    print("FCM Token Updated")
                })
            }
        })
    }
    
    // MARK: - Navigation
    fileprivate func goToHomeView() {
        if (self.navigationController?.viewControllers.last(where: { $0 is SMProfileViewController })) != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            (UIApplication.shared.delegate as! AppDelegate).gotoHomeView()
        }
    }
    
    fileprivate func goToVerificationView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let verificationViewController = storyboard.instantiateViewController(withIdentifier: "SMSVerificationViewController") as! SMSVerificationViewController
        self.navigationController?.pushViewController(verificationViewController, animated: true)
    }
    
    func connectionTimeoutMessage(){
        let alertTitle = "ALERT_TITLE".localizedString
        let alertMessage = "CONNECTION_TIME_OUT".localizedString
        
        let alert = UIAlertController(title: alertTitle, message:alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL_BUTTON_TITLE".localizedString, style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "OK_BUTTON_TITLE".localizedString, style: .default, handler: { (action) -> Void in
            self.updateUserInfo()
        }))
        showDetailViewController(alert, sender: nil)
    }
}


// MARK: - LoginDelegate
extension SMRegisterInfoViewController: RegisterInfoDelegate {
    func registerInfoCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?) {
        ProgressView.shared.hide()
        if status {
            let remoteConfig = (UIApplication.shared.delegate as! AppDelegate).getRemoteConfig()
            if (self.lblCode.text == "+94" || !remoteConfig[enableSMSVerificationConfigKey].boolValue) {
                goToHomeView()
            } else {
                goToHomeView()
//                goToVerificationView()
            }
        } else {
            if let error = error {
                switch error.code {
                case ResponseCode.noNetwork.rawValue:
                    Common.showAlert(alertTitle: "NO_INTERNET_ALERT_TITLE".localizedString, alertMessage: "NO_INTERNET_ALERT_MESSAGE".localizedString, perent: self)
                default:// 1017:
                    Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE", comment: ""), alertMessage: error.localizedDescription, perent: self)
                    
//                default: Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE", comment: ""), alertMessage: NSLocalizedString("ERROR_UNKNOW", comment: ""), perent: self)
                    
                }
            }
        }
    }
    
    
}

// MARK: - UITextFieldDelegate
extension SMRegisterInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case mobileNoTextField:
            mobileNoTextField.resignFirstResponder()
        default:()
        mobileNoTextField.resignFirstResponder()
        }
        
        return false
    }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.countryPicker.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileNoTextField
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
extension SMRegisterInfoViewController: UIPopoverPresentationControllerDelegate {
    //    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    //        return .None
    //    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
}

extension SMRegisterInfoViewController: PopoverTableViewDelegate{
    
    func didSelectPopoverTableView(_ popoverViewController: PopoverViewController, selectedIndexPath: IndexPath,item: PopoverTableCellModel?){
        
        if popoverViewController.objectTag == 1{
            if let item = item{
                genderButton.setTitle("\(item.name)", for: UIControl.State())
                selectedGender = AuthUser.getGenderFromHashValue(hashVal: item.id)
            }
        }else if popoverViewController.objectTag == 2{
            if let item = item{
                languageButton.setTitle("\(item.name)", for: UIControl.State())
                selectedLanguage = AuthUser.getLanguageFromHashValue(hashVal: item.id)
                
            }
        }
        
    }
    
    func didTappedSubFilterButton(_ sender: UIButton){
        
    }
}

