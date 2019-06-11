//
//  LaunchAnimationViewController.swift
//  MBTA Application
//
//  Created by Jorge Andres on 1/14/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LaunchAnimationViewController: UIViewController {
    
    var trainJSON = JSON()
    var routeData = [RouteData]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicatorMech()
        if (!defaults.bool(forKey: "DidLoadData")) {
            activityIndicator.startAnimating()
            requestAPI()
        } else {
            print("No load")
            performSegue(withIdentifier: "launchAnimation", sender: self)
        }
    }
    
    func activityIndicatorMech() {
        activityIndicator.center = CGPoint(x: 182, y: 608)
        activityIndicator.frame.size = CGSize(width: 50, height: 50)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(hexString: "f48285")
        view.addSubview(activityIndicator)
    }
    
    // MARK: Alamofire Request Function
    
    func requestAPI() {
        Alamofire.request("https://api-v3.mbta.com/routes").responseJSON {
            response in
            if response.result.isSuccess {
                let mbtaJSON : JSON = JSON(response.result.value!)
                print()
                self.trainJSON = mbtaJSON;
                self.processJSON()
            }
            else {
                print("Request insuccesfull")
                return
            }
        }
    }

    // MARK: JSON Parsing Function
    
    func processJSON() {
        for i in 0...trainJSON["data"].arrayValue.count - 1 {
            let dataToAdd = RouteData(context: self.context)
            dataToAdd.name = trainJSON["data"][i]["attributes"]["long_name"].stringValue
            dataToAdd.desc = trainJSON["data"][i]["attributes"]["direction_destinations"][0].stringValue + " - " + trainJSON["data"][i]["attributes"]["direction_destinations"][1].stringValue
            dataToAdd.color = trainJSON["data"][i]["attributes"]["color"].stringValue
            dataToAdd.fareClass = trainJSON["data"][i]["attributes"]["fare_class"].stringValue
            dataToAdd.id = trainJSON["data"][i]["id"].stringValue
            dataToAdd.direct1 = trainJSON["data"][i]["attributes"]["direction_names"][0].stringValue
            dataToAdd.direct1 = trainJSON["data"][i]["attributes"]["direction_names"][1].stringValue
            switch trainJSON["data"][i]["attributes"]["type"] {
            case 0:
                dataToAdd.type = "Light Rail"
                break
            case 1:
                dataToAdd.type = "Heavy Rail"
                break
            case 2:
                dataToAdd.type = "Commuter Rail"
                break
            case 3:
                dataToAdd.type = "Bus"
                let nameToAdd = "\(trainJSON["data"][i]["attributes"]["short_name"].stringValue)"
                if (nameToAdd.prefix(2) == "SL") {
                    dataToAdd.name = "Silver Line \(nameToAdd.suffix(1))"
                } else {
                    dataToAdd.name = "Bus \(nameToAdd)"
                }
                break
            default:
                dataToAdd.type = "Ferry"
                break
            }
            routeData.append(dataToAdd)
            self.saveData()
        }
        activityIndicator.stopAnimating()
        defaults.set(true, forKey: "DidLoadData")
        performSegue(withIdentifier: "launchAnimation", sender: self)
    }
    
    func saveData() {
        do {
            try context.save()
        } catch  {
            print("Error saving context \(error)")
        }
    }
}
