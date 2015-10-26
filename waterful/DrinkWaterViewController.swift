//
//  DrinkWaterViewController.swift
//  waterful
//
//  Created by suz on 10/9/15.
//  Copyright © 2015 suz. All rights reserved.
//


import UIKit
import CoreData

class DrinkWaterViewController: UIViewController {
    
    @IBOutlet weak var waterInput: UITextField!
    
    var amount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func button1Pressed(sender: AnyObject) {
        amount = amount + 40
        waterInput.text = String(amount)
    }
    @IBAction func button2Pressed(sender: AnyObject) {
        amount = amount + 120
        waterInput.text = String(amount)
    }
    @IBAction func button3Pressed(sender: AnyObject) {
        amount = amount + 400
        waterInput.text = String(amount)
    }
    @IBAction func button4Pressed(sender: AnyObject) {
        amount = amount + 500
        waterInput.text = String(amount)
    }
    
}

