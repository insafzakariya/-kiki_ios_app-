//
//  SMPaymentViewController.swift
//  SusilaMobile
//
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import UIKit

class SMPaymentViewController: UIViewController,UIWebViewDelegate {
    var strURL:String!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Package"
        
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        let url = URL(string: strURL)!
        webView.loadRequest(URLRequest.init(url: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIWEBVIEW Delegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ProgressView.shared.hide()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        ProgressView.shared.hide()
    }
}
