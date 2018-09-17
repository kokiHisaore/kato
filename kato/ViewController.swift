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
    
    let tabBar = MDCTabBar()
    let appBarViewController = MDCAppBarViewController()
    lazy var scrollView: UIScrollView = setupScrollView()
    
    fileprivate lazy var viewControllers: [UIViewController] = {
        return self.prepareViewControllers()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* TabBarの設定 */
        tabBar.bounds = view.bounds
        tabBar.delegate = self
        tabBar.items = [
            UITabBarItem(title: "ゲーム", image: MDCIcons.imageFor_ic_check(), tag: 0),
            UITabBarItem(title: "雑談", image: MDCIcons.imageFor_ic_info(), tag: 0),
            UITabBarItem(title: "掲示板", image: MDCIcons.imageFor_ic_settings(), tag: 0),
        ]
        tabBar.itemAppearance = .titles
        tabBar.barTintColor = MDCPalette.red.tint500
        tabBar.tintColor = UIColor.white
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
        appBarViewController.navigationBar.titleFont = MDCTypography.display1Font()
        appBarViewController.navigationBar.titleTextColor = UIColor.white
        
        /* HeaderViewの設定 */
        appBarViewController.headerView.backgroundColor = MDCPalette.red.tint500
        appBarViewController.headerView.minMaxHeightIncludesSafeArea = false
        appBarViewController.headerView.minimumHeight = 100
        
        /* HeaderStackViewの設定 */
        appBarViewController.headerStackView.bottomBar = tabBar
        appBarViewController.headerStackView.setNeedsLayout()
        
        scrollView.topAnchor.constraint(equalTo: appBarViewController.headerStackView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func prepareViewControllers() -> [UIViewController] {
        let gameViewController = GameViewController()
        let talkViewController = TalkViewController()
        let webViewController = WebViewController()
        
        return [gameViewController, talkViewController, webViewController]
    }
    
    /* ScrollViewの設定 */
    func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(viewControllers.count),
            height: view.frame.height
        )
        view.addSubview(scrollView)
        
        for (index, viewController) in viewControllers.enumerated() {
            viewController.view.frame = CGRect(
                x: UIScreen.main.bounds.width * CGFloat(index),
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height
            )
            addChildViewController(viewController)
            scrollView.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
        }
        
        return scrollView
    }
    
    
}

/* ViewControllerの拡張 */
extension ViewController: MDCTabBarDelegate {
    /* 画面遷移をする */
    /* タブが押された時に呼び出される */
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        /* 押されたタブのインデックス取得 */
        guard let index = tabBar.items.index(of: item) else {
            fatalError("MDCTabBarDelegate given selected item not found in tabBar.items")
        }
        
        /* ScrollViewの位置を移動 */
        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * view.bounds.width, y: 0), animated: true)
    }
}

extension ViewController: UIScrollViewDelegate {
    /*
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        tabBar.selectedItem = tabBar.items[Int(currentPage)]
    }
    */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 0)
        
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        tabBar.selectedItem = tabBar.items[Int(currentPage)]
    }
    
}
