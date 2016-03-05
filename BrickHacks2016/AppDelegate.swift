//
//  AppDelegate.swift
//  BrickHacks2016
//
//  Created by Annie Cheng on 3/5/16.
//  Copyright © 2016 BrickHacks. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        TLMHub.sharedHub() // Set up Myo shared hub
        TLMHub.sharedHub().shouldNotifyInBackground = true // Enable events in the background
        TLMHub.sharedHub().shouldSendUsageData = false // Prevent data from being sent to Thalmic Labs
        
        // Posted whenever a TLMMyo connects
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didConnectDevice:", name: TLMHubDidConnectDeviceNotification, object: nil)
        
        // Posted whenever a TLMMyo disconnects
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didDisconnectDevice:", name: TLMHubDidDisconnectDeviceNotification, object: nil)

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
        
        // Set up main window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.makeKeyAndVisible()
        
        toggleRootVC()
        
        return true
    }
    
    func toggleRootVC() {
        if TLMHub.sharedHub().myoDevices().count > 0 {
            print("connected to myo device")
            let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
            window?.rootViewController = homeVC
        } else {
            print("not connected to myo device")
            // Allow user to connect Myo armband if not already connected
            let settingsVC = TLMSettingsViewController()
            let navController = UINavigationController(rootViewController: settingsVC)
            window?.rootViewController = navController
        }
    }
    
    // MARK: - NSNotification
    
    func didConnectDevice(notification: NSNotification) {
        if TLMHub.sharedHub().myoDevices().count > 0 {
            if let _ = TLMHub.sharedHub().myoDevices()[0] as? TLMMyo {
                let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
                window?.rootViewController = homeVC
            }
        }
    }
    
    func didDisconnectDevice(notification: NSNotification) {
        print("myo disconnected")
    }
    
    func didSyncArm(notification: NSNotification) {
        print("myo synced")
    }
    
    func didUnsyncArm(notification: NSNotification) {
        print("myo unsynced")
    }
    
    func didUnlockDevice(notification: NSNotification) {
//        print("device unlocked")
    }
    
    func didLockDevice(notification: NSNotification) {
//        print("device locked")
    }
    
    func didReceiveOrientationEvent(notification: NSNotification) {
//        print("received orientation event")
    }
    
    func didReceiveAccelerometerEvent(notification: NSNotification) {
//        print("received acceleromter event")
    }
    
    func didReceivePoseChange(notification: NSNotification) {
//        print("received pose change")
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

