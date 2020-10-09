//
//  popoverTableViewCell.swift
//  CAMS
//
//  Created by Isuru Jayathissa on 7/23/15.
//  Copyright (c) 2015 Isuru Jayathissa. All rights reserved.
//

import UIKit

class PopoverTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var tableCellLabel: UILabel!
    
    @IBOutlet weak var colorViewWidth: NSLayoutConstraint! //For condition rating in Inspection screen
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.gray
        
        self.selectedBackgroundView = bgColorView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    class func identifier() -> String {
        return "PopoverTableViewCell"
    }
}
