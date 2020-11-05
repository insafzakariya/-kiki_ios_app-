//
//  IAPManager.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 11/1/20.
//

import Foundation
import StoreKit

typealias ProductsRequestCompletionHandler = (_ success:Bool,_ products:[SKProduct]?)->Void

class IAPManager:NSObject{
    
    static let shared = IAPManager()
    let client = ApiClient()
    
    private var localServerPackages:[String:Int] = [:]
    private var productRequest:SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private var purchasedProduct:SubscriberProduct?
    private var activatedPackageName:String?
    
    private override init() {
        super.init()
    }
    
    var canPurchase:Bool{
        SKPaymentQueue.canMakePayments()
    }
    
    var productIDs:Set<String>!{
        didSet{
            requestProduct { (success, products) in
                if success{
                    SubscriberProduct.subscriberProdcuts = SubscriberProduct.convert(from: products!, localServerPackages: self.localServerPackages, selectedProducID: self.activatedPackageName)
                }
                
            }
        }
    }
    
    
    func buyProduct(product:SubscriberProduct){
        purchasedProduct = product
        Log("Buying \(product.product.productIdentifier)")
        let payment = SKPayment(product: product.product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func requestProduct(_ onComplete:@escaping ProductsRequestCompletionHandler){
        if canPurchase{
            productRequest?.cancel()
            productsRequestCompletionHandler = onComplete
            productRequest = SKProductsRequest(productIdentifiers: productIDs!)
            productRequest!.delegate = self
            productRequest!.start()
        }else{
            //TODO:
            Log("IAP is disabled")
        }
    }
    
}

extension IAPManager:SKProductsRequestDelegate{
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        Log("Retrieveing products")
        let products = response.products
        productsRequestCompletionHandler?(true,products)
        clearRequestAndHandler()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        Log(error.localizedDescription)
        productsRequestCompletionHandler?(false,nil)
        clearRequestAndHandler()
    }
    
    func clearRequestAndHandler(){
        productRequest = nil
        productsRequestCompletionHandler = nil
    }
}

extension IAPManager:SKPaymentTransactionObserver{
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
            case .failed:
                fail(transaction: transaction)
            case .restored:
                restore(transaction: transaction)
            default:()
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        Log("Purchase Completed")
        SKPaymentQueue.default().finishTransaction(transaction)
        activatePackage(planID: purchasedProduct!.packageID)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        Log("Restored purchase \(productIdentifier)")
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        Log("Purchasing Failed")
        if let transactionError = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
            Log("Transaction Error: \(localizedDescription)")
        }
        self.deliverErrorNotification(for: "Package activation failed")
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotification() {
        NotificationCenter.default.post(name: .DidTransactionUpdated, object: purchasedProduct?.product.productIdentifier )
    }
    
    private func deliverErrorNotification(for error:String){
        NotificationCenter.default.post(name: .DidTransactionFailed, object: error )
    }
}

typealias IAPServices = IAPManager
extension IAPServices{
    
    func getPackages(){
        client.getIAPPackages { (packages) in
            self.localServerPackages = packages 
            self.productIDs = Set(packages.keys)
        }
    }
    
    func activatePackage(planID:Int){
        client.activatePackage(packageID: planID) { isSuccess in
            if isSuccess{
                self.deliverPurchaseNotification()
                self.purchasedProduct = nil
            }else{
                self.deliverErrorNotification(for: "Package activation was not successful")
            }
            
        }
    }
    
    func getSubscribedPackage(onComplete:@escaping ()->()){
        client.getSubscriptionStatus { name in
            self.activatedPackageName = name
            onComplete()
        }
    }
}
