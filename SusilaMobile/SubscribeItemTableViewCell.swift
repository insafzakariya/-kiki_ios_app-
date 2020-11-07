//
//  SubscribeItemTableViewCell.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 11/1/20.
//

import UIKit

class SubscribeItemTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    
    var subscriberProduct:SubscriberProduct!{
        didSet{
            UIHelper.addCornerRadius(to: containerView)
            subscriberProduct.isSelected ? UIHelper.show(view: selectImageView) : UIHelper.hide(view: selectImageView)
            titleLabel.text = subscriberProduct.product.localizedTitle
            //Pay %@/3 months for exclusive content
//            priceLabel.text = "\(subscriberProduct.product.priceLocale.currencyCode ?? "USD") \(subscriberProduct.product.price.description) \(subscriberProduct.product.localizedTitle.lowercased())"
            let priceText = "\(subscriberProduct.product.priceLocale.currencyCode ?? "USD") \(subscriberProduct.product.price.description)"
            priceLabel.text = "\(String(format: subscriberProduct.product.localizedDescription, priceText))"
        }
    }
    
}
