//
//  GetDetailsVC.swift
//  Parking
//
//  Created by Shashank Mishra on 18/08/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

import Foundation
import UIKit


class GetInitialDetailsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    var array_Locations = [["name":"Sector 62","lat":28.6245377,"long":77.372354],["name":"Noida City Center","lat":28.5747441,"long":77.3538376]]
    
    @IBOutlet weak var tableViewLocation: UITableView!
    @IBOutlet weak var textFieldLocation: UITextField!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewLocation.isHidden = true
        
        let lat = array_Locations[0]["lat"] as? Double
        let long = array_Locations[0]["long"] as? Double
        
        let location = CLLocation(latitude: lat!, longitude: long!)
        appDelegate?.selectedLocation = location

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func showLocation(_ sender: Any) {
        
        if appDelegate?.selectedLocation == nil{
            
            let lat = array_Locations[0]["lat"] as? Double
            let long = array_Locations[0]["long"] as? Double
            
            let location = CLLocation(latitude: lat!, longitude: long!)
            appDelegate?.selectedLocation = location
            
        }
        self.performSegue(withIdentifier: "FindParking", sender: sender)
        
    }
    @IBAction func useCurrentLocation(_ sender: Any) {
        
        self.performSegue(withIdentifier: "FindParking", sender: sender)

    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return array_Locations.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = array_Locations[indexPath.row]["name"] as? String
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let lat = array_Locations[indexPath.row]["lat"] as? Double
        let long = array_Locations[indexPath.row]["long"] as? Double

        let location = CLLocation(latitude: lat!, longitude: long!)
        appDelegate?.selectedLocation = location
        
        
        textFieldLocation.text = array_Locations[indexPath.row]["name"] as? String
        tableViewLocation.deselectRow(at: indexPath, animated: true)
        tableViewLocation.isHidden = true
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        tableViewLocation.isHidden = false
        return false
    }
}
