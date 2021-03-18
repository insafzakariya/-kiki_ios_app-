//
//  ChatViewController.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-06.
//

import UIKit
import WebKit

class ChatViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static var token:String!
    static var chatID:String!
    fileprivate let chatPresenter = ChatPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupWebView()
        loadChatView()
    }
    
    private func setupWebView(){
        webView.navigationDelegate = self
        webView.configuration.userContentController.add(self, name: chatPresenter.navDismissHandler)
    }
    
    private func loadChatView(){
        let url = chatPresenter.getChatWebURL(for: ChatViewController.chatID, using: ChatViewController.token)
        Log("Chat WEb View URL: \(url)")
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func setupUI(){
        activityIndicator.startAnimating()
    }
    
    deinit {
        ChatViewController.token = nil
        ChatViewController.chatID = nil
    }
}

extension ChatViewController:WKNavigationDelegate,WKScriptMessageHandler{
   
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        Log(error.localizedDescription)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == chatPresenter.navDismissHandler{
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
