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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

