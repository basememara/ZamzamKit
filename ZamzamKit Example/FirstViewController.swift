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
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let safariActivity = UIActivity.create("Open in Safari",
            imageName: "safari-share",
            imageBundle: ZamzamConstants.bundle) {
                UIApplication.shared.open(NSURL(string: "http://apple.com")! as URL)
            }
        
        presentActivityViewController(["Some title", "Some link"], sourceView: sender,
            applicationActivities: [safariActivity])
    }

    @IBAction func barButtonTapped(_ sender: UIBarButtonItem) {
        presentActivityViewController(["Some title", "Some link"], barButtonItem: sender)
    }
    
}

