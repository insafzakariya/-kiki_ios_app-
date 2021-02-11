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
    @IBOutlet weak var bubbleView: UIView!
    
    func setupCell(for message:ChatMessage, sender:ChatMember){
        setupUI()
        UIHelper.circular(view: userImageView)
        usernameLabel.textColor = sender.color
        chatContentLabel.text = message.content
        usernameLabel.text = sender.name
        
        if sender.type == .Artist{
            UIHelper.show(view: verfiedImageView)
            if let imageURL = URL(string: String(format: ChatConfig.imageURL, sender.viewerID)){
                userImageView.kf.setImage(with: imageURL)
            }
        }else{
            userImageView.image = UIImage(named: "user")
            UIHelper.hide(view: verfiedImageView)
        }
        
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.5
        bubbleView.backgroundColor = sender.color
    }
    
    private func setupUI(){
        UIHelper.addCornerRadius(to: bubbleView,withRadius: 12.0)
    }
    
    
    
}
