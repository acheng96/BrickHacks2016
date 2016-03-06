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
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var secondView: UIImageView!
    @IBOutlet weak var goBackButton: UIButton!
    
    @IBAction func goBackButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Variables
    var currentPose: TLMPose!
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if TLMHub.sharedHub().myoDevices().count > 0 {
            if let myo = TLMHub.sharedHub().myoDevices()[0] as? TLMMyo {
                actionLabel.text = myo.name
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
         NSNotificationCenter.defaultCenter().removeObserver(self)
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
        showAlertView("Arm synced", message: "Please perform the sync gesture.")
    }
    
    func didUnlockDevice(notification: NSNotification) {
        print("device unlocked")
    }
    
    func didLockDevice(notification: NSNotification) {
        print("device locked")
    }
    
    func didReceiveOrientationEvent(notification: NSNotification) {
        let orientationEvent = notification.userInfo![kTLMKeyOrientationEvent]
        
        // Create Euler angles from the orientation quaternion
        let angles = TLMEulerAngles(quaternion: orientationEvent!.quaternion)
        
        // Apply a rotation and perspective transformation based on the pitch, yaw, and roll
        let rotationAndPerspectiveTransform = CATransform3DConcat(CATransform3DConcat(CATransform3DRotate(CATransform3DIdentity, CGFloat(angles.pitch.radians), -1.0, 0.0, 0.0), CATransform3DRotate(CATransform3DIdentity, CGFloat(angles.yaw.radians), 0.0, 1.0, 0.0)), CATransform3DRotate(CATransform3DIdentity, CGFloat(angles.roll.radians), 0.0, 0.0, -1.0))

        // Apply the rotation and perspective transform to label
        imageView.layer.transform = rotationAndPerspectiveTransform
    }
    
    func didReceiveAccelerometerEvent(notification: NSNotification) {
        let accelerometerEvent = notification.userInfo![kTLMKeyAccelerometerEvent]
        let accelerationVector = accelerometerEvent!.vector
        let magnitude = TLMVector3Length(accelerationVector)

        // Update the progress bar based on acceleration vector magnitude.
        progressView.progress = magnitude / 8
    }
    
    func didReceivePoseChange(notification: NSNotification) {
        currentPose = notification.userInfo![kTLMKeyPose] as! TLMPose
        
        switch(currentPose.type) {
            case .Unknown: break
            case .Rest: break
            case .DoubleTap:
                actionLabel.text = "Double Tap"
            case .Fist:
                actionLabel.text = "Fist"
            case .WaveIn:
                actionLabel.text = "Wave In"
            case .WaveOut:
                actionLabel.text = "Wave Out"
            case .FingersSpread:
                actionLabel.text = "Fingers Spread"
        }
        
        // Unlock the Myo whenever we receive a pose
        if (currentPose.type == .Unknown || currentPose.type == .Rest) {
//            currentPose.myo?.unlockWithType(.Timed) // Lock Myo after a short period
        } else {
            currentPose.myo?.unlockWithType(.Hold) // Keeps the Myo unlocked until specified.
            currentPose.myo?.indicateUserAction() // Indicate that a user action has been performed.
        }
    }

}
