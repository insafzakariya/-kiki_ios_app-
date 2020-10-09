//
//  SMChannelCollectionViewCell.swift
//  SusilaMobile
//
//  Created by Isuru_Jayathissa on 10/11/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class SMChannelCollectionViewCell: UICollectionViewCell {
    
//    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var videoImageView: CachedImageView!
    
    
    class func identifier() -> String {
        return "SMChannelCollectionViewCell"
    }
    
}
