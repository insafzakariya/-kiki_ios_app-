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
    
    
    func setupCell(for message:ChatMessage, sender:ChatMember){
        UIHelper.circular(view: userImageView)
        if let url = sender.imageURL{
            userImageView.kf.setImage(with: url)
        }
        
        usernameLabel.textColor = sender.color
        //TODO: Gif loader
        chatContentLabel.text = message.content
        sender.type == .Artist ? UIHelper.show(view: verfiedImageView) : UIHelper.hide(view: verfiedImageView)
        
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.5
        chatContentLabel.backgroundColor = sender.color
       
        if sender.viewerID == UserDefaultsManager.getUserId(){
            chatContentLabel.textAlignment = .right
            UIHelper.hide(view: usernameLabel)
            UIHelper.hide(view: userImageView)
        }else{
            UIHelper.show(view: usernameLabel)
            UIHelper.show(view: userImageView)
            usernameLabel.text = sender.name
            chatContentLabel.textAlignment = .left
        }
        setupUI()
    }
    
    private func setupUI(){
        chatContentLabel.bounds = CGRect(x: chatContentLabel.bounds.minX, y: chatContentLabel.bounds.minY, width: chatContentLabel.bounds.width + 10.0, height: chatContentLabel.bounds.height + 10)
        chatContentLabel.layer.masksToBounds = true
        UIHelper.addCornerRadius(to: chatContentLabel)
    }
}
