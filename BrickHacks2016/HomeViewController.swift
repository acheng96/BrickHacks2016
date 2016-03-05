//
//  HomeViewController.swift
//  BrickHacks2016
//
//  Created by Annie Cheng on 3/5/16.
//  Copyright © 2016 BrickHacks. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("home vc")

        if TLMHub.sharedHub().myoDevices().count > 0 {
            if let myo = TLMHub.sharedHub().myoDevices()[0] as? TLMMyo {
                label.text = myo.name
            }
        }
    }
    
    // Initialization
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
