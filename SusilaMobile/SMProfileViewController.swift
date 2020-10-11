//
//  SMProfileViewController.swift
//  SusilaMobile
//
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit


class SMProfileViewController:BaseViewController,CountryPickerDelegate,UIGestureRecognizerDelegate {
//    @IBOutlet weak var countryPicker: CountryPicker!
//    @IBOutlet weak var genderButton: UIButton!
//    @IBOutlet weak var languageButton: UIButton!
//    @IBOutlet weak var btnBirthDate: UIButton!
    @IBOutlet weak var mobileNoTextField: TextField!
    @IBOutlet weak var memberName: UITextField!
    @IBOutlet weak var memberEmail: UITextField!

    @IBOutlet weak var btnSelectCountry: UIButton!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var ivFlag: UIImageView!
    var strPhoneNumberOfUser = ""
    @IBOutlet weak var sinhalaImg: UIImageView!
    @IBOutlet weak var tamilImage: UIImageView!
    @IBOutlet weak var EnglishImage: UIImageView!
    @IBOutlet weak var sinhalaBtn: UIButton!
    @IBOutlet weak var tamilBtn: UIButton!
    @IBOutlet weak var englishBtn: UIButton!
    //    fileprivate let editInfoViewModel = SMProfileViewController()
    fileprivate var datePicker: UIDatePicker!
    
    fileprivate let registerInfoViewModel = SMRegisterInfoViewModel()
    var selectedGender : Gender = .None
    var selectedLanguage : Language = .None
    
    let z = 4, intervalString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.countryPicker.isHidden = true
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        tap.delegate = self
//        self.view.addGestureRecognizer(tap)
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(backAction))
        
        let menuButton = UIButton(type: .system)
        menuButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        menuButton.setImage(UIImage(named: "backIcon"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        menuButton.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)

        self.title = "Profile"
        
//        mobileNoTextField.underlined()
//        btnBirthDate.underlined()
//        genderButton.underlined()
//        languageButton.underlined()
        registerInfoViewModel.delegate = self
        
        if #available(iOS 9.0, *) {
            if mobileNoTextField.responds(to: #selector(getter: UIResponder.inputAssistantItem)){
                
                let inputAssistantItem = mobileNoTextField.inputAssistantItem
                inputAssistantItem.leadingBarButtonGroups = [];
                inputAssistantItem.trailingBarButtonGroups = [];
                
                
            }
        } else {
            // Fallback on earlier versions
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let locale = Locale.current
//        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        let strPhoneNumber = "\(UserDefaultsManager.getMobileNo() ?? "")"
        strPhoneNumberOfUser = strPhoneNumber
        mobileNoTextField.text = strPhoneNumber
        selectedLanguage = AuthUser.getLanguage(text: UserDefaultsManager.getLanguage()!)
        if selectedLanguage.rawValue == "SINHALA" {
            sinhalaImg.image = UIImage(named: "checkCircle")
            tamilImage.image = nil
            EnglishImage.image = nil
            
            //            sinhalaBtn.isEnabled = false
            //            tamilBtn.isEnabled = true
            //            englishBtn.isEnabled = true
            
        }
        else if selectedLanguage.rawValue == "TAMIL"{
            sinhalaImg.image = nil
            tamilImage.image = UIImage(named: "checkCircle")
            EnglishImage.image = nil
            
            //            sinhalaBtn.isEnabled = true
            //            tamilBtn.isEnabled = false
            //            englishBtn.isEnabled = false
        }
        else{
            sinhalaImg.image = nil
            tamilImage.image = nil
            EnglishImage.image = UIImage(named: "checkCircle")
       
        }
//        languageButton.setTitle(AuthUser.getLanguage(text: Preferences.getLanguage()!).rawValue, for: .normal)
        
//        mobileNoTextField.text = "\(Preferences.getMobileNo() ?? "")"
        
//        let dateFormatter = DateFormatter()
//
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        
//        if let strBirthDate = Preferences.getBirthDate()
//        {
//            let date = dateFormatter.date(from: strBirthDate)
//
//            dateFormatter.dateFormat = "dd MMM yyyy"
//            if date != nil{
//                let strDate = dateFormatter.string(from: date!)
//
//                btnBirthDate.setTitle(strDate, for: .normal)
//            }
//        }
//        else
//        {
//            btnBirthDate.setTitle("", for: .normal)
//        }
        memberName.text = "\(UserDefaultsManager.getUsername() ?? "")"
//        memeberEmail.text = "Welcome \(Preferences.() ?? "")"

    }
    
//    func donePicker(_ sender:UIBarButtonItem) -> Void {
//        self.countryPicker.isHidden = true
//
//    }
    
//    func cancelPicker(_ sender:UIBarButtonItem) -> Void {
//        self.countryPicker.isHidden = true
//    }
    
    // a picker item was selected
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        self.lblCode.text = phoneCode
//        self.ivFlag.image = flag
        
        
    }
    
    @IBAction func tappedLanguageButton(_ sender: AnyObject) {
        if sender.tag == 991{
            sinhalaImg.image = UIImage(named: "checkCircle")
            tamilImage.image = nil
            EnglishImage.image = nil

//            sinhalaBtn.isEnabled = false
//            tamilBtn.isEnabled = true
//            englishBtn.isEnabled = true

        }
        else if sender.tag == 992{
            sinhalaImg.image = nil
            tamilImage.image = UIImage(named: "checkCircle")
            EnglishImage.image = nil
            
//            sinhalaBtn.isEnabled = true
//            tamilBtn.isEnabled = false
//            englishBtn.isEnabled = false
        }
        else{
            sinhalaImg.image = nil
            tamilImage.image = nil
            EnglishImage.image = UIImage(named: "checkCircle")
            
//            sinhalaBtn.isEnabled = false
//            tamilBtn.isEnabled = false
//            englishBtn.isEnabled = true
        }
        mobileNoTextField.resignFirstResponder()
        
//        let languageList = [PopoverTableCellModel](arrayLiteral:
//            (PopoverTableCellModel(id: Language.SINHALA.hashValue, userId: 0, name: Language.SINHALA.rawValue, parentID: 0)),
//                                                   (PopoverTableCellModel(id: Language.TAMIL.hashValue, userId: 0, name: Language.TAMIL.rawValue, parentID: 0)),
//                                                   (PopoverTableCellModel(id: Language.ENGLISH.hashValue, userId: 0, name: Language.ENGLISH.rawValue, parentID: 0)))
//        
//        Common.shwoPopupTableView(listItem: languageList, sender: sender as! UIButton, objectTag: 2, viewController: self)
    }
    
    @IBAction func tappedNextButton(_ sender: AnyObject) {
        mobileNoTextField.resignFirstResponder()
        if memberName.text!.isEmpty
        {
            Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("ENTER_VALID_NAME".localized(using: "Localizable"), comment: ""))
        }
//        if lblCode.text!.isEmpty
//        {
//            Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("ENTER_VALID_COUNTRY".localized(using: "Localizable"), comment: ""))
//        }
//        else if ((btnBirthDate.titleLabel?.text) == nil)
//        {
//            Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("ENTER_VALID_BIRTHDATE".localized(using: "Localizable"), comment: ""))
//        }
        else
        {
            updateUserInfo()
        }
    }
    
    fileprivate func updateUserInfo() {
        
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        mobileNoTextField.resignFirstResponder()
        
        if sinhalaImg.image != nil{
            selectedLanguage = Language(rawValue: "SINHALA")!
        } else if tamilImage.image != nil{
            selectedLanguage = Language(rawValue: "TAMIL")!
        } else {
            selectedLanguage = Language(rawValue: "ENGLISH")!
        }
        
        registerInfoViewModel.updateUserDetails(mobileNo: mobileNoTextField.text!, country: lblCode.text!, birthdate:"1999-01-01" , gender: selectedGender, language: selectedLanguage)
    }
    
    // MARK: - Navigation
    fileprivate func goToVerificationView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let verificationViewController = storyboard.instantiateViewController(withIdentifier: "SMSVerificationViewController") as! SMSVerificationViewController
        self.navigationController?.pushViewController(verificationViewController, animated: true)
    }
    
    func connectionTimeoutMessage(){
        let alertTitle = NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: "")
        let alertMessage = NSLocalizedString("CONNECTION_TIME_OUT".localized(using: "Localizable"), comment: "")
        
        let alert = UIAlertController(title: alertTitle, message:alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: .default, handler: { (action) -> Void in
            self.updateUserInfo()
        }))
        showDetailViewController(alert, sender: nil)
    }

    
    @objc func backAction(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let verificationViewController = storyboard.instantiateViewController(withIdentifier: "settingVw") as! SettingViewController
        self.navigationController?.pushViewController(verificationViewController, animated: true)

//        let view = self.navigationController?.popViewController(animated: true)
//        print(view ?? "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func applicationDidBecomeActive(_ notification: Notification){
        
        enableTPButtons()
    }
    
    private func enableTPButtons(){
        
    }
    
//    @IBAction func btnSelectCountryClicked(_ sender: Any) {
//
//        self.countryPicker.isHidden = false
//
//    }
    

}
// MARK: - LoginDelegate
extension SMProfileViewController: RegisterInfoDelegate {
    func registerInfoCallFinished(_ status: Bool, error: NSError?, userInfo: [String: AnyObject]?) {
        ProgressView.shared.hide()
        if status {
            var phoneNo = (mobileNoTextField.text ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            if phoneNo.hasPrefix("0")
            {
                phoneNo.remove(at: phoneNo.startIndex)
            }
            
            phoneNo = lblCode.text! + phoneNo
            
            print(phoneNo)
            
            if (phoneNo == strPhoneNumberOfUser || phoneNo.hasPrefix("+94")) {
                
            } else {
                goToVerificationView()
            }
            Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("UPDATE_SUCCESS".localized(using: "Localizable"), comment: ""), perent: self)
            
        } else {
            if let error = error {
                switch error.code {
                case ResponseCode.noNetwork.rawValue:
                    Common.showAlert(alertTitle: NSLocalizedString("NO_INTERNET_ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: NSLocalizedString("NO_INTERNET_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""), perent: self)
                default:// 1017:
                    Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE".localized(using: "Localizable"), comment: ""), alertMessage: error.localizedDescription, perent: self)
                    
                    //                default: Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE", comment: ""), alertMessage: NSLocalizedString("ERROR_UNKNOW", comment: ""), perent: self)
                    
                }
            }
        }
    }
    
    
}

// MARK: - UITextFieldDelegate
extension SMProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case mobileNoTextField:
            mobileNoTextField.resignFirstResponder()
        default:()
        mobileNoTextField.resignFirstResponder()
        }
        
        return false
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        //        textFieldHightChangre.constant = 30
//        //        textField.layer.borderColor = kAPPThemeOrangeColor.cgColor
//        //
//        //        textField.layer.borderWidth = 1
//
////        let border = CALayer()
////        let width = CGFloat(1.0)
////        border.borderColor = kAPPThemeOrangeColor.cgColor
////        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
////
////        border.borderWidth = width
////        textField.layer.addSublayer(border)
////        textField.layer.masksToBounds = true
//    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
////        let border = CALayer()
////        let width = CGFloat(1.0)
////        border.borderColor = UIColor.white.cgColor
////        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
////
////        border.borderWidth = width
////        textField.layer.addSublayer(border)
////        textField.layer.masksToBounds = true
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if textField == mobileNoTextField
        {
            guard let text = textField.text else { return true }
            let count = text.count + string.count - range.length
            return count <= 10
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
//extension SMProfileViewController: UIPopoverPresentationControllerDelegate {
//    //    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
//    //        return .None
//    //    }
//
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        // return UIModalPresentationStyle.FullScreen
//        return UIModalPresentationStyle.none
//    }
//}

//extension SMProfileViewController: PopoverTableViewDelegate{
//
//    func didSelectPopoverTableView(_ popoverViewController: PopoverViewController, selectedIndexPath: IndexPath,item: PopoverTableCellModel?){
//
//        if popoverViewController.objectTag == 1{
//            if let item = item{
//                genderButton.setTitle("\(item.name)", for: UIControlState())
//                print("\(item.name)")
//                selectedGender = AuthUser.getGenderFromName(text: "\(item.name)")
//
//                //getGenderFromHashValue(hashVal: item.id)
//            }
//        }else if popoverViewController.objectTag == 2{
//            if let item = item{
//                languageButton.setTitle("\(item.name)", for: UIControlState())
//                selectedLanguage = AuthUser.getLanguageFromHashValue(hashVal: item.id)
//
//
//            }
//        }
//
//    }
//
//    func didTappedSubFilterButton(_ sender: UIButton){
//
//    }
//
//
//
//}


