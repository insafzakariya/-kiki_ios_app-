//
//  ChatCollectionViewCell.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-03.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var chatImageView: UIImageView!
    
    func setupCell(){
        //TODO: Bind with model
        setupUI()
    }
    
    private func setupUI(){
        UIHelper.circular(view: chatImageView)
    }
    
}
