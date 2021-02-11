//
//  ChatGifMessageTableViewCell.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-02.
//

import UIKit

class ChatGifMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var verfiedImageView: UIImageView!
    @IBOutlet var gifHolderView: UIView!
    @IBOutlet var gifImageView: UIImageView!
    
    func setupCell(for message:ChatMessage, sender:ChatMember){
        setupUI()
        UIHelper.circular(view: userImageView)
        usernameLabel.textColor = sender.color
        
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
        
        if message.content.lowercased().starts(with: "http"){
            downloadGif(from: message.content) { (image) in
                DispatchQueue.main.async {
                    self.gifImageView.image = image
                }
            }
        }else{
            fatalError("Invalid Cell Shown")
        }
        gifHolderView.backgroundColor = sender.color
    }
    
    private func setupUI(){
        UIHelper.addCornerRadius(to: gifHolderView,withRadius: 12.0)
    }
    
    private func downloadGif(from url:String,onComplete:@escaping(UIImage?)->()){
        DispatchQueue.global(qos: .background).async {
            let image = UIImage.gifImageWithURL(url)
            onComplete(image)
        }
        
    }
    
    deinit{
        gifImageView.image = nil
    }
    
}
