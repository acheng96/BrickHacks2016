//
//  StartViewController.swift
//  BrickHacks2016
//
//  Created by Annie Cheng on 3/5/16.
//  Copyright © 2016 BrickHacks. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    // Outlets
    @IBOutlet weak var startButton: UIButton!
    @IBAction func startButtonClicked(sender: UIButton) {
        goToHomeVC()
    }
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceivePoseChange:", name: TLMMyoDidReceivePoseChangedNotification, object: nil)
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
    
    func goToHomeVC() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        presentViewController(homeVC, animated: true, completion: nil)
    }
    
    // MARK: - Notifications
    
    func didReceivePoseChange(notification: NSNotification) {
        let currentPose = notification.userInfo![kTLMKeyPose] as! TLMPose
        print("pose detected")
        
        switch(currentPose.type) {
        case .Unknown:
            print("unknown")
        case .Rest:
            print("rest")
        case .DoubleTap:
            print("double tap")
            goToHomeVC()
        case .Fist:
            print("fist")
        case .WaveIn:
            print("wave in")
        case .WaveOut:
            print("wave out")
        case .FingersSpread:
            print("finger spread")
        }
    }

}
