//
//  TalkViewController.swift
//  kato
//
//  Created by 池崎雄介 on 2018/09/03.
//  Copyright © 2018年 Koki. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/* 雑談ページ */
class TalkViewController: UIViewController {
    
    // PROPERTY
    
    lazy var tableView = setupTableView()
    lazy var refreshControl = setupRefreshControl()
    
    /* 動画リスト */
    var videoList = JSON()
    
    
    
    // OVERRIDE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getVideoList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutTableView()
    }
    
    
    
    // OBJC
    
    /* TableViewが引っ張られた時に呼ばれる */
    @objc func refresh(sender: UIRefreshControl) {
        getVideoList()
    }
    
    
    
    // PREPARE
    
    /* YouTubeから動画情報を取得する */
    func getVideoList() {
        /* 検索ワード */
        let searchWord = "talk"
        /* リクエストURL */
        let requestURL = "https://www.googleapis.com/youtube/v3/search?key=\(Credential.apiKey)&q=\(searchWord)&part=snippet&order=date&maxResults=10"
        
        /* 重い処理のためサブスレッドで実行 */
        DispatchQueue.global().async {
            /* YouTubeにリクエストを送る */
            Alamofire.request(
                requestURL,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default,
                headers: nil
                ).responseJSON { (response:DataResponse<Any>) in
                    /* レスポンスの結果によって分岐 */
                    switch(response.result) {
                    case .success(_):
                        /* 成功の場合 */
                        if let jsonResult = response.result.value {
                            /* 結果をJSONで取得 */
                            let json = JSON(jsonResult)
                            
                            /* 動画リストを取得 */
                            self.videoList = json["items"]
                        }
                        break
                    case .failure(_):
                        /* 失敗の場合 */
                        print("error")
                        print(response.result.error ?? "Failed")
                        break
                    }
                    
                    /* UIに関する処理はメインスレッドで実行 */
                    DispatchQueue.main.async {
                        /* RefreshControlが回っていたら止める */
                        if self.refreshControl.isRefreshing {
                            self.refreshControl.endRefreshing()
                        }
                        
                        /* TableViewを更新 */
                        self.tableView.reloadData()
                    }
            }
        }
    }
    
    
    
    // SETUP
    
    /* TableViewの設定 */
    func setupTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "VideoCell", bundle: nil),
            forCellReuseIdentifier: "VideoCell"
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        return tableView
    }
    
    /* RefreshControlの設定 */
    func setupRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return refreshControl
    }
    
    
    
    // LAYOUT
    
    /* TableViewのレイアウトを設定する */
    func layoutTableView() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
}

/* TableView用にTalkViewControllerを拡張 */
extension TalkViewController: UITableViewDelegate, UITableViewDataSource {
    
    /* TableViewのセクションの数を指定 */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /* TableViewのリストの数を指定 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    /* TableViewのセルの内容を指定 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* VideoCellを取り出す */
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "VideoCell",
            for: indexPath
            ) as! VideoCell
        
        /* タイトルを設定 */
        cell.titleLabel.text = videoList[indexPath.row]["snippet"]["title"].string!
        /* サムネイルを設定 */
        cell.thumbnailView.image = UIImage(
            data: try! Data(
                contentsOf: URL(
                    string: videoList[indexPath.row]["snippet"]["thumbnails"]["default"]["url"].string!
                    )!
            )
        )
        
        return cell
    }
    
    /* TableViewのセルが押された時の処理 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected! \(videoList[indexPath.row]["snippet"]["title"])")
        
        /* セルの選択を解除 */
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
