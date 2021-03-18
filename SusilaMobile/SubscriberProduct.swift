//
//  SubscriberProduct.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 11/1/20.
//

import Foundation
import StoreKit

struct SubscriberProduct {
    
    static var subscriberProdcuts:[SubscriberProduct] = []
    var product:SKProduct
    var isSelected:Bool
    var packageID:Int
    var validityPeriod:Int
    
    
    static func convert(from products:[SKProduct],localServerPackages:[String:Int],localServerPackageDurations:[String:Int], selectedProducID:String? = nil) -> [SubscriberProduct]{
        var convertedArray:[SubscriberProduct] = []
        for product in products{
            if let productID = selectedProducID{
                if product.productIdentifier == productID{
                    let item = SubscriberProduct(product: product, isSelected: true,packageID: localServerPackages[product.productIdentifier]!, validityPeriod: localServerPackageDurations[product.productIdentifier]!)
                    convertedArray.append(item)
                }else{
                    let item = SubscriberProduct(product: product, isSelected: false,packageID: localServerPackages[product.productIdentifier]!, validityPeriod: localServerPackageDurations[product.productIdentifier]!)
                    convertedArray.append(item)
                }
            }else{
                let item = SubscriberProduct(product: product, isSelected: false,packageID: localServerPackages[product.productIdentifier]!, validityPeriod: localServerPackageDurations[product.productIdentifier]!)
                convertedArray.append(item)
            }
        }
        return convertedArray.sorted {$0.validityPeriod < $1.validityPeriod}
    }
    
    static func updatePackage(for selectedProdcutID:String){
        var convertedArray:[SubscriberProduct] = []
        for product in subscriberProdcuts{
            if product.product.productIdentifier == selectedProdcutID{
                let item = SubscriberProduct(product: product.product, isSelected: true,packageID: product.packageID, validityPeriod: product.validityPeriod)
                convertedArray.append(item)
            }else{
                let item = SubscriberProduct(product: product.product, isSelected: false,packageID: product.packageID, validityPeriod: product.validityPeriod)
                convertedArray.append(item)
            }
        }
        subscriberProdcuts = convertedArray
    }
    
    static func isSubscribed() -> Bool{
        var falseCount:Int = 0
        for product in subscriberProdcuts{
            if product.isSelected == false{
                falseCount += 1
            }
        }
        if falseCount == subscriberProdcuts.count{
            return false
        }else{
            return true
        }
    }
}
