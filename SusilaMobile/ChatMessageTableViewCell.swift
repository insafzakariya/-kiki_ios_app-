//
//  ChatMessageTableViewCell.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-02.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var chatContentLabel: UILabel!
    @IBOutlet weak var verfiedImageView: UIImageView!
    
    
    //TODO: Data Bind
    private func setupUI(){
        UIHelper.circular(view: userImageView)
    }
    
}
