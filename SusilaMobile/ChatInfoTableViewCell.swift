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
    
    //TOOD: Bind with model
    func setValues(){
        //TODO
//        setupUI(for: <#T##InfoViewType#>, with: <#T##UIColor#>)
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
