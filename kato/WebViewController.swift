//
//  ViewController.swift
//  WKWebview
//
//  Created by Koki on 2018/09/17.
//  Copyright © 2018年 Koki. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        [webView.topAnchor.constraint(equalTo: view.topAnchor),
         webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)].forEach  { anchor in
            anchor.isActive = true
        }
        
        if let url = URL(string: "http://www.google.com/") {
            webView.load(URLRequest(url: url))
        }
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url \(String(describing: webView.url))")
    }
    
}


