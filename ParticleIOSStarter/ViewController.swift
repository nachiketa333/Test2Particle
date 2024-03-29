//
//  ViewController.swift
//  ParticleIOSStarter
//
//  Created by Parrot on 2019-06-29.
//  Copyright © 2019 Parrot. All rights reserved.

import UIKit
import Particle_SDK

class ViewController: UIViewController {

    // MARK: User variables
    let USERNAME = "nachiketa0333@gmail.com"
    let PASSWORD = "nachiketa03"
    
    // MARK: Device
    // Jenelle's device
    //let DEVICE_ID = "36001b001047363333343437"
    // Antonio's device
    let DEVICE_ID = "230044001247363333343437"
    var myPhoton : ParticleDevice?

    // MARK: Other variables
    var gameScore:Int = 0

    
    @IBOutlet weak var messageLabel: UILabel!
    // MARK: Outlets
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Initialize the SDK
        ParticleCloud.init()
 
        // 2. Login to your account
        ParticleCloud.sharedInstance().login(withUser: self.USERNAME, password: self.PASSWORD) { (error:Error?) -> Void in
            if (error != nil) {
                // Something went wrong!
                print("Wrong credentials or as! ParticleCompletionBlock no internet connectivity, please try again")
                // Print out more detailed information
                print(error?.localizedDescription)
            }
            else {
                print("Login success!")

                // try to get the device
                self.getDeviceFromCloud()

            }
        } // end login
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Get Device from Cloud
    // Gets the device from the Particle Cloud
    // and sets the global device variable
    func getDeviceFromCloud() {
        ParticleCloud.sharedInstance().getDevice(self.DEVICE_ID) { (device:ParticleDevice?, error:Error?) in
            
            if (error != nil) {
                print("Could not get device")
                print(error?.localizedDescription)
                return
            }
            else {
                print("Got photon from cloud: \(device?.id)")
                self.myPhoton = device
                
                // subscribe to events
                self.subscribeToParticleEvents()
            }
            
        } // end getDevice()
    }
    
    
    //MARK: Subscribe to "playerChoice" events on Particle
    func subscribeToParticleEvents() {
        var handler : Any?
        handler = ParticleCloud.sharedInstance().subscribeToDeviceEvents(
            withPrefix: "playerChoice",
            deviceID:self.DEVICE_ID,
            handler: {
                (event :ParticleEvent?, error : Error?) in
            
            if let _ = error {
                print("could not subscribe to events")
            } else {
                print("got event with data \(event?.data)")
                let choice = (event?.data)!
                if (choice == "A") {
                    self.smileAnimation()
                    self.gameScore = self.gameScore + 1;
                }
                else if (choice == "B") {
                    self.smileSlow()
                }
            }
        })
    }
    
    
    
    func smileAnimation() {
        
        print("Pressed the change lights button")
        
        let parameters = ["smile"]
        var task = myPhoton!.callFunction("answer", withArguments: parameters) {
            (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Sent message to Particle for Smile Animation")
            }
            else {
                print("Error when telling Particle to Smile")
            }
        }
        //var bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
        
    }
    
    func smileSlow() {
        
        print("Pressed the change lights button")
        
        let parameters = ["smileSlow"]
        var task = myPhoton!.callFunction("answer", withArguments: parameters) {
            (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Sent message to Particle for Smile Animation")
            }
            else {
                print("Error when telling Particle to Smile")
            }
        }
        //var bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
        
    }
   
    
    var countdownTimer: Timer!
    var totalTime = 20
    
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTime() {
        scoreLabel.text = ("\(timeFormatted(totalTime))")
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @IBAction func powerUpButtonPressed(_ sender: Any) {
        
        totalTime = 30;
         startTimer();
        smileSlow();
        messageLabel.text = ("MOHAMMAD'S IS Fighting VIRUS!!")
        
    }
    
    @IBAction func testScoreButtonPressed(_ sender: Any) {
        
        totalTime = 25;
        startTimer();
        self.smileAnimation();
        messageLabel.text = ("VIRUS is Spreading FAST!!")
        
        }
        
        
        
        // 3. done!
        
        
    }
    


