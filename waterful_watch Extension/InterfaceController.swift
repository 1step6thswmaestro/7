//
//  InterfaceController.swift
//  waterful_watch Extension
//
//  Created by suz on 10/9/15.
//  Copyright © 2015 suz. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    var consumed : Double = Double()
    var goal : Double = Double()
    var sipVolume : Double = Double()
    var cupVolume : Double = Double()
    var mugVolume : Double = Double()
    var bottleVolume : Double = Double()
    
    @IBOutlet var consumedLabel: WKInterfaceLabel!
    @IBOutlet var goalLabel: WKInterfaceLabel!

    @IBAction func button1Pressed() {
        sendAmount("sip")
        consumed = consumed + sipVolume
        self.updateView()
    }
    @IBAction func button2Pressed() {
        sendAmount("cup")
        consumed = consumed + cupVolume
        self.updateView()
    }
    @IBAction func button3Pressed() {
        sendAmount("mug")
        consumed = consumed + mugVolume
        self.updateView()
    }
    @IBAction func button4Pressed() {
        sendAmount("bottle")
        consumed = consumed + bottleVolume
        self.updateView()
    }
    @IBOutlet var button1: WKInterfaceButton!
    @IBOutlet var button2: WKInterfaceButton!
    @IBOutlet var button3: WKInterfaceButton!
    @IBOutlet var button4: WKInterfaceButton!
    
    @IBAction func undoPressed() {
        undoLastWaterLog()
    }
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        getStatus()
        updateView()
        
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func sendAmount(container: String){
        let applicationDict = ["container" : container]
        do {
            try session?.updateApplicationContext(applicationDict)

            
        } catch {
            print("error")
        }
    }
    
    func getStatus() {
        if WCSession.defaultSession().reachable == true{
            session?.sendMessage(["command" : "fetchStatus"],
                replyHandler: { (response) in
                    print("response in watch")
                    print(response)
                    self.consumed = response["consumed"] as! Double
                    self.goal = response["goal"] as! Double
                    self.sipVolume = response["sipVolume"] as! Double
                    self.cupVolume = response["cupVolume"] as! Double
                    self.mugVolume = response["mugVolume"] as! Double
                    self.bottleVolume = response["bottleVolume"] as! Double
                    
                    self.updateView()
                    
                }, errorHandler: { (error) in
                    NSLog("Error sending message: %@", error)
                    
                }
            )
        }
    }
    
    func updateView() {
        consumedLabel.setText(String(format:"%0.f", consumed))
        goalLabel.setText(String(format:"%0.f", goal))
        
        button1.setTitle(String(format:"%0.1f", sipVolume) + "ml")
        button2.setTitle(String(format:"%0.1f", cupVolume) + "ml")
        button3.setTitle(String(format:"%0.1f", mugVolume) + "ml")
        button4.setTitle(String(format:"%0.1f", bottleVolume) + "ml")
        
            
    }
    
    func undoLastWaterLog() {
        if WCSession.defaultSession().reachable == true {
            
            let request = ["command" : "undo"]
            let session = WCSession.defaultSession()
            
            session.sendMessage(request, replyHandler: { response in
                let res = response
                
                self.consumed = res["consumed"] as! Double
                
                self.updateView()
                
                }, errorHandler: { error in
                    print("error: \(error)")
            })
        }
    }
}
