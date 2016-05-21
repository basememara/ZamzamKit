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
        let safariActivity = UIActivity.create("Open in Safari",
            imageName: "safari-share",
            imageBundle: ZamzamConstants.bundle) {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://apple.com")!)
            }
        
        presentActivityViewController(["Some title", "Some link"], sourceView: sender,
            applicationActivities: [safariActivity])
    }

    @IBAction func barButtonTapped(sender: UIBarButtonItem) {
        presentActivityViewController(["Some title", "Some link"], barButtonItem: sender)
    }
    
}

