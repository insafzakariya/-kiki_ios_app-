//
//  SubscriptionViewController.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 11/1/20.
//

import UIKit
import FirebaseRemoteConfig

class SubscriptionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    
    
    let remoteConfig:RemoteConfig = RemoteConfig.remoteConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Subscriptions"
        
        tableView.register(UINib(nibName: "SubscribeItemTableViewCell", bundle: .main), forCellReuseIdentifier: UIConstant.Cell.SubscribeItemTableViewCell.rawValue)
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(termsAndConditionsOnTapped))
        termsAndConditionsLabel.addGestureRecognizer(termsTapGesture)
        
        let privacyPolicyTapGesture = UITapGestureRecognizer(target: self, action:  #selector(privacyPolicyOnTapped))
        privacyPolicyLabel.addGestureRecognizer(privacyPolicyTapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didPurchased(_:)), name: .DidTransactionUpdated, object: nil)
    }
    
    private func setupUI(){
        if let _ = self.navigationController{
            UIHelper.hide(view: backButton)
            backButton.isUserInteractionEnabled = false
        }else{
            UIHelper.show(view: backButton)
            backButton.isUserInteractionEnabled = true
        }
        
        if SubscriberProduct.isSubscribed(){
            cancelButtonHeightConstraint.constant = 48
            UIHelper.show(view: cancelButton)
        }else{
            cancelButtonHeightConstraint.constant = 0
            UIHelper.hide(view: cancelButton)
        }
    }
    
    @objc func termsAndConditionsOnTapped(){
        if let termsURLString = remoteConfig[termsAndConditionsKey].stringValue,
           let termsURL = URL(string: termsURLString){
            UIApplication.shared.open(termsURL)
        }
    }
    
    @objc func privacyPolicyOnTapped(){
        if let termsURLString = remoteConfig[licenseAgreementConfigKey].stringValue,
           let termsURL = URL(string: termsURLString){
            UIApplication.shared.open(termsURL)
        }
    }
    
    @IBAction func cancelButtonOnTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "itms-apps://apps.apple.com/account/subscriptions")!)
    }
    
    @IBAction func restoreButtonOnTapped(_ sender: Any) {
        IAPManager.shared.restorePurchase()
    }
    
    @IBAction func backButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

extension SubscriptionViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SubscriberProduct.subscriberProdcuts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = SubscriberProduct.subscriberProdcuts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstant.Cell.SubscribeItemTableViewCell.rawValue) as! SubscribeItemTableViewCell
        cell.subscriberProduct = product
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = SubscriberProduct.subscriberProdcuts[indexPath.row]
        ProgressView.shared.show(self.view)
        IAPManager.shared.buyProduct(product: product)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
}

//MARK: Local Push
extension SubscriptionViewController{
    
    @objc func didPurchased(_ notification:Notification){
        ProgressView.shared.hide()
        if let name = notification.object as? String{
            SubscriberProduct.updatePackage(for: name)
            tableView.reloadData()
        }
        UIHelper.makeSnackBar(title:"Subscription Activated!", message: "Please note that it will take around 15 minutes to get the updated content", type: .NORMAL)
        mainInstance.subscribeStatus = true
        UserDefaults.standard.set("false", forKey: "trailer_only")
    }
    
    
    @objc func didFailed(_ notification:Notification){
        ProgressView.shared.hide()
        if let errorMessage = notification.object as? String{
            UIHelper.makeSnackBar(message: errorMessage)
        }
    }
}
