//
//  ChatInfoViewController.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-06.
//

import UIKit

class ChatInfoViewController: UIViewController {

    @IBOutlet weak var headerView: ChatHeaderView!
    var channel:ChatChannel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        
    }
    
    private func setupHeader(){
        headerView.setupUI(for: .Info, for: channel!)
        headerView.navigationController = self.navigationController
    }
}


