//
//  StopViewController.swift
//  MBTA Application
//
//  Created by Jorge Andres on 1/22/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import UIKit
import MapKit
import ChameleonFramework
import TableViewReloadAnimation

class StopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var stopData = StopDataModel()
    var barUnder = UIView()
    var setState = false
    let locationManager = CLLocationManager()
    var didDisplayAlert = false
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
        didDisplayAlert = false
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
            stopTableView.reloadData()
        }
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        stopTableView.reloadData()
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
        cell.directionButton.tag = indexPath.row
        cell.directionButton.addTarget(self, action:  #selector(stopDirection), for: UIControl.Event.touchDown)
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
        let lat = Double(stopData.stopDataArray[indexPath.row].lat) ?? 0
        let long = Double(stopData.stopDataArray[indexPath.row].long) ?? 0
        let coordinate = CLLocation(latitude: lat, longitude: long)
        let userDistance = locationManager.location ?? CLLocation(latitude: 1.0, longitude: 1.0)
        if userDistance.coordinate.latitude == 1.0 && userDistance.coordinate.longitude == 1.0 {
            cell.distanceFromUser.text = ""
        } else {
            let distance = (coordinate.distance(from: userDistance) / 1609.344)
            if distance > 200 {
                let alert = UIAlertController(title: "Too far!", message: "You are outside of a 200 mile radius from any nearby stop. No distance will be shown.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: { (action) in
                }))
                if !didDisplayAlert {
                    self.present(alert, animated: true)
                    self.didDisplayAlert = true
                }
                cell.distanceFromUser.text = ""
            } else {
                if distance > 0.0284091 {
                    cell.distanceFromUser.text = String((distance*10).rounded()/10) + " mi"
                } else {
                    cell.distanceFromUser.text = String((((distance*5280)*10).rounded()/10) - 50) + " feet"
                }
            }
        }
        return cell
    }
    
    @objc func stopDirection(sender: UIButton) {
        let data = stopData.stopDataArray[sender.tag]
        let coordinates = CLLocationCoordinate2D(latitude: (Double(data.lat) ?? 0),longitude: (Double(data.long) ?? 0))
        let setSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: setSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: setSpan.span)]
        let item = MKMapItem(placemark:  MKPlacemark(coordinate: coordinates))
        item.name = data.name
        item.openInMaps(launchOptions: options)
    }

}
