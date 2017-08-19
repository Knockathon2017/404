//
//  AppDelegate.swift
//  Parking
//
//  Created by Gaurav on 18/08/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var polygonArray: [RiskPolygon]!
    var arrayParkings = [Parking]()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyDcbYjHrMlF7f7KHNCV0XaKZZj_B3CZqRY")
        GMSPlacesClient.provideAPIKey("AIzaSyDcbYjHrMlF7f7KHNCV0XaKZZj_B3CZqRY")
        
        fetchParking()
        readJson()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //Read JSON files
    private func fetchParking() {
        do {

            if let file = Bundle.main.url(forResource: "Parking", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let object = json as? [String: Any] {
                    // json is a dictionary
                let parkings = object["parkingArea"] as? [Dictionary<String,Any>]
                    print(parkings!)
                    
                    for dictionary in parkings!{
                        
                        let parking = Parking(dictionary)
                        self.arrayParkings.append(parking)
                    }
                    
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func readJson() {
        do {
            self.polygonArray = []
            if let file = Bundle.main.url(forResource: "riskZone", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    let polygons = object["polygons"] as? [[String: Any]]
                    for polygon in polygons! {
                        let array = polygon["coordinates"] as? [[Double]]
                        var coordinateArray: [CLLocationCoordinate2D] = []
                        for coords in array! {
                            let coord = CLLocationCoordinate2DMake(coords[0], coords[1])
                            coordinateArray.append(coord)
                        }
                        let riskZone = polygon["riskZone"] as? Int
                        let address = polygon["address"] as? String
                        let riskPolygon = RiskPolygon(coordinatesArray: coordinateArray, address: address!, distance: 0.0, riskZone: riskZone!)
                        self.polygonArray.append(riskPolygon)
                    }
                    
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}

