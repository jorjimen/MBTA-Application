//
//  StopViewController.swift
//  MBTA Application
//
//  Created by Jorge Andres on 1/22/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import UIKit
import ChameleonFramework

class StopViewController: UIViewController {
    
    var stopData = StopDataModel()
    var barUnder = UIView()

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
        print(stopData.stopDataArray)
    }
    
    @objc func changeBar() {
        if segmentedControl.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.29) {
                self.barUnder.layer.position.x = self.barUnder.layer.position.x * 3
            }
        } else {
            UIView.animate(withDuration: 0.29) {
                self.barUnder.layer.position.x = self.barUnder.layer.position.x / 3
            }
        }
   
    }
}
