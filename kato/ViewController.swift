//
//  ViewController.swift
//  kato
//
//  Created by Koki on 2018/08/15.
//  Copyright © 2018年 Koki. All rights reserved.
//

/*
 構成要素は
 ゲーム、雑談、掲示板（現時点ではこの３つ）
 **********ゲーム**********
 ・流れ
 ゲームを選ぶ→partを選ぶ→動画が再生される
 
 ・UI
 ゲームのプレイ動画をゲーム毎にグループ化して表示（リストやカードなど並べ方は検討中）
 画面遷移なしで、part表示（これはリストでいいと思う）できたら美しいと思う
 スクレイピングにより、動画のサムネイルとタイトルと再生時間を表示したい
 
 ・動画の選び方
 URLもしくはIDを入力できる形にしてくれれば、吉田が人気のシリーズを直接入力します
 ***********雑談***********
 ・流れ
 雑談を選ぶ→動画が再生される
 
 ・UI
 リスト（新しい順）
 難しい要求だと思うが、バックグラウンド再生できれば相当使い勝手が上がる
 
 ・動画の選び方
 youtubeのリアルタイムの検索結果（加藤純一 雑談, うんこちゃん 雑談等）を反映する
 **********掲示板**********
 これはサブコンテンツの為、内部ブラウザ(Safari)でWebPageが開ければ充分だと思う
*/

import UIKit
import MaterialComponents

class ViewController: UIViewController {
    
    // PROPERTY
    
    lazy var appBarViewController = setupAppBar()
    lazy var tabBar = setupTabBar()
    lazy var scrollView = setupScrollView()
    
    /* 各ページのViewContoller */
    lazy var viewControllers: [UIViewController] = {
        return prepareViewControllers()
    }()
    
    /* StatusBarをAppBarViewControllerに重ねる */
    override var childForStatusBarStyle: UIViewController? {
        return appBarViewController
    }

    
    
    // OVERRIDE
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutScrollView()
        layoutViewControllers()
    }
    
    
    
    // PREPARE
    
    /* 各ページのViewControllerを準備する */
    func prepareViewControllers() -> [UIViewController] {
        let gameViewController = GameViewController()
        let talkViewController = TalkViewController()
        let webViewController = WebViewController()
        
        return [gameViewController, talkViewController, webViewController]
    }
    
    
    
    // SETUP
    
    /* AppBarViewControllerの設定 */
    func setupAppBar() -> MDCAppBarViewController {
        let appBarViewController = MDCAppBarViewController()
        self.addChild(appBarViewController)
        view.addSubview(appBarViewController.view)
        appBarViewController.didMove(toParent: self)
        
        appBarViewController.navigationBar.title = "KATO"
        appBarViewController.navigationBar.titleFont = MDCTypography.display1Font()
        appBarViewController.navigationBar.titleTextColor = UIColor.white
        
        appBarViewController.headerView.backgroundColor = MDCPalette.red.tint500
        appBarViewController.headerView.minMaxHeightIncludesSafeArea = false
        appBarViewController.headerView.minimumHeight = 100
        
        appBarViewController.headerStackView.bottomBar = tabBar
        appBarViewController.headerStackView.setNeedsLayout()
        
        return appBarViewController
    }
    
    /* TabBarの設定 */
    func setupTabBar() -> MDCTabBar {
        let tabBar = MDCTabBar()
        tabBar.bounds = view.bounds
        tabBar.delegate = self
        tabBar.items = [
            UITabBarItem(title: "ゲーム", image: nil, tag: 0),
            UITabBarItem(title: "雑談", image: nil, tag: 0),
            UITabBarItem(title: "掲示板", image: nil, tag: 0),
        ]
        tabBar.itemAppearance = .titles
        tabBar.barTintColor = MDCPalette.red.tint500
        tabBar.tintColor = UIColor.white
        tabBar.selectedItemTintColor = UIColor.white
        tabBar.alignment = .justified
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        tabBar.sizeToFit()
        view.addSubview(tabBar)
        
        return tabBar
    }
    
    /* ScrollViewの設定 */
    func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        return scrollView
    }
    
    
    
    // LAYOUT
    
    /* ScrollViewのレイアウトを設定する */
    func layoutScrollView() {
        scrollView.topAnchor.constraint(equalTo: appBarViewController.headerStackView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(viewControllers.count),
            height: view.frame.height
        )
        
        scrollView.setContentOffset(
            CGPoint(
                x: CGFloat(tabBar.items.index(of: tabBar.selectedItem!)!) * view.bounds.width,
                y: 0
            ), animated: true
        )
    }
    
    /* 各ページのViewControllerのレイアウトを設定する */
    func layoutViewControllers() {
        for (index, viewController) in viewControllers.enumerated() {
            viewController.view.frame = CGRect(
                x: UIScreen.main.bounds.width * CGFloat(index),
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height
            )
            addChild(viewController)
            scrollView.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        }
    }
    
    
}

/* TabBar用にViewControllerを拡張 */
extension ViewController: MDCTabBarDelegate {
    
    /* タブが押された時に呼ばれる */
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        /* 押されたタブのインデックス取得 */
        guard let index = tabBar.items.index(of: item) else {
            fatalError("MDCTabBarDelegate given selected item not found in tabBar.items")
        }
        
        /* ScrollViewの位置を移動してページを変える */
        scrollView.setContentOffset(
            CGPoint(
                x: CGFloat(index) * view.bounds.width,
                y: 0
            ), animated: true
        )
    }
    
}

/* ScrollView用にViewControllerを拡張 */
extension ViewController: UIScrollViewDelegate {
    
    /* スクロールが終わった時に呼ばれる */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        tabBar.selectedItem = tabBar.items[Int(currentPage)]
    }
    
    /* スクロールを検知すると呼ばれる */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentSize = CGSize(
            width: scrollView.contentSize.width,
            height: 0
        )
    }
    
}
