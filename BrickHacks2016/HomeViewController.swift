//
//  HomeViewController.swift
//  BrickHacks2016
//
//  Created by Annie Cheng on 3/5/16.
//  Copyright © 2016 BrickHacks. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // Outlets
    @IBOutlet weak var label: UILabel!
    
    // Variables
    var currentPose: TLMPose!
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if TLMHub.sharedHub().myoDevices().count > 0 {
            if let myo = TLMHub.sharedHub().myoDevices()[0] as? TLMMyo {
                label.text = myo.name
            }
        }
        
        setUpNotifications()
    }
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Helper Functions
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) -> Void in
        }
        
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Notifications
    
    func setUpNotifications() {
        // Posted whenever the user does a successful Sync Gesture.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSyncArm:", name: TLMMyoDidReceiveArmSyncEventNotification, object: nil)
        
        // Posted whenever Myo loses sync with an arm (when Myo is taken off, or moved enough on the user's arm).
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didUnsyncArm:", name: TLMMyoDidReceiveArmUnsyncEventNotification, object: nil)
        
        // Posted whenever Myo is unlocked and the application uses TLMLockingPolicyStandard.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didUnlockDevice:", name: TLMMyoDidReceiveUnlockEventNotification, object: nil)
        
        // Posted whenever Myo is locked and the application uses TLMLockingPolicyStandard.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didLockDevice:", name: TLMMyoDidReceiveLockEventNotification, object: nil)
        
        // Posted when a new orientation event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveOrientationEvent:", name: TLMMyoDidReceiveOrientationEventNotification, object: nil)
        
        // Posted when a new accelerometer event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveAccelerometerEvent:", name: TLMMyoDidReceiveAccelerometerEventNotification, object: nil)
        
        // Posted when a new pose is available from a TLMMyo.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceivePoseChange:", name: TLMMyoDidReceivePoseChangedNotification, object: nil)
    }
    
    func didSyncArm(notification: NSNotification) {
        let armEvent = notification.userInfo![kTLMKeyArmSyncEvent]
        let armString = (armEvent!.arm == .Right) ? "Right" : "Left"
        let directionString = (armEvent!.xDirection == .TowardWrist) ? "Toward Wrist" : "Toward Elbow"

        showAlertView("Arm synced", message: "Arm: \(armString) X-direction: \(directionString)")
    }
    
    func didUnsyncArm(notification: NSNotification) {
        showAlertView("Arm synced", message: "")
    }
    
    func didUnlockDevice(notification: NSNotification) {
        print("device unlocked")
    }
    
    func didLockDevice(notification: NSNotification) {
        print("device locked")
    }
    
    func didReceiveOrientationEvent(notification: NSNotification) {
        //        print("received orientation event")
    }
    
    func didReceiveAccelerometerEvent(notification: NSNotification) {
        //        print("received acceleromter event")
    }
    
    func didReceivePoseChange(notification: NSNotification) {
        currentPose = notification.userInfo![kTLMKeyPose] as! TLMPose
        
        switch(currentPose.type) {
            case .Unknown: break
            case .Rest: break
            case .DoubleTap:
                label.text = "Double Tap"
                break
            case .Fist:
                label.text = "Fist"
                break
            case .WaveIn:
                label.text = "Wave In"
                break
            case .WaveOut:
                label.text = "Wave Out"
                break
            case .FingersSpread:
                label.text = "Fingers Spread"
                break
        }
        
        // Unlock the Myo whenever we receive a pose
        if (currentPose.type == .Unknown || currentPose.type == .Rest) {
            currentPose.myo?.unlockWithType(.Timed) // Lock Myo after a short period
        } else {
            currentPose.myo?.unlockWithType(.Hold) // Keeps the Myo unlocked until specified.
            currentPose.myo?.indicateUserAction() // Indicate that a user action has been performed.
        }
        
    }

}
