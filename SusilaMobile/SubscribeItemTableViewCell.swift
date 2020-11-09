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
            //Pay USD 10.00 / 6 months for exclusive content
            UIHelper.addCornerRadius(to: containerView)
            subscriberProduct.isSelected ? UIHelper.show(view: selectImageView) : UIHelper.hide(view: selectImageView)
            titleLabel.text = subscriberProduct.product.localizedTitle
            let description:String = subscriberProduct.product.localizedDescription
            let prefixText = "Pay \(subscriberProduct.product.priceLocale.currencyCode ?? "USD") \(subscriberProduct.product.price.description) /"
            let priceText = "\(prefixText) \(description)"
            priceLabel.text = priceText
        }
    }
    
}
