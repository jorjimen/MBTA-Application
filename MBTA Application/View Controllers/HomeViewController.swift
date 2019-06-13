//
//  HomeViewController.swift
//  MBTA Application
//
//  Created by Jorge Andres on 6/13/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var homeTableView: UITableView!
    
    private var endpoint = "https://newsapi.org/v2/everything?q=MBTA&apiKey=2e836d7d628d4409aca3041537e082c4"
    
    var newsArticleArr = [NewsArticle]()

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show()
        homeTableView.register(UINib(nibName: "NewsCellTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsCellTableViewCell")
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.rowHeight = 140
        homeTableView.allowsSelection = false
        retrieveNews()

    }
    
    private func retrieveNews() {
        Alamofire.request(endpoint).responseJSON {
            response in
            if response.result.isSuccess {
                let currJSON = JSON(response.result.value!)
                DispatchQueue.main.async {
                    self.processJson(json: currJSON)
                }
            }
            else {
                print("Request insuccesfull")
                return
            }
        }
    }
    
    private func processJson(json: JSON) {
        for i in 0 ... json["articles"].arrayValue.count - 1 {
            let articleToAdd = NewsArticle()
            articleToAdd.title = json["articles"][i]["title"].stringValue
            if json["articles"][i]["author"] == JSON.null {
                articleToAdd.author = "No author found."
            } else {
                articleToAdd.author = json["articles"][i]["author"].stringValue
            }
            articleToAdd.description = json["articles"][i]["description"].stringValue
            articleToAdd.url = json["articles"][i]["url"].stringValue
            articleToAdd.urlToImage = json["articles"][i]["urlToImage"].stringValue
            newsArticleArr.append(articleToAdd)
        }
        self.homeTableView.reloadData(
            with: .spring(duration: 0.45, damping: 0.65, velocity: 0.8, direction: .right(useCellsFrame: false),
                          constantDelay: 0))
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "Powered by News API", message: "This news was retrieved using News API", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArticleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellTableViewCell", for: indexPath) as! NewsCellTableViewCell
        cell.viewMoreButton.tag = indexPath.row
        cell.bodyLabel.text = newsArticleArr[indexPath.row].description
        cell.viewMoreButton.addTarget(self, action: #selector(openURL), for: .touchUpInside)
        cell.authorLabel.text = newsArticleArr[indexPath.row].author
        cell.titleLabel.text = newsArticleArr[indexPath.row].title
        let url = URL(string: newsArticleArr[indexPath.row].urlToImage)
        cell.newImage!.sd_setImage(with: url, placeholderImage: UIImage(named: "noimage"),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
            return
        })
        return cell
    }
    
    @objc func openURL(sender: UIButton) {
        let url = URL(string: newsArticleArr[sender.tag].url)
        UIApplication.shared.open(url!, options: [:]) { (true) in
        }
    }
}
