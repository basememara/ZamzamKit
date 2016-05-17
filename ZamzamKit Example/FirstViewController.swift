//
//  FirstViewController.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 3/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit
import ZamzamKit

class FirstViewController: UIViewController {

    @IBOutlet weak var someButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func buttonTapped(sender: UIButton) {
        presentActivityViewController(["Some title", "Some link"], sourceView: sender)
    }

}

