//
//  RatingVC.swift
//  Parking
//
//  Created by Shashank Mishra on 19/08/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

import Foundation
import UIKit

class RatingVC: UIViewController {
    @IBOutlet var star1: UIButton!
    @IBOutlet var star2: UIButton!
    @IBOutlet var star3: UIButton!
    @IBOutlet var star4: UIButton!
    @IBOutlet var star5: UIButton!
    var rating: Int = 0
    
    @IBOutlet var feedbackTextView: UITextView!
    @IBOutlet var confirmButton: UIButton!
    
    @IBAction func cancelButton(_ sender: UIButton) {
         self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func star1Action(_ sender: UIButton) {
        sender.isSelected = true
        star2.isSelected = false
        star3.isSelected = false
        star4.isSelected = false
        star5.isSelected = false
        rating = 1
    }
    
    @IBAction func star2Action(_ sender: UIButton) {
        sender.isSelected = true
        star1.isSelected = true
        star3.isSelected = false
        star4.isSelected = false
        star5.isSelected = false
        rating = 2
    }
    
    @IBAction func star3Action(_ sender: UIButton) {
        sender.isSelected = true
        star1.isSelected = true
        star2.isSelected = true
        star4.isSelected = false
        star5.isSelected = false
        rating = 3
    }
    
    @IBAction func star4Action(_ sender: UIButton) {
        sender.isSelected = true
        star1.isSelected = true
        star2.isSelected = true
        star3.isSelected = true
        star5.isSelected = false
        rating = 4
    }
    
    @IBAction func star5Action(_ sender: UIButton) {
        sender.isSelected = true
        star1.isSelected = true
        star2.isSelected = true
        star3.isSelected = true
        star4.isSelected = true
        rating = 5
    }
}
