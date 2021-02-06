//
//  ChatHeader.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-01-30.
//

import UIKit


enum ChatViewType{
    case Main
    case Info
}

protocol ChatHeaderDelegate {
    func infoButtonOnTapped()
}

class ChatHeaderView: UIView {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var onlineCountLabel: UILabel!
    @IBOutlet weak var onlineIndicatorView: UIView!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonWidthConstraint: NSLayoutConstraint!
    
    var delegate:ChatHeaderDelegate?
    var navigationController:UINavigationController?
    let backButtonWidth:CGFloat = 36.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("Header", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        let titleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chatTitleOnTapped))
        chatNameLabel.addGestureRecognizer(titleTapGestureRecognizer)
        
    }
    
    func setupUI(for type:ChatViewType,for channel:ChatChannel){
        UIHelper.circular(view: chatImageView)
        UIHelper.circular(view: onlineIndicatorView)
        chatImageView.kf.setImage(with: channel.imageURL)
        switch type {
        case .Main:
            UIHelper.show(view: infoButton)
            UIHelper.hide(view: infoImageView)
            hideBackButton()
        case .Info:
            UIHelper.hide(view: infoButton)
            UIHelper.show(view: infoImageView)
            showBackButton()
        }
    }
    
    private func hideBackButton(){
        UIHelper.hide(view: backButton)
        backButtonWidthConstraint.constant = 0
    }
    
    private func showBackButton(){
        UIHelper.show(view: backButton)
        backButtonWidthConstraint.constant = backButtonWidth
    }
    
    @IBAction func backButtonOnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeButtonOnTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func infoButtonOnTapped(_ sender: Any) {
        delegate?.infoButtonOnTapped()
    }
    
    @objc func chatTitleOnTapped(){
        delegate?.infoButtonOnTapped()
    }
}
