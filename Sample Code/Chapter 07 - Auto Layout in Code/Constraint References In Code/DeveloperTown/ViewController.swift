//
//  ViewController.swift
//  DeveloperTown
//
//  Created by Justin Williams on 7/10/15.
//  Copyright © 2015 Second Gear LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterXConstraint: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        logoWidthConstraint.constant = 128
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        print("logoCenterXConstraint.active = \(logoCenterXConstraint.active)")
    }

}

