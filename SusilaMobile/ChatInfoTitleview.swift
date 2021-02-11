//
//  ChatInfoTitleview.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-01.
//

import UIKit

enum InfoViewType{
    case Online
    case Offline
}

class ChatInfoTitleview: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("InfoTitle", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    
    private func setupUI(for type:InfoViewType){
        UIHelper.circular(view: indicatorView)
        switch type {
        case .Online:
            titleLabel.text = "Online artists"
            indicatorView.backgroundColor = .green
        case .Offline:
            titleLabel.text = "Offline artists"
            indicatorView.backgroundColor = .gray
        }
    }
    
    func setValues(for type:InfoViewType,count:Int){
        countLabel.text = count.description
        setupUI(for: type)
    }

}
