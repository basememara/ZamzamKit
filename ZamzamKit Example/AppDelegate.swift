//
//  AppDelegate.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 3/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit
import UserNotifications
import ZamzamKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let watchSession = WatchSession()

    var window: UIWindow?
    let migration = Migration()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        migration
            .performUpdate {
                print("Migrate update occurred.")
            }
            .perform(forVersion: "1.0") {
                print("Migrate to 1.0 occurred.")
            }
            .perform(forVersion: "1.0", withBuild: "1") {
                print("Migrate to 1.0 (1) occurred.")
            }
            .perform(forVersion: "1.0", withBuild: "2") {
                print("Migrate to 1.0 (2) occurred.")
            }
        
        AppDelegate.watchSession.addObserver(forApplicationContext: Observer {
            UNUserNotificationCenter.current().add(
                body: $0["value"] as? String ?? "",
                title: "Watch Transfer: Application Context",
                timeInterval: 5
            )
        })
        
        AppDelegate.watchSession.addObserver(forUserInfo: Observer {
            UNUserNotificationCenter.current().add(
                body: $0["value"] as? String ?? "",
                title: "Watch Transfer: User Info",
                timeInterval: 5
            )
        })
        
        return true
    }
}
