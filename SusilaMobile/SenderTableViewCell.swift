//
//  SenderTableViewCell.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-09.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    func setupCell(for message:ChatMessage, sender:ChatMember){
        setupUI()
        contentLabel.text = message.content
        bubbleView.backgroundColor = sender.color
    }
    
    private func setupUI(){
        UIHelper.addCornerRadius(to: bubbleView,withRadius: 12.0)
    }
    
    
}
