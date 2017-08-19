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
    
    
    
    @IBOutlet weak var carAvailable: UILabel!
    @IBOutlet weak var bikeAvailable: UILabel!
    var isCar = true
    @IBOutlet weak var label_Price: UILabel!
    @IBOutlet weak var label_Rating: UILabel!
    @IBOutlet weak var label_Address: UILabel!
    @IBOutlet weak var label_Distance: UILabel!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var zoomLevel: Float = 15.0
    @IBOutlet var googleMapView: GMSMapView!
    var clusterManager: GMUClusterManager!
    
    
    let kClusterItemCount = 25
    let kCameraLatitude =  28.62489915
    let kCameraLongitude = 77.37371218
    
    var arrayParkings = [Parking]()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        googleMapView.isMyLocationEnabled = true
        googleMapView.delegate = self
        self.getCurrentLocation()
        self.addMultipleMarkers()
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func bikeSelected(_ sender: Any) {
        
         isCar = false
        self.performSegue(withIdentifier: "ScanCode", sender: sender)
       
    }
    @IBAction func carSelected(_ sender: UIButton) {
         isCar = true
        self.performSegue(withIdentifier: "ScanCode", sender: sender)

    }
    
    func addMultipleMarkers(){
        
        for (index,parking) in (appDelegate?.arrayParkings.enumerated())! {
            // let parking = arrayParkings[index]
            let marker = GMSMarker()
            let location = CLLocation(latitude: parking.latitude!, longitude: parking.longitude!)
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            marker.title = parking.name
            marker.map = googleMapView
            marker.userData = index
            if parking.type == "household"{
                 marker.icon = UIImage(named: "house")
            }
            else if parking.type == "office"{
                marker.icon = UIImage(named: "office")
            }
            else{
                marker.icon = UIImage(named: "all")
            }
        }
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScanCode" {
            
            if let vc = segue.destination as? QRScannerController{
                
               vc.address = label_Address.text
                if isCar{
                    vc.vehicleType = 0
                    
                }
                else{
                    vc.vehicleType = 1
                }
               
            }
        }
    }
    
    @IBAction func navigateAction(_ sender: Any) {
        
        
        
    }
    
    func openRoute(_ source: CLLocation, destination: CLLocation) {
        
        let query = "?saddr=\(source.coordinate.latitude),\(source.coordinate.longitude)&daddr=\(destination.coordinate.latitude),\(destination.coordinate.longitude))" + "&directionsmode=driving"
        let path = "http://maps.apple.com/" + query
        if let url = URL(string: path) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } 
        
    }
    
    @IBAction func callAction(_ sender: Any) {
        
        if let url = URL(string: "tel://+918181924966"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    func reloadView(_ parking: Parking){
        
        label_Address.text = parking.address
        label_Rating.text =  String(parking.rating!)
        label_Price.text =   "\(String(parking.price!)) rs/Per Hour"
        carAvailable.text =  String(parking.carAvailable!)
        bikeAvailable.text = String(parking.bikeAvailable!)

        
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
    
    // tap map marker
   
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker){
        
        
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("didTap marker \(marker.title!)")
        
        let index = marker.userData as! Int
        print(index)
        let parking = appDelegate?.arrayParkings[index]
        reloadView(parking!)
        // tap event handled by delegate
        
        return true
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


