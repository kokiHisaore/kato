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
import MaterialComponents

/* ゲームページ */
class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tabBar = MDCTabBar()
    let appBarViewController = MDCAppBarViewController()
    let tableView = UITableView()
    var videoList = JSON()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* TableViewの設定 */
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        /* TableViewのAutoLayout */
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: -UIApplication.shared.statusBarFrame.size.height).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        /* TabBarの設定 */
        tabBar.delegate = self
        tabBar.items = [
            UITabBarItem(title: "ゲーム", image: MDCIcons.imageFor_ic_check(), tag: 0),
            UITabBarItem(title: "雑談", image: MDCIcons.imageFor_ic_info(), tag: 0),
            UITabBarItem(title: "掲示板", image: MDCIcons.imageFor_ic_settings(), tag: 0),
        ]
        tabBar.itemAppearance = .titledImages
        tabBar.barTintColor = MDCPalette.red.tint500
        tabBar.selectedItemTintColor = UIColor.white
        tabBar.alignment = .justified
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        tabBar.sizeToFit()
        view.addSubview(tabBar)
        
        /* AppBarViewControllerの設定 */
        self.addChildViewController(appBarViewController)
        view.addSubview(appBarViewController.view)
        appBarViewController.didMove(toParentViewController: self)
        
        /* NavigationBarの設定 */
        appBarViewController.navigationBar.title = "kato"
        appBarViewController.navigationBar.titleTextColor = UIColor.white
        
        /* HeaderViewの設定 */
        appBarViewController.headerView.backgroundColor = MDCPalette.red.tint500
        appBarViewController.headerView.minMaxHeightIncludesSafeArea = false
        appBarViewController.headerView.minimumHeight = 56 + 72
        appBarViewController.headerView.maximumHeight = 56 + 72
        appBarViewController.headerView.tintColor = MDCPalette.blue.tint100
        appBarViewController.headerView.trackingScrollView = tableView
        
        /* HeaderStackViewの設定 */
        appBarViewController.headerStackView.bottomBar = tabBar
        appBarViewController.headerStackView.setNeedsLayout()
        
        /* VideoListを取得 */
        getVideoList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* YouTubeから動画情報を取得する */
    func getVideoList() {
        /* 検索ワード */
        let searchWord = "youtube"
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
    
    /* StatusBarをAppBarViewControllerに重ねる */
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return appBarViewController
    }
    
    /* TabBarの挙動を設定する */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            if let selectedItem = self.tabBar.selectedItem {
                self.tabBar(self.tabBar, didSelect: selectedItem)
            }
        }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/* ViewControllerの拡張 */
extension GameViewController: MDCTabBarDelegate {
    /* 画面遷移をする */
    /* タブが押された時に呼び出される */
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        /* 押されたタブのインデックス取得 */
        guard let index = tabBar.items.index(of: item) else {
            fatalError("MDCTabBarDelegate given selected item not found in tabBar.items")
        }
        
        let vcs = ["game", "talk"]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dstView = storyboard.instantiateViewController(withIdentifier: vcs[index])
        
        appBarViewController.present(dstView, animated: true, completion: nil)
    }
}
