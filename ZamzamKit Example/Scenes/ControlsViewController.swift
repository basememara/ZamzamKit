//
//  ControlsViewController.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 2018-09-06.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit
import SystemConfiguration

class ControlsViewController: UIViewController {
    
    @IBAction func alertButtonTapped() {
        present(alert: "Test Alert")
    }
    
    @IBAction func safariButtonTapped() {
        present(safari: "https://apple.com")
    }
    
    @IBAction func presentShareActivityTapped(_ sender: UIButton) {
        guard let link = URL(string: "https://apple.com") else { return }
        
        let safariActivity = UIActivity.make(
            title: .localized(.openInSafari),
            imageName: "safari-share",
            imageBundle: .zamzamKit,
            handler: {
                guard SCNetworkReachability.isOnline else {
                    return self.present(alert: "Device must be online to view within the browser.")
                }
            
                UIApplication.shared.open(link)
            }
        )
        
        present(
            activities: ["Test Title", link],
            popoverFrom: sender,
            applicationActivities: [safariActivity]
        )
    }
}
