//
//  Parking.swift
//  Parking
//
//  Created by Gaurav on 18/08/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//


import Foundation
class Parking {
    
    var id: Int?
    var rating: Int?
    var name: String?
    var address: String?
    var type: String?
    var userType:String?
    var numberOfParkings: Int?
    var available: Int?
    var isCar: Bool?
    var isBike: Bool?
    var price: Int?
    var status: String?
    var time: String?
    var latitude: Double?
    var longitude: Double?
    
    init(_ dictionary: Dictionary<String, Any>) {
        
        self.id = dictionary["id"] as? Int
        self.rating = dictionary["rating"] as? Int
        self.name = dictionary["parking_name"] as? String
        self.address = dictionary["address"] as? String
        self.type = dictionary["type"] as? String
        self.userType = dictionary["user"] as? String

        self.numberOfParkings = dictionary["total"] as? Int
        self.available = dictionary["available"] as? Int
        self.isCar = dictionary["cars"] as? Bool
        self.isBike = dictionary["bike"] as? Bool
        self.price = dictionary["costcar"] as? Int
        self.status = dictionary["status"] as? String
        self.time = dictionary["time"] as? String

        
        if let location = dictionary["location"] as? Dictionary<String,Any>{
            self.latitude = location["latitude"] as? Double
            self.longitude = location["longitude"] as? Double
        }
        

    }
    
}
