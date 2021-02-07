//
//  ChatInfoViewController.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-06.
//

import UIKit

class ChatInfoViewController: UIViewController {

    @IBOutlet weak var headerView: ChatHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let chatInfoPresenter = ChatInfoPresenter()
    var channel:ChatChannel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        
        tableView.register(UINib(nibName: "ChatInfoTableViewCell", bundle: .main), forCellReuseIdentifier: "chatInfoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        chatInfoPresenter.getMembers(for: channel!) {
            self.tableView.reloadData()
        }
        
    }
    
    private func setupHeader(){
        headerView.setupUI(for: .Info, for: channel!)
        headerView.navigationController = self.navigationController
    }

}

extension ChatInfoViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatInfoPresenter.members?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let artist = chatInfoPresenter.members?[indexPath.row]{
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatInfoTableViewCell") as! ChatInfoTableViewCell
            cell.setValues(for: artist)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ChatInfoTitleview()
        headerView.setValues(for: .Online, count: chatInfoPresenter.members?.count ?? 0)
        return headerView
    }
    
    
    
    
    
    
}


