//
//  ViewController.swift
//  Parking
//
//  Created by Gaurav on 18/08/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


/// Point of Interest Item which implements the GMUClusterItem protocol.
enum MarkerType: Int32 {
    
    case House, Office, All
    
}

class CustomClusterItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    var type: MarkerType
    var parking: Parking
    
    init(position: CLLocationCoordinate2D, name: String,type:MarkerType, parking: Parking) {
        self.position = position
        self.name = name
        self.type = type
        self.parking = parking
    }
    
}


class ParkingViewController: UIViewController,GMSMapViewDelegate {
    
    
    
    
    @IBOutlet weak var label_Price: UILabel!
    @IBOutlet weak var label_Rating: UILabel!
    @IBOutlet weak var label_Address: UILabel!
    @IBOutlet weak var label_Distance: UILabel!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var zoomLevel: Float = 15.0
    @IBOutlet var googleMapView: GMSMapView!
    var clusterManager: GMUClusterManager!
    let marker = GMSMarker()
    
    
    let kClusterItemCount = 25
    let kCameraLatitude =  28.62489915
    let kCameraLongitude = 77.37371218
    
    var arrayParkings = [Parking]()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        marker.map = googleMapView
        googleMapView.isMyLocationEnabled = true
        self.getCurrentLocation()
        // Set up the cluster manager with default icon generator and renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: googleMapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: googleMapView, algorithm: algorithm, renderer: renderer)
        
        // Generate and add random items to the cluster manager.
        generateClusterItems()
        
        // Call cluster() after items have been added to perform the clustering and rendering on map.
        clusterManager.cluster()
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
        
        
    }
    
    
    func addMultipleMarkers(){
        
        
    }
    func getCurrentLocation(){
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: GMSMapViewDelegate method implementation
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        if overlay is GMSPolyline {
            
        }
    }
    
    func reloadView(_ parking: Parking){
        
        label_Address.text = parking.address
        label_Rating.text =  String(parking.rating!)
        label_Price.text = "\(String(parking.price!)) rs/Per Hour"
        
        let destiny = CLLocation(latitude: parking.latitude!, longitude: parking.longitude!)
        let distance = (self.currentLocation?.distance(from: destiny))!
        if distance > 1000{
            
            let dist = String(format: "%.2f", distance/1000)
            label_Distance.text = "\(dist) km"
        }
        else{
            let dist = String(format: "%.0f", distance)
            label_Distance.text = "\(dist) m"
        }
        
    }
    
}

extension ParkingViewController: GMUClusterManagerDelegate{
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker:
        GMSMarker) {
        
        if (marker.userData! is CustomClusterItem) {
            
            let customClusterItem = (marker.userData! as! CustomClusterItem)
            
            
            
            switch customClusterItem.type {
                
            case MarkerType.House:
                
                marker.icon = UIImage(named: "house")
                
                break
                
            case MarkerType.Office:
                
                marker.icon = UIImage(named: "office")
                
                break
                
            case MarkerType.All:
                
                marker.icon = UIImage(named: "all")
                
                break
                
            }
            
        }
        
    }
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: googleMapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        googleMapView.moveCamera(update)
        return false
    }
    
    // MARK: - GMUMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? CustomClusterItem {
            NSLog("Did tap marker for cluster item \(poiItem.name)")
            marker.title = poiItem.name
            self.reloadView(poiItem.parking)
            
        } else {
            NSLog("Did tap a normal marker")
        }
        return false
    }
    
    // MARK: - Private
    
    /// Randomly generates cluster items within some extent of the camera and adds them to the
    /// cluster manager.
    func generateClusterItems() {
        //let extent = 0.2
        for (_,parking) in (appDelegate?.arrayParkings.enumerated())! {
            // let parking = arrayParkings[index]
            
            let lat = parking.latitude
            let long = parking.longitude
            let name = parking.name
            var type: MarkerType
            
            if parking.type == "household"{
                type = .House
            }
            else if parking.type == "office"{
                type = .Office
            }
            else{
                type = .All
            }
            
            
            let item = CustomClusterItem(position: CLLocationCoordinate2DMake(lat!, long!), name: name!, type: type, parking: parking)
            
            //            let lat = kCameraLatitude + extent * randomScale()
            //            let lng = kCameraLongitude + extent * randomScale()
            //            let name = "Item \(index)"
            //            let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name)
            clusterManager.add(item)
        }
    }
    
    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
}


//MARK: CLLocationManager Delegate methods

extension ParkingViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        self.currentLocation = location
        //let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
        //                                   longitude: location.coordinate.longitude,
        //                                   zoom: zoomLevel)
        let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude,
                                              longitude: kCameraLongitude,
                                              zoom: zoomLevel)
        googleMapView.camera = camera
        //        // Creates a marker in the center of the map.
        
        //                    marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //                    marker.title = "Current Location"
        //                    marker.icon = UIImage(named: "all")
        reloadView((appDelegate?.arrayParkings[0])!)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            googleMapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}


