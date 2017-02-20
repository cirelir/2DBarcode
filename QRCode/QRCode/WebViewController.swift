//
//  WebView.swift
//  QRCode
//
//  Created by Erwin on 16/5/6.
//  Copyright © 2016年 Erwin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKNavigationDelegate {
    
    var url : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str = url! as String
        
        let path = URL(string: str)
        let webview = WKWebView(frame: self.view.bounds)
        webview.load(URLRequest(url: path!))
        webview.navigationDelegate = self
        self.view.addSubview(webview)
    
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }
}
