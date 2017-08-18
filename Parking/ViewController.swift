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
class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    var imageName: String!
    
    init(position: CLLocationCoordinate2D, name: String, imageName: String) {
        self.position = position
        self.name = name
        self.imageName = imageName
    }
}


class ParkingViewController: UIViewController,GMSMapViewDelegate {
    
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
    
}

extension ParkingViewController: GMUClusterManagerDelegate{
    
    
    // MARK: - GMUClusterManagerDelegate
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: googleMapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        googleMapView.moveCamera(update)
        return false
    }
    
    // MARK: - GMUMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(poiItem.name)")
            marker.title = poiItem.name
            marker.icon = UIImage(named: poiItem.imageName)
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
        for index in 0...arrayParkings.count {
            let parking = arrayParkings[index]
            
            let lat = parking.latitude
            let long = parking.longitude
            let name = parking.name
            var imageName = ""
            if parking.type == "household"{
                imageName = "household"
            }
            else if parking.type == "household"{
                imageName = "office"
            }
            else{
                imageName = "all"
            }
            
            
            let item = POIItem(position: CLLocationCoordinate2DMake(lat!, long!), name: name!,imageName: imageName)
            
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
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
            
            googleMapView.camera = camera
            //        // Creates a marker in the center of the map.
            
                    marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    marker.title = "Current Location"
                    //marker.snippet = "Australia"
            
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


