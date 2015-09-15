//
//  ViewController.swift
//  DeveloperTown
//
//  Created by Justin Williams on 7/10/15.
//  Copyright © 2015 Second Gear LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        print("self.view.constraints = \(self.view.constraints)")
    }

}

