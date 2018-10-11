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
import XLPagerTabStrip

class ViewController: ButtonBarPagerTabStripViewController {
    
    // PROPERTY
    
    let selectedColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0)
    let unselectedIconColor = UIColor(red: 73/255.0, green: 8/255.0, blue: 10/255.0, alpha: 1.0)

    
    
    // OVERRIDE
    
    override func viewDidLoad() {
        settings.style.buttonBarItemBackgroundColor = MDCPalette.red.tint500
        settings.style.selectedBarBackgroundColor = selectedColor
        settings.style.selectedBarHeight = 4.0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self]
            (
            oldCell: ButtonBarViewCell?,
            newCell: ButtonBarViewCell?,
            progressPercentage: CGFloat,
            changeCurrentIndex: Bool,
            animated: Bool
            ) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = self?.unselectedIconColor
            newCell?.label.textColor = self?.selectedColor
        }
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // 管理されるViewControllerを返す処理
        let gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Game")
        let talkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Talk")
        let webVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Web")
        
        let childViewControllers: [UIViewController] = [gameVC, talkVC, webVC]
        
        return childViewControllers
    }
    
    
}
