//
//  ViewController.swift
//  MBTA Application
//
//  Created by Jorge Andres on 1/13/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ChameleonFramework
import CoreData
import SVProgressHUD
import TableViewReloadAnimation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITabBarDelegate {
    var trainData = [RouteData]()
    var dataToSend = StopDataModel()
    var isSearching = false;
    var sectionedData = [
        [RouteData](),[RouteData](),[RouteData](),[RouteData](),[RouteData]()
    ]
    var searchedData = [RouteData]()
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var types = ["Light Rail", "Heavy Rail", "Commuter Rail", "Bus", "Ferry"]

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainSetup()
        // jsonTesting()
    }
    
    private func jsonTesting() {
        Alamofire.request("https://api-v3.mbta.com/vehicles").responseJSON {
            response in
            if response.result.isSuccess {
                let currJSON = JSON(response.result.value!)
                print(currJSON)
            }
            else {
                print("Request insuccesfull")
                return
            }
        }
    }
    
    // MARK: mainSetup() Function
    
    private func mainSetup() {
        tableView.register(UINib(nibName: "trainStopsCell", bundle: nil), forCellReuseIdentifier: "trainStopsCell")
        tableView.register(UINib(nibName: "trainStopsCell", bundle: nil), forCellReuseIdentifier: "trainStopsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44;
        tableView.separatorInset = .zero
        tableView.separatorColor = UIColor(hexString: "c8c7cd")
        tableView.tableFooterView = UIView()
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        loadItemsBySections()
    }
    
    
    // MARK: tableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!isSearching) {
            return sectionedData[section].count
        } else {
            return searchedData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainStopsCell", for: indexPath) as! trainStopsCell
        cell.clipsToBounds = true
        if (!isSearching) {
            cell.lineName.text = sectionedData[indexPath.section][indexPath.row].name
            cell.lineDest.text = sectionedData[indexPath.section][indexPath.row].desc
            cell.lineColor.backgroundColor = UIColor(hexString: sectionedData[indexPath.section][indexPath.row].color!)
        } else {
            cell.lineName.text = searchedData[indexPath.row].name
            cell.lineDest.text = searchedData[indexPath.row].desc
            cell.lineColor.backgroundColor = UIColor(hexString: searchedData[indexPath.row].color!)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (!isSearching) {
            return sectionedData.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textColor = UIColor(hexString: "a2a1a7")?.darken(byPercentage: 0.3)
        label.font = UIFont(name: "Baskerville-SemiBold", size: 12)
        label.backgroundColor = UIColor(hexString: "f6f6f6")
        if (!isSearching) {
            label.text = "  \(types[section].uppercased())"
        } else {
            label.text = "  SEARCH RESULTS"
        }
        return label
    }
    
    // MARK: didSelect() Function
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cachedData = dataToSend.route?.name {
            if isSearching {
                if cachedData == searchedData[indexPath.row].name! {
                    performSegue(withIdentifier: "goToStops", sender: self)
                    tableView.deselectRow(at: indexPath, animated: true)
                    return
                }
            } else {
                if cachedData == sectionedData[indexPath.section][indexPath.row].name! {
                    performSegue(withIdentifier: "goToStops", sender: self)
                    tableView.deselectRow(at: indexPath, animated: true)
                    return
                }
            }
        }
        dataToSend.stopDataArray = [stopData]()
        tableView.deselectRow(at: indexPath, animated: true)
        SVProgressHUD.show()
        if isSearching {
            do {
                let request : NSFetchRequest<RouteData> = RouteData.fetchRequest()
                request.predicate = NSPredicate(format: "name == %@", searchedData[indexPath.row].name!)
                try dataToSend.route = context.fetch(request).first!
            } catch {
                print("\(error)")
            }
        } else {
            do {
                let request : NSFetchRequest<RouteData> = RouteData.fetchRequest()
                request.predicate = NSPredicate(format: "name == %@", sectionedData[indexPath.section][indexPath.row].name!)
                try dataToSend.route = context.fetch(request).first!
            } catch {
                print("\(error)")
            }
        }
        processJSON()
    }
    
    // MARK: Core Data Functions

    func loadItemsBySections() {
        for i in types {
            let request : NSFetchRequest<RouteData> = RouteData.fetchRequest()
            request.predicate = NSPredicate(format: "type == %@", i)
            do {
                switch i {
                case "Light Rail":
                    sectionedData[0] = try context.fetch(request)
                case "Heavy Rail":
                    sectionedData[1] = try context.fetch(request)
                case "Commuter Rail":
                    sectionedData[2] = try context.fetch(request)
                case "Bus":
                    sectionedData[3] = try context.fetch(request)
                default:
                    sectionedData[4] = try context.fetch(request)
                }
            } catch {
                print("Error fetching \(error)")
            }
        }
    }
    
    // MARK: Search Bar Functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            isSearching = false
            loadItemsBySections()
            searchBar.setShowsCancelButton(false, animated: true)
            self.tableView.reloadData()
        } else {
            let request : NSFetchRequest<RouteData> = RouteData.fetchRequest()
            isSearching = true
            let namePredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
            let typePredicate = NSPredicate(format: "type CONTAINS[cd] %@", searchText)
            let andPredicate = NSCompoundPredicate(type: .or, subpredicates: [namePredicate, typePredicate])
            request.predicate = andPredicate
            do {
                searchedData = try context.fetch(request)
                self.tableView.reloadData()
            } catch {
                print("\(error)")
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        loadItemsBySections()
        searchBar.setShowsCancelButton(false, animated: true)
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        self.tableView.reloadData()
    }
    
    func processJSON() {
        Alamofire.request("https://api-v3.mbta.com/stops/?filter[route]=\(dataToSend.route!.id!)&filter[direction_id]=0").responseJSON {
            response in
            if response.result.isSuccess {
                let currJSON = JSON(response.result.value!)
                for i in 0...currJSON["data"].arrayValue.count - 1 {
                    let dataToAdd = stopData()
                    if i == 0 {
                        dataToAdd.isFirst = true
                    }
                    dataToAdd.address = currJSON["data"][i]["attributes"]["address"].stringValue
                    dataToAdd.lat = currJSON["data"][i]["attributes"]["latitude"].stringValue
                    dataToAdd.long =  currJSON["data"][i]["attributes"]["longitude"].stringValue
                    dataToAdd.wheel = currJSON["data"][i]["attribues"]["wheelchair_boarding"].stringValue
                    dataToAdd.name = currJSON["data"][i]["attributes"]["name"].stringValue
                    self.dataToSend.stopDataArray.append(dataToAdd)
                    if i == currJSON["data"].arrayValue.count - 1 {
                        self.performSegue(withIdentifier: "goToStops", sender: self)
                    }
                }
            }
            else {
                print("Request insuccesfull")
                return
            }
        }
    }
    
    // MARK : prepareForSegue() Function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SVProgressHUD.dismiss()
        let dest = segue.destination as! StopViewController
        dest.stopData = dataToSend
    }
}

