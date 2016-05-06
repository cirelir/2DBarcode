//
//  WebView.swift
//  QRCode
//
//  Created by Erwin on 16/5/6.
//  Copyright © 2016年 Erwin. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {
    
    var url : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str = url! as String
        
        let path = NSURL(string: str)
        let webview = UIWebView(frame: self.view.bounds)
        webview.delegate = self
        webview.loadRequest(NSURLRequest(URL: path!))
        self.view.addSubview(webview)
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.title = webView.stringByEvaluatingJavaScriptFromString("document.title")
    }
}
