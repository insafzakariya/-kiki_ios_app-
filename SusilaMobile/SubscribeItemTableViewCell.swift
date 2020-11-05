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
            priceLabel.text = "$\(subscriberProduct.product.price.description) \(subscriberProduct.product.localizedTitle.lowercased())"
        }
    }
    
}
