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
            
            
            
            self.initOverlays(CLLocationCoordinate2DMake( 42.11, -9.37))
            
            //self.initOverlays(userLocation.coordinate)
            
        }
        
        
        
        //getDirectionsUsingGoogle()
        
    }
    
    
    
    
    
    fileprivate func getDirectionsUsingGoogle(){
        
        let path = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&type=places&keyword=cruise&key=AIzaSyDcbYjHrMlF7f7KHNCV0XaKZZj_B3CZqRY"
        
        
        
        performOperationForURL(path as NSString, index: 0)
        
    }
    
    
    
    fileprivate func performOperationForURL(_ urlString:NSString, index: Int){
        
        let urlEncoded = urlString.replacingOccurrences(of: " ", with: "%20")
        
        let url:URL? = URL(string:urlEncoded)
        
        let request:URLRequest = URLRequest(url:url!)
        
        let queue:OperationQueue = OperationQueue()
        
        
        
        NSURLConnection.sendAsynchronousRequest(request,queue:queue,completionHandler:{response,data,error in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                
                
            }
                
            else{
                
                let jsonResult: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                
                print(jsonResult)
                
            }
            
        }
            
        )
        
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
        
        if overlay is GMSPolygon {
            
            let alert = UIAlertController(title: overlay.title, message: "", preferredStyle: UIAlertControllerStyle.alert)
            
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
        
        for polygon in appDelegate!.polygonArray {
            
            let path = GMSMutablePath()
            
            for coords in polygon.coordinatesArray {
                
                path.add(coords)
                
            }
            
            let K1polygon = GMSPolygon(path: path)
            
            K1polygon.fillColor = getPolygonColor(polygon.riskZone)
            
            K1polygon.strokeColor = UIColor.clear
            
            K1polygon.strokeWidth = 0.5
            
            K1polygon.isTappable = true
            
            K1polygon.title = polygon.address
            
            K1polygon.map = self.googleMapView
            
        }
        
        
        
    }
    
    
    
    func getPolygonColor(_ zoneType: Int) -> UIColor {
        
        if zoneType == 0 {
            
            return UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.4)
            
        }
            
        else if zoneType == 1 {
            
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
        
        updateZoomLevel(coords, zoomLevel: 3.0)
        
        
        
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
        
        updateZoomLevel(locationCords, zoomLevel: 3.0)
        
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

