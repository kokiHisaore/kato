//
//  GameViewController.swift
//  kato
//
//  Created by 池崎雄介 on 2018/09/03.
//  Copyright © 2018年 Koki. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/* ゲームページ */
class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var videoList = JSON()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* TableViewの設定 */
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        /* VideoListを取得 */
        getVideoList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* YouTubeから動画情報を取得する */
    func getVideoList() {
        /* 検索ワード */
        let searchWord = "game"
        /* リクエストURL */
        let requestURL = "https://www.googleapis.com/youtube/v3/search?key=\(Credential.apiKey)&q=\(searchWord)&part=snippet&order=date&maxResults=10"
        
        /* YouTubeにリクエストを送る */
        Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            /* レスポンスの結果によって分岐 */
            switch(response.result) {
            case .success(_):
                /* 成功の場合 */
                if let jsonResult = response.result.value {
                    /* 結果をJSONで取得 */
                    let json = JSON(jsonResult)
                    
                    /* 動画リストを取得 */
                    self.videoList = json["items"]
                    
                    /* TableViewを更新 */
                    self.tableView.reloadData()
                }
                break
            case .failure(_):
                /* 失敗の場合 */
                print("error")
                print(response.result.error ?? "Failed")
                break
            }
        }
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        
        /* タイトルを設定 */
        cell.titleLabel.text = videoList[indexPath.row]["snippet"]["title"].string!
        /* サムネイルを設定 */
        cell.thumbnailView.image = UIImage(data: try! Data(contentsOf: URL(string: videoList[indexPath.row]["snippet"]["thumbnails"]["default"]["url"].string!)!))
        
        return cell
    }
    
    /* TableViewのセルが押された時の処理 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected! \(videoList[indexPath.row]["snippet"]["title"])")
        
        /* セルの選択を解除 */
        tableView.deselectRow(at: indexPath, animated: false)
    }


}
