//
//  SMEpisodesTableViewCell.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 3/6/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit
import SDWebImage

class SMEpisodesTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var playingIndicationImg: UIImageView!
    
    class func identifier() -> String {
        return "SMEpisodesTableViewCell"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
