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

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var videoList = JSON()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCell")

        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        getVideoList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getVideoList() {
        let searchWord = "youtube"
        let requestURL = "https://www.googleapis.com/youtube/v3/search?key=\(Credential.apiKey)&q=\(searchWord)&part=snippet&order=date"
        Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let jsonResult = response.result.value {
                    let json = JSON(jsonResult)
                    
                    self.videoList = json["items"]
                    
                    self.tableView.reloadData()
                }
                break
            case .failure(_):
                print("error")
                print(response.result.error ?? "Failed")
                break
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        
        cell.titleLabel.text = videoList[indexPath.row]["snippet"]["title"].string!
        cell.thumbnailView.image = UIImage(data: try! Data(contentsOf: URL(string: videoList[indexPath.row]["snippet"]["thumbnails"]["default"]["url"].string!)!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected! \(videoList[indexPath.row]["snippet"]["title"])")
        
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
