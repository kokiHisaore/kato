//
//  WebViewController.swift
//  kato
//
//  Created by Koki on 2018/09/04.
//  Copyright © 2018年 Koki. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    // WebViewのプロパティ
    lazy var webView = setupWebView()
    
    // 初期URL
    let initialUrl = URL(string: "http://com.nicovideo.jp/bbs/co2078137?com_header=1")
    
    // 最初の表示時に呼ばれるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期URLで読み込み
        let request = URLRequest(url: initialUrl!)
        self.webView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupWebView() -> UIWebView {
        let webView = UIWebView()
        webView.delegate = self
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-120)
        view.addSubview(webView)
        
        return webView
    }
    
    
}

