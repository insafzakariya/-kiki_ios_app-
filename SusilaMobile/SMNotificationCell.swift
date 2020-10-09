//
//  SMNotificationCell.swift
//  SusilaMobile
//
//  Created by Rashminda on 06/10/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class SMNotificationCell: UITableViewCell {
    let notificationListViewModel = NotificationListModel()
    var notificationID = 0;
//    @IBOutlet weak var vwBackground: UIView!
//    @IBOutlet weak var btnExpandToggle: UIButton!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
//    @IBOutlet weak var ivNotification: UIImageView!
    @IBOutlet weak var lblNotification: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.vwBackground.layer.borderColor = colorWithHexString(hex: "#00897B").cgColor
//        self.vwBackground.layer.borderWidth = 2.0
//        self.vwBackground.layer.masksToBounds = true
    }

    @IBAction func actExpandToggle(_ sender: UIButton) {
    }
//    @IBAction func actDelete(_ sender: UIButton) {
//        ProgressView.shared.show(self, mainText: nil, detailText: nil)
//        notificationListViewModel.clearNotification(notificationID:self.notificationID, clearNotificationCallFinished: { (status, error, userInfo) in
//            if status{
//
//                DispatchQueue.main.async(execute: {
//                    ProgressView.shared.hide()
//
////                    self.loadNotificationList();
//
//                })
//            }else{
//                DispatchQueue.main.async(execute: {
//                    ProgressView.shared.hide()
//                })
//            }
//        })
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
