//
//  ChatViewController.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-06.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var sendButtonHolderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var headerView: ChatHeaderView!
    
    static var channel:ChatChannel?
    fileprivate let chatPresenter = ChatPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupUI()
        setupData()
        
        ChatManager.shared.delegate = self
        
        tableView.register(UINib(nibName: "ChatMessageTableViewCell", bundle: .main), forCellReuseIdentifier: "chatMessageTableViewCell")
        tableView.register(UINib(nibName: "SenderTableViewCell", bundle: .main), forCellReuseIdentifier: "senderTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func setupHeader(){
        headerView.delegate = self
        headerView.setupUI(for: .Main, for: ChatViewController.channel!)
        headerView.navigationController = self.navigationController
        headerView.hideCountLabel()
        
        chatPresenter.getArtists(for: ChatViewController.channel!) { (count) in
            self.headerView.setOnlineCount(for: count)
            self.headerView.showCountLabel()
        }
    }
    
    private func setupUI(){
        textView.backgroundColor = .white
        UIHelper.addCornerRadius(to: textView, withRadius: 10.0)
        UIHelper.circular(view: sendButtonHolderView)
        UIHelper.circular(view: sendButton)
    }
    
    private func setupData(){
        ProgressView.shared.show(self.view)
        chatPresenter.updateMembers(for: ChatViewController.channel!)
        
        chatPresenter.getMessages{
            ProgressView.shared.hide()
            self.tableView.reloadData()
            self.scrollToBottomMessage()
        }
        
    }
    
    private func scrollToBottomMessage() {
        if chatPresenter.messages.count == 0 {return}
        let bottomMessageIndex = IndexPath(row: chatPresenter.messages.count - 1,section: 0)
        tableView.scrollToRow(at: bottomMessageIndex, at: .bottom, animated: true)
    }
    
    @IBAction func sendButtonOnTapped(_ sender: Any) {
        chatPresenter.sendMessage(message: textView.text){ isSuccess in
            if isSuccess{
                self.textView.text = ""
            }
        }
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

extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatPresenter.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chatPresenter.messages[indexPath.row]
        if let member = ChatMember.getMember(from: chatPresenter.allUsers ?? [], for: message.senderID){
            if member.viewerID == UserDefaultsManager.getUserId(){
                let cell = tableView.dequeueReusableCell(withIdentifier: "senderTableViewCell") as! SenderTableViewCell
                cell.setupCell(for: message, sender: member)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "chatMessageTableViewCell") as! ChatMessageTableViewCell
                cell.setupCell(for: message, sender: member)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}

extension ChatViewController:ChatManagerDelegate{
    
    func reloadMessages() {
        self.tableView.reloadData()
    }
    
    func receivedNewMessage(message:ChatMessage) {
        chatPresenter.messages.append(message)
        reloadMessages()
        scrollToBottomMessage()
    }
    
    func memberUpdated() {
        chatPresenter.updateMembers(for: ChatViewController.channel!)
    }
}
