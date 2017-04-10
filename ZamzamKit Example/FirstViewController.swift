//
//  FirstViewController.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 3/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit
import UserNotifications
import ZamzamKit

class FirstViewController: UIViewController {

    @IBOutlet weak var someButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UNUserNotificationCenter.current().register(
            actions: [UNNotificationAction(identifier: "show", title: "Tell me morezz…")],
            completion: {
                guard !$0, let settings = URL(string: UIApplicationOpenSettingsURLString) else { return }
                self.presentAlert("Notification authorization not granted.",
                    buttonText: "Settings",
                    includeCancelAction: true) {
                        UIApplication.shared.open(settings)
                    }
            }
        )
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        UNUserNotificationCenter.current().add(body: "This is the body for time intervale")
        
        UNUserNotificationCenter.current().add(
            body: "This is the body for time intervale",
            title: "This is the title",
            identifier: "abc123"
        )
        
        UNUserNotificationCenter.current().add(date: Date(timeIntervalSinceNow: 5),
            body: "This is the body for date",
            repeats: .minute
        )
    }

    @IBAction func barButtonTapped(_ sender: UIBarButtonItem) {
        presentActivityViewController(["Some title", "Some link"], barButtonItem: sender)
    }
    
}

