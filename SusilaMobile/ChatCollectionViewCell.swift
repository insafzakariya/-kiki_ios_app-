//
//  ChatCollectionViewCell.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-03.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var chatImageView: UIImageView!
    
    func setupCell(for channel:ChatChannel){
        chatImageView.kf.setImage(with: channel.imageURL)
        setupUI()
    }
    
    private func setupUI(){
        UIHelper.circular(view: chatImageView)
    }
    
}
