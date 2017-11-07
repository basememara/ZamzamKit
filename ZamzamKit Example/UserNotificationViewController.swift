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

class UserNotificationViewController: UIViewController, StatusBarable, NotificationObservable {
    
    let sharedApplication = UIApplication.shared
    var statusBar: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver(for: .UIDeviceOrientationDidChange, selector: #selector(deviceOrientationDidChange))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Handle status bar background if applicable
        showStatusBar()
    }
    
    @objc func deviceOrientationDidChange() {
        removeStatusBar()
        showStatusBar()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UNUserNotificationCenter.current().register(
            categories: [
                ZamzamConstants.Notification.MAIN_CATEGORY: [UNNotificationAction(identifier: "snoozeAction", title: "Snooze")],
                "misc1Category": [UNNotificationAction(identifier: "misc1Action", title: "Misc 1")],
                "misc2Category": [UNNotificationAction(identifier: "misc2Action", title: "Misc 2")]
            ],
            completion: {
                guard !$0, let settings = URL(string: UIApplicationOpenSettingsURLString) else { return }
                self.present(alert: "Notification authorization not granted.",
                    buttonText: "Settings",
                    includeCancelAction: true) {
                        UIApplication.shared.open(settings)
                    }
            }
        )
    }
    
    @IBAction func scheduleTapped() {
        UNUserNotificationCenter.current().removeAll()
        
        UNUserNotificationCenter.current().add(
            body: "This is the body for time interval",
            timeInterval: 5
        )
        
        UNUserNotificationCenter.current().add(
            body: "This is the body for time interval",
            title: "This is the snooze title",
            timeInterval: 60,
            identifier: "abc123-main"
        )
        
        UNUserNotificationCenter.current().add(
            body: "This is the body for time interval",
            title: "This is the misc1 title",
            timeInterval: 60,
            identifier: "abc123-misc1",
            category: "misc1Category"
        )
        
        UNUserNotificationCenter.current().add(
            body: "This is the body for time interval",
            title: "This is the misc2 title",
            timeInterval: 60,
            identifier: "abc123-misc2",
            category: "misc2Category"
        )
        
        UNUserNotificationCenter.current().add(
            date: Date(timeIntervalSinceNow: 5),
            body: "This is the body for date",
            repeats: .minute,
            identifier: "abc123-repeat"
        )
    }
    
    @IBAction func removeTapped() {
        UNUserNotificationCenter.current().remove(withCategory: "misc2Category")
        UNUserNotificationCenter.current().remove(withIdentifier: "abc123-repeat")
    }
    

    @IBAction func barButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "notificationSegue", sender: nil)
    }
    
}

