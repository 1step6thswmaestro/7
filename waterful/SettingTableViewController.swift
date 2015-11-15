//
//  SettingTableViewController.swift
//  waterful
//
//  Created by suz on 10/27/15.
//  Copyright © 2015 suz. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import HealthKit

class SettingTableViewController: UITableViewController{

    @IBOutlet weak var sipLabel: UITextField!
    @IBOutlet weak var cupLabel: UITextField!
    @IBOutlet weak var mugLabel: UITextField!
    @IBOutlet weak var bottleLabel: UITextField!
    @IBOutlet weak var goalLabel: UITextField!
    
    
    @IBOutlet weak var sipUnitLabel: UILabel!
    @IBOutlet weak var cupUnitLabel: UILabel!
    @IBOutlet weak var mugUnitLabel: UILabel!
    @IBOutlet weak var bottleUnitLabel: UILabel!
    @IBOutlet weak var goalUnitLabel: UILabel!
    
    @IBOutlet weak var unitButton: UIButton!
    @IBAction func unitButtonPressed(sender: AnyObject) {
        if setting_info.unit == HKUnit(fromString: "mL") {
            setting_info.unit = HKUnit(fromString: "oz")
        }
        else if setting_info.unit == HKUnit(fromString: "oz") {
            setting_info.unit = HKUnit(fromString: "mL")
        }
        updateTexts()
    }
    
    var goalVolume : Double = Double()
    var sipVolume : Double =  Double()
    var cupVolume : Double =  Double()
    var mugVolume : Double =  Double()
    var bottleVolume : Double =  Double()

    
    @IBAction func userdone(sender: AnyObject) {
        saveSetting()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    var setting_info : Setting!

    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
        
        setting_info = fetchSetting()
        
        goalVolume = (setting_info.goal?.doubleValue)!
        sipVolume = (setting_info.sipVolume?.doubleValue)!
        cupVolume = (setting_info.cupVolume?.doubleValue)!
        mugVolume = (setting_info.mugVolume?.doubleValue)!
        bottleVolume = (setting_info.bottleVolume?.doubleValue)!
        
        updateTexts()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.requestHealthKitAuthorization()
        super.viewDidLoad()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTexts (){
        if setting_info.unit == HKUnit(fromString: "mL"){
            goalLabel.text = String(format:"%0.0f", goalVolume)
            sipLabel.text = String(format:"%0.0f", sipVolume)
            cupLabel.text = String(format:"%0.0f", cupVolume)
            mugLabel.text = String(format:"%0.0f", mugVolume )
            bottleLabel.text = String(format:"%0.0f", bottleVolume)
        }
        else if setting_info.unit == HKUnit(fromString: "oz"){
            goalLabel.text = String(format:"%0.0f", goalVolume.ml_to_oz)
            sipLabel.text = String(format:"%0.0f", sipVolume.ml_to_oz)
            cupLabel.text = String(format:"%0.0f", cupVolume.ml_to_oz)
            mugLabel.text = String(format:"%0.0f", mugVolume.ml_to_oz)
            bottleLabel.text = String(format:"%0.0f", bottleVolume.ml_to_oz)
        }
        unitButton.setTitle(setting_info.unit?.description, forState: UIControlState.Normal)
        sipUnitLabel.text = setting_info.unit?.description
        cupUnitLabel.text = setting_info.unit?.description
        mugUnitLabel.text = setting_info.unit?.description
        bottleUnitLabel.text = setting_info.unit?.description
        goalUnitLabel.text = setting_info.unit?.description
        
    }
    
    func fetchSetting() -> Setting! {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Setting")
        
        let fetchResults = (try? managedContext.executeFetchRequest(fetchRequest)) as? [Setting]
        
        if (fetchResults!.count == 0){
            return nil
        }
            
        else{
            return fetchResults![0]
        }
    }
    
    func saveSetting() {
        setting_info.sipVolume = sipVolume
        setting_info.cupVolume = cupVolume
        setting_info.mugVolume = mugVolume
        setting_info.bottleVolume = bottleVolume
        setting_info.goal = goalVolume
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        do {
            // save the managet object context
            try managedObjectContext.save()
            
        } catch {
            print("Unresolved error")
            abort()
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func sipLabelChanged(sender: AnyObject) {
        if setting_info.unit == HKUnit(fromString: "mL"){
            sipVolume = Double(sipLabel.text!)!
        }
        else if setting_info.unit == HKUnit(fromString: "oz"){
            sipVolume = (Double(sipLabel.text!)!.oz_to_ml)
        }
    }
    @IBAction func cupLabelChanged(sender: AnyObject) {
        if setting_info.unit == HKUnit(fromString: "mL"){
            cupVolume = Double(cupLabel.text!)!
        }
        else if setting_info.unit == HKUnit(fromString: "oz"){
            cupVolume = (Double(cupLabel.text!)!.oz_to_ml)
        }
    }
    
    @IBAction func mugLabelChanged(sender: AnyObject) {
        if setting_info.unit == HKUnit(fromString: "mL"){
            mugVolume = Double(mugLabel.text!)!
        }
        else if setting_info.unit == HKUnit(fromString: "oz"){
            mugVolume = (Double(mugLabel.text!)!.oz_to_ml)
        }
    }

    @IBAction func bottleLabelChanged(sender: AnyObject) {
        if setting_info.unit == HKUnit(fromString: "mL"){
            bottleVolume = Double(bottleLabel.text!)!
        }
        else if setting_info.unit == HKUnit(fromString: "oz"){
            bottleVolume = (Double(bottleLabel.text!)!.oz_to_ml)
        }
    }
    @IBAction func goalLabelChanged(sender: AnyObject) {
        if setting_info.unit == HKUnit(fromString: "mL"){
            goalVolume = Double(goalLabel.text!)!
        }
        else if setting_info.unit == HKUnit(fromString: "oz"){
            goalVolume = (Double(goalLabel.text!)!.oz_to_ml)
        }
    }
    
}

extension SettingTableViewController {
    
    func requestHealthKitAuthorization() {
        let dataTypesToRead = Set(arrayLiteral: HealthManager.sharedInstance.weightType!)
        HealthManager.sharedInstance.healthKitStore.requestAuthorizationToShareTypes(nil,
            readTypes: dataTypesToRead) {
                (success, error) -> Void in

                if success {
                    print("requestHealthKitAuthorization() succeeded.")
                    self.setRecommendedWater()
                } else {
                    print("requestHealthKitAuthorization() failed.")
                }
        }
    }

    func setRecommendedWater() {

        print("set Recommended water")
        var weight: Double = 0
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        // Sample Query to get the latest weight (body mass)
        let weightSampleQuery = HKSampleQuery(sampleType: HealthManager.sharedInstance.weightType!,
            predicate: nil,
            limit: 1,
            sortDescriptors: [sortDescriptor]) {
                (query, results, error) -> Void in

                if let queryError = error {
                    print("weight query error: \(queryError.localizedDescription)")
                    return
                }

                if let queryResults = results {
                    let latestSample = queryResults[0] as! HKQuantitySample
                    weight = latestSample.quantity.doubleValueForUnit(HKUnit(fromString:"kg"))
                    print("weight: \(weight)")

                    let waterGoal = weight * 33
                    print("waterGoal: \(waterGoal)")

                    self.updateCoreDataGoal(waterGoal)
                    self.goalLabel.text = String(format: "%.1f", waterGoal)
                } else {
                    print("There are no query results.")
                    return
                }
        }
        // Execute the sample query to get the weight
        HealthManager.sharedInstance.healthKitStore.executeQuery(weightSampleQuery)
    }
    
    func updateCoreDataGoal(newGoal: Double) {

        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Setting")
        let fetchResults = (try? managedObjectContext.executeFetchRequest(fetchRequest)) as? [Setting]

        if fetchResults != nil {
            if fetchResults!.count != 0 {
                fetchResults![0].goal = newGoal
            } else {
                print("updateCoreDataGoal -- There's no fetch results from Setting.")
            }
        }
    }
    
}
