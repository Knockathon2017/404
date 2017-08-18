//
//  RiskPolygon.swift
//  Parking
//
//  Created by Shashank Mishra on 18/08/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

import UIKit
import CoreLocation

open class RiskPolygon: NSObject {
    
    var coordinatesArray: [CLLocationCoordinate2D]
    var address: String!
    var distance: Float!
    var riskZone: Int!
    
    // For schedule listing
    init(coordinatesArray: [CLLocationCoordinate2D], address: String, distance: Float, riskZone: Int) {
        self.coordinatesArray = coordinatesArray
        self.address = address
        self.distance = distance
        self.riskZone = riskZone
    }
    
}
