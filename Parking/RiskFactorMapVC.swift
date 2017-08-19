//

//  RiskFactorMapVC.swift

//  Parking

//

//  Created by Shashank Mishra on 18/08/17.

//  Copyright © 2017 Gaurav. All rights reserved.

//



import Foundation

import GoogleMaps

import GooglePlaces

import Foundation

import CoreLocation



class RiskFactorMapVC: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    
    
    @IBOutlet var googleMapView: GMSMapView!
    @IBOutlet var labelMessage: UILabel!
    
    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocationCoordinate2D?
    
    var waypointsArray: Array<String> = []
    
    var markersArray: Array<GMSMarker> = []
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var locationManagerClosures: [((_ userLocation: CLLocation) -> ())] = []
    
    
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        
        
        googleMapView.delegate = self
        
        self.locationManager.delegate = self
        
        self.getMyLocation(nil)
        
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: Get current location
    
    func getMyLocation(_ sender: AnyObject?) {
        
        
        
        self.getlocationForUser {(userLocation: CLLocation) -> () in
            
            
            
            self.initOverlays(CLLocationCoordinate2DMake(28.625267, 77.373419))
            
            //self.initOverlays(userLocation.coordinate)
            
        }
        
    }
    
    //Start updating location manager
    
    func getlocationForUser(_ userLocationClosure: @escaping ((_ userLocation: CLLocation) -> ())) {
        
        
        
        self.locationManagerClosures.append(userLocationClosure)
        
        self.locationManager.requestWhenInUseAuthorization()
        
        //First need to check if the apple device has location services availabel. (i.e. Some iTouch's don't have this enabled)
        
        if CLLocationManager.locationServicesEnabled() {
            
            //Then check whether the user has granted you permission to get his location
            
            DispatchQueue.main.async {
                
                self.locationManager.startUpdatingLocation()
                
            }
            
        }
        
        
        
    }
    
    
    
    // MARK: GMSMapViewDelegate method implementation
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        
        if overlay is GMSCircle, let index = Int(overlay.title!) {
            
            let alert = UIAlertController(title: appDelegate!.polygonArray[index].address, message: "Type: \(appDelegate!.polygonArray[index].type!)", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    func showMapOverlays() {
        
        guard currentLocation != nil else {
            
            return
            
        }
        
        
        
        DispatchQueue.main.async {
            
            
            
            self.removeOverlay()
            
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                
                self.showMapOverlaysInMainQueue()
                self.addMultipleMarkers()
                
            })
            
            
            
        }
        
        
        
    }
    
    
    
    func showMapOverlaysInMainQueue() {
        
        
        
        googleMapView.clear()
        
        
        
        //Add active location
        
        let userLocationMarker = GMSMarker(position: currentLocation!)
        
        userLocationMarker.map = self.googleMapView
        
        userLocationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
        
        userLocationMarker.title = "Me"
        
        
        
        //Add polygon
        
        for (index, polygon) in appDelegate!.polygonArray.enumerated() {
            
            let circleCenter = CLLocationCoordinate2D(latitude: polygon.coordinatesArray[2].latitude, longitude: polygon.coordinatesArray[2].longitude)
            let circle = GMSCircle(position: circleCenter, radius: 100.0)
            //circle.title = polygon.address
            circle.title = String(index)
            circle.fillColor = getPolygonColor(polygon.riskZone)
            circle.strokeColor = UIColor.clear
            circle.strokeWidth = 0.5
            circle.isTappable = true
            circle.map = self.googleMapView
            
            
        
        }
        
        for (_, polygon) in appDelegate!.polygonArray.enumerated() {
            if polygon.coordinatesArray[2].latitude == 28.625267, polygon.coordinatesArray[2].longitude == 77.373419 {
                labelMessage.text = "You are in red zone."
                labelMessage.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
                break
            }
            else {
                labelMessage.text = "You are in blue zone."
                labelMessage.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.5)
            }
        }
        
        
        
    }
    
    func sandwitchMessage(_ lat: Double,  long: Double) {
        if lat == 28.625267, long == 77.373419 {
           labelMessage.text = "You are in red zone."
           labelMessage.backgroundColor = UIColor.red
        }
        else {
           labelMessage.text = "You are in blue zone."
             labelMessage.backgroundColor = UIColor.yellow
        }
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

    
    
    func getPolygonColor(_ zoneType: Int) -> UIColor {
        
        if zoneType == 1 {
            
            return UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.4)
            
        }
            
        else if zoneType == 2 {
            
            return UIColor(red: 245/255, green: 208/255, blue: 76/255, alpha: 0.6)
            
        }
            
        else {
            
            return UIColor(red: 0.0, green: 1.0, blue: 0, alpha: 0.4)
            
        }
        
    }
    
    
    
    @IBAction func mapCollapseAction(_ sender: AnyObject) {
        
        guard let coords = self.currentLocation else {
            
            return
            
        }
        
        updateZoomLevel(coords, zoomLevel: 15.0)
        
        
        
    }
    
    
    
    //MARK: CLLocationManager Delegate methods
    
    @objc func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            
            manager.startUpdatingLocation()
            
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager,
                         
                         didUpdateLocations locations: [CLLocation]) {
        
        
        
        let tempClosures = self.locationManagerClosures
        
        for closure in tempClosures {
            
            closure(locations[0])
            
        }
        
        self.locationManagerClosures = []
        
    }
    
    
    
    
    
    func mapGoToRegion(_ location: CLLocation?, address: String?) {
        
        guard let location = location else {
            
            return
            
        }
        
        
        
        let lat = location.coordinate.latitude
        
        let long = location.coordinate.longitude
        
        
        
        UIView.animate(withDuration: 1, animations: { () -> Void in
            
            
            
            let target = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            self.googleMapView.camera = GMSCameraPosition.camera(withTarget: target, zoom: 7)
            
            
            
        }, completion: { (bol) -> Void in
            
            
            
            self.removeOverlay()
            
            
            
        })
        
    }
    
    
    
    func initOverlays(_ locationCords: CLLocationCoordinate2D) {
        
        updateZoomLevel(locationCords, zoomLevel: 15.0)
        
        self.currentLocation = locationCords
        
        self.showMapOverlays()
        
    }
    
    
    
    func updateZoomLevel(_ coordinates: CLLocationCoordinate2D, zoomLevel: Float) {
        
        let newCameraPosition = GMSCameraPosition.camera(withTarget: coordinates, zoom: zoomLevel)
        
        DispatchQueue.main.async(execute: {() -> Void in
            
            self.googleMapView.animate(to: newCameraPosition)
            
        })
        
    }
    
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    
    func removeOverlay() {
        
        
        
        if markersArray.count > 0 {
            
            for marker in markersArray {
                
                marker.map = nil
                
            }
            
            
            
            markersArray.removeAll(keepingCapacity: false)
            
        }
        
        
        
    }
    
    
    
}

