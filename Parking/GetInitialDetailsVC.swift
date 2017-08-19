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
    
    var array_Locations = ["Sector 62","Sector 18","Sector 56","Indirapuram","Vaishali","Noida City center"]
    
    @IBOutlet weak var tableViewLocation: UITableView!
    @IBOutlet weak var textFieldLocation: UITextField!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewLocation.isHidden = true

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func showLocation(_ sender: Any) {
        
    }
    @IBAction func useCurrentLocation(_ sender: Any) {
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return array_Locations.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = array_Locations[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        textFieldLocation.text = array_Locations[indexPath.row]
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
