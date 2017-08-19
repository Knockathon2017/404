//
//  PaymentVC.swift
//  Parking
//
//  Created by Shashank Mishra on 19/08/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

import Foundation
import UIKit

class PaymentVC: UIViewController {
    @IBOutlet var checkBoxWallet: UIButton!
    @IBOutlet var checkBoxPaytm: UIButton!
    
    override func viewDidLoad() {
        checkBoxWallet.isSelected = true
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        let alert = UIAlertController(title: "Can we proceed for payment?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "RatingScreen", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (_) in
            //self.performSegue(withIdentifier: "PaymentVC", sender: self)
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func checkboxPaytmAction(_ sender: UIButton) {
        sender.isSelected = true
        checkBoxWallet.isSelected = false
        
    }
    
    
    @IBAction func checkBoxWalletAction(_ sender: UIButton) {
        sender.isSelected = true
        checkBoxPaytm.isSelected = false
    }
}
