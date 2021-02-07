//
//  ChatViewController.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-06.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var sendButtonHolderView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var headerView: ChatHeaderView!
    static var channel:ChatChannel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupUI()
    }
    
    private func setupHeader(){
        headerView.delegate = self
        headerView.setupUI(for: .Main, for: ChatViewController.channel!)
        headerView.navigationController = self.navigationController
    }
    
    private func setupUI(){
        UIHelper.addCornerRadius(to: textView, withRadius: 10.0)
        UIHelper.circular(view: sendButtonHolderView)
        UIHelper.circular(view: sendButton)
    }
    
    
    deinit {
        ChatViewController.channel = nil
    }
    
}

extension ChatViewController:ChatHeaderDelegate{
    
    func infoButtonOnTapped() {
        let chatInfoVC = UIHelper.makeViewController(in: .Chat, viewControllerName: .ChatInfoVC) as! ChatInfoViewController
        chatInfoVC.channel = ChatViewController.channel
        self.navigationController?.pushViewController(chatInfoVC, animated: true)
    }
}
