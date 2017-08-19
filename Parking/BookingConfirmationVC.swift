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
    
    @IBAction func checkoutAction(_ sender: Any) {
        let alert = UIAlertController(title: "Do you really want to checkout your car?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "ConfirmScanner", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (_) in
            //self.performSegue(withIdentifier: "PaymentVC", sender: self)
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func navigateAction(_ sender: Any) {
        
        
        
    }
    
    @IBAction func callAction(_ sender: Any) {
        
        
        
    }
    
    
    @IBAction func checkBoxAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
