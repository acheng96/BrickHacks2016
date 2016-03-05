//
//  FeedbackViewController.swift
//  BrickHacks2016
//
//  Created by Annie Cheng on 3/5/16.
//  Copyright © 2016 BrickHacks. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var pictureDescription: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    @IBAction func tryAgainButtonPressed(sender: UIButton) {
    }
    
    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
