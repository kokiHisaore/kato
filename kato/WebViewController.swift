//
//  WebViewController.swift
//  kato
//
//  Created by Koki on 2018/09/04.
//  Copyright © 2018年 Koki. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    // StoryBoadで配置したwebViewのプロパティ
    @IBOutlet weak var webView: UIWebView!
    
    // 初期URL
    let initialUrl = URL(string: "http://com.nicovideo.jp/bbs/co2078137?com_header=1")
    
    // 最初の表示時に呼ばれるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // webViewのデリゲートを設定
        self.webView.delegate = self
        
        // 初期URLで読み込み
        let request = URLRequest(url: initialUrl!)
        self.webView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

