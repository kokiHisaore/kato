//
//  ViewController.swift
//  WKWebview
//
//  Created by Koki on 2018/09/17.
//  Copyright © 2018年 Koki. All rights reserved.
//

import UIKit
import WebKit
import XLPagerTabStrip

/* 掲示板ページ */
class WebViewController: UIViewController, IndicatorInfoProvider {
    
    // PROPERTY
    
    lazy var webView = setupWebView()
    
    /* タブに設定する名前 */
    let tabName: IndicatorInfo = "掲示板"
    
    
    
    // OVERRIDE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "http://www.google.com/") {
            webView.load(URLRequest(url: url))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutWebView()
    }
    
    
    
    // PREPARE
    
    /* タブに設定する名前を返す */
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return tabName
    }
    
    
    
    // SETUP
    
    /* WebViewの設定 */
    func setupWebView() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        return webView
    }
    
    
    
    // LAYOUT
    
    /* WebViewのレイアウトを設定する */
    func layoutWebView() {
        [
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].forEach  { anchor in
            anchor.isActive = true
        }
    }
    
}

/* WebView用にWebViewControllerを拡張 */
extension WebViewController: WKNavigationDelegate {
    
    /* ページが読み込まれた時に呼ばれる */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url \(String(describing: webView.url))")
    }
    
}


