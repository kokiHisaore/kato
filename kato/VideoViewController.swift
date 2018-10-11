//
//  VideoViewController.swift
//  kato
//
//  Created by 池崎雄介 on 2018/09/20.
//  Copyright © 2018年 Koki. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class VideoViewController: UIViewController {
    
    // PROPERTY
    
    lazy var webView = setupWebView()
    
    var videoInfo: JSON!
    
    
    
    // OVERRIDE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = videoInfo["snippet"]["title"].string!
        
        if let url = URL(string: "https://www.youtube.com/watch?v=\(videoInfo["id"]["videoId"])") {
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
extension VideoViewController: WKNavigationDelegate {
    
    /* ページが読み込まれた時に呼ばれる */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url \(String(describing: webView.url))")
    }
    
}
