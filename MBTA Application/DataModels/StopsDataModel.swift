//
//  StopsDataModel.swift
//  MBTA Application
//
//  Created by Jorge Andres on 1/22/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import Foundation
import CoreData

class StopDataModel {
    var route : RouteData?
    var stopDataArray = [stopData]()
}

class stopData {
    var address = String()
    var lat = String()
    var long = String()
    var name = String()
    var wheel = String()
}
