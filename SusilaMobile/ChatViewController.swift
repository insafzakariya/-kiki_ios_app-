//
//  ChatViewController.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-06.
//

import UIKit

class ChatViewController: UIViewController {
    
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
