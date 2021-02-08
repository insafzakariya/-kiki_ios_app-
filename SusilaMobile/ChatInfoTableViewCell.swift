//
//  ChatInfoTableViewCell.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-01.
//

import UIKit

class ChatInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    
    
    func setValues(for artist:ChatMember){
        artistImageView.kf.setImage(with: artist.imageURL)
        artistName.text = artist.name
        setupUI(for: .Online, with: artist.color)
    }
    
    
    private func setupUI(for type:InfoViewType, with color:UIColor){
        UIHelper.circular(view: artistImageView)
        artistName.textColor = color
        type == .Online ? enableCellComponents() : disableCellComponents()
    }
    
    private func enableCellComponents(){
        UIHelper.enableView(view: artistName)
        UIHelper.enableView(view: artistImageView)
    }
    
    private func disableCellComponents(){
        UIHelper.disableView(view: artistName)
        UIHelper.disableView(view: artistImageView)
    }
    
    
}
