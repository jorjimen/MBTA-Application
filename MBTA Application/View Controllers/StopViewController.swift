//
//  StopViewController.swift
//  MBTA Application
//
//  Created by Jorge Andres on 1/22/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import UIKit
import ChameleonFramework
import TableViewReloadAnimation

class StopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var stopData = StopDataModel()
    var barUnder = UIView()
    var setState = false
    @IBOutlet weak var stopTableView: UITableView!
    
    var segmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(frame: CGRect(x: 0, y:88, width: Int(UIScreen.main.bounds.width), height: 40))
        sc.insertSegment(withTitle: "Northbound", at: 0, animated: true)
        sc.insertSegment(withTitle: "Southbound", at: 1, animated: true)
        sc.selectedSegmentIndex = 0
        sc.tintColor = .clear
        return sc
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopTableView.register(UINib(nibName: "stopCell", bundle: nil), forCellReuseIdentifier: "stopCell")
        stopTableView.delegate = self
        stopTableView.dataSource = self
        stopTableView.separatorStyle = .none
        addTopBar()
    }
    
    private func addTopBar() {
        title = stopData.route?.name
        view.addSubview(segmentedControl)
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        segmentedControl.backgroundColor = UIColor(hexString: "ebebeb")
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Baskerville", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Baskerville", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor(hexString: (stopData.route?.color)!)!
            ], for: .selected)
        segmentedControl.addTarget(self, action: #selector(changeBar), for: .valueChanged)
        barUnder = UIView(frame: CGRect(x:0, y:126, width: Int(UIScreen.main.bounds.width)/2, height: 2))
        barUnder.backgroundColor = UIColor(hexString: (stopData.route?.color)!)!
        view.addSubview(barUnder)
    }
    
    @objc func changeBar() {
        if segmentedControl.selectedSegmentIndex == 1 {
            stopData.stopDataArray.reverse()
            stopTableView.reloadData(
                with: .spring(duration: 0.45, damping: 0.65, velocity: 0.8, direction: .right(useCellsFrame: false),
                              constantDelay: 0))
            UIView.animate(withDuration: 0.29) {
                self.barUnder.layer.position.x = self.barUnder.layer.position.x * 3
            }
        } else {
            stopData.stopDataArray.reverse()
            stopTableView.reloadData(
                with: .spring(duration: 0.45, damping: 0.65, velocity: 0.8, direction: .right(useCellsFrame: false),
                              constantDelay: 0))
            UIView.animate(withDuration: 0.29) {
                self.barUnder.layer.position.x = self.barUnder.layer.position.x / 3
            }
        }
   
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stopData.stopDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stopTableView.dequeueReusableCell(withIdentifier: "stopCell", for: indexPath) as! stopCell
        cell.stopName.text = stopData.stopDataArray[indexPath.row].name
        cell.stopCircle.backgroundColor = UIColor(hexString: (stopData.route?.color)!)!
        cell.topBar.backgroundColor = UIColor(hexString: (stopData.route?.color)!)!
        cell.bottomBar.backgroundColor = UIColor(hexString: (stopData.route?.color)!)!
        cell.directionButton.backgroundColor = UIColor(hexString: (stopData.route?.color)!)!
        cell.arrButton.backgroundColor = UIColor(hexString: (stopData.route?.color)!)!
        cell.separator.backgroundColor = UIColor(hexString: (stopData.route?.color)!)!
        if indexPath.row == 0 {
            cell.topBar.isHidden = true
            cell.stopCircle.backgroundColor = .white
            cell.stopCircle.layer.borderWidth = 5
            cell.stopCircle.layer.borderColor = (UIColor(hexString: (stopData.route?.color)!)!).cgColor
        } else {
            cell.topBar.isHidden = false
            cell.bottomBar.isHidden = false
            if indexPath.row == (stopData.stopDataArray.count - 1) {
                print("here")
                cell.bottomBar.isHidden = true
                cell.topBar.isHidden = false
            }
        }
        return cell
    }
    
}
