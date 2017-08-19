//
//  BookingConfirmationVC.swift
//  Parking
//
//  Created by Shashank Mishra on 19/08/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

import UIKit

class BookingConfirmationVC: UIViewController {
    
    @IBOutlet var checkBox: UIButton!
    @IBOutlet var vehicleCarNumberLbl: UILabel!
    @IBOutlet var vehicleTypeLbl: UILabel!
    @IBOutlet var entryTimeLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var contactLbl: UILabel!
    @IBOutlet var chargeLbl: UILabel!
    @IBOutlet var cleaningLbl: UILabel!
    
    var vehicleType: Int!
    var address: String! = "Dummy Address"
    var cleaningAvailable: Bool!
    var charge: Int! = 20
    
    
    override func viewDidLoad() {
        vehicleType = 0
        
        if UserDefaults.standard.object(forKey: "startTime") == nil {
            UserDefaults.standard.set(Date().timeIntervalSinceNow, forKey: "startTime")
        }
        
        cleaningAvailable = false
        vehicleCarNumberLbl.text = "UP 32 BJ 2345"
        if vehicleType == 0 {
            vehicleTypeLbl.text = "car"
            charge = 40
        }
        else {
            vehicleTypeLbl.text = "bike"
            charge = 20
        }
        if cleaningAvailable {
            cleaningLbl.text = "Want to avail cleaning? (cost Rs. 40)"
            checkBox.isHidden = false
        }
        else {
            cleaningLbl.text = "Cleaning not available"
            checkBox.isHidden = true
        }
        dateLbl.text = shortDate(fromDate: Date())
        entryTimeLbl.text = shortTime()
        addressLbl.text = address
        contactLbl.text = "+918181924966"
        chargeLbl.text = "Rs \(charge!) per hours"
    }
    
    fileprivate func shortDate(fromDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    fileprivate func shortTime() -> String {
        let _date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        return timeFormatter.string(from: _date)
    }
    
    @IBAction func checkoutAction(_ sender: Any) {
        let alert = UIAlertController(title: "Do you really want to checkout your car?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            UserDefaults.standard.set(Date().timeIntervalSinceNow, forKey: "startTimes")
            self.performSegue(withIdentifier: "ConfirmScanner", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (_) in
            //self.performSegue(withIdentifier: "PaymentVC", sender: self)
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmScanner" {
            
            if let vc = segue.destination as? QRScannerConfirmVC{
                
                vc.amount = charge
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func navigateAction(_ sender: Any) {
        
        self.openAppleMap(CLLocationCoordinate2DMake( 41.30, -10.20), address: address)
        
    }
    
    func openAppleMap(_ coordinate: CLLocationCoordinate2D?, address: String?) {
        
        var query = ""
        
        if let a = address {
            query = "?saddr=Current%20Location&daddr=\(a.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)" + "&directionsmode=driving"
        }
        else if let coords = coordinate {
            query = "?saddr=Current%20Location&daddr=\(coords.latitude),\(coords.longitude))" + "&directionsmode=driving"
        }
        
        guard query != "" else {
            return
        }
        
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
    
    
    @IBAction func checkBoxAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
