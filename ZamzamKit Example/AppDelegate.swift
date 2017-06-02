//
//  AppDelegate.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 3/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit
import ZamzamKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

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
        
        return true
    }
}
