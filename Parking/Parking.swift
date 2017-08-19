//
//  Parking.swift
//  Parking
//
//  Created by Gaurav on 18/08/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//


import Foundation
class Parking {
    
    var id: String?
    var rating: Double?
    var name: String?
    var address: String?
    var type: String?
    var userType:String?
    var numberOfParkings: Int?
    var carAvailable: Int?
    var bikeAvailable: Int?

    var isCar: Bool?
    var isBike: Bool?
    var price: Int?
    var status: String?
    var time: String?
    var latitude: Double?
    var longitude: Double?
    
    init(_ dictionary: Dictionary<String, Any>) {
        
        self.id = dictionary["id"] as? String
        self.rating = dictionary["rating"] as? Double
        self.name = dictionary["parking_name"] as? String
        self.address = dictionary["address"] as? String
        self.type = dictionary["type"] as? String
        self.userType = dictionary["user"] as? String

        self.numberOfParkings = dictionary["total"] as? Int
        self.carAvailable = dictionary["car_available"] as? Int
        self.bikeAvailable = dictionary["bike_available"] as? Int

        self.isCar = dictionary["cars"] as? Bool
        self.isBike = dictionary["bike"] as? Bool
        self.price = dictionary["price"] as? Int
        self.status = dictionary["status"] as? String
        self.time = dictionary["time"] as? String

        
        if let location = dictionary["location"] as? Dictionary<String,Any>{
            self.latitude = location["lat"] as? Double
            self.longitude = location["lng"] as? Double
        }
        

    }
    
}
