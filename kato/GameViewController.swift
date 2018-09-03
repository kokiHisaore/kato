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

class GameViewController: UIViewController {
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.frame = view.frame
        view.addSubview(tableView)
        
        getVideoList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getVideoList() {
        let requestURL = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyCZiwV6cOuVuhxprSh1W6Y-lAugDa1LntE&q=youtube&part=snippet&maxResults=40&order=date"
        Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if let jsonResult = response.result.value {
                    let json = JSON(jsonResult)
                    json["items"].forEach{(_, data) in
                        let title = data["snippet"]["title"].string!
                        print(title)
                    }
                }
                break
            case .failure(_):
                print("error")
                print(response.result.error ?? "Failed")
                break
            }
        }
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
