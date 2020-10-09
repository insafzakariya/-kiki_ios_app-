//
//  SMPackageTableViewCell.swift
//  SusilaMobile
//
//  Created by Isuru_Jayathissa on 5/22/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class SMPackageTableViewCell: UITableViewCell {
    @IBOutlet weak var packageName: UILabel!

    @IBOutlet weak var packageIcon: UIImageView!

    class func identifier() -> String {
        return "SMPackageTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.responds(to: #selector(setter: UIView.layoutMargins))  {
            self.layoutMargins =  UIEdgeInsets.zero
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
