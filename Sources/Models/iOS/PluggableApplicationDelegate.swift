//
//  PluggableApplicationDelegate.swift
//  ZamzamKit iOS
//  https://github.com/fmo91/PluggableApplicationDelegate
//
//  Created by Basem Emara on 2018-01-28.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

public protocol ApplicationService {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    
    func applicationWillEnterForeground(_ application: UIApplication)
    func applicationDidEnterBackground(_ application: UIApplication)
    func applicationDidBecomeActive(_ application: UIApplication)
    func applicationWillResignActive(_ application: UIApplication)
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication)
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication)
    
    func applicationWillTerminate(_ application: UIApplication)
    func applicationDidReceiveMemoryWarning(_ application: UIApplication)
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
}

// MARK: - Optionals

public extension ApplicationService {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool { return true }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool { return true }
    
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillResignActive(_ application: UIApplication) {}
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {}
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {}
    
    func applicationWillTerminate(_ application: UIApplication) {}
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {}
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {}
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}
}

open class PluggableApplicationDelegate: UIResponder, UIApplicationDelegate {
    
    public var window: UIWindow?
    
    open func requestServices() -> [ApplicationService] {
        return []
    }
}

public extension PluggableApplicationDelegate {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        return requestServices().reduce(true) {
            $0 && $1.application(application, willFinishLaunchingWithOptions: launchOptions)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return requestServices().reduce(true) {
            $0 && $1.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
}

public extension PluggableApplicationDelegate {
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        requestServices().forEach { $0.applicationWillEnterForeground(application) }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        requestServices().forEach { $0.applicationDidEnterBackground(application) }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        requestServices().forEach { $0.applicationDidBecomeActive(application) }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        requestServices().forEach { $0.applicationWillResignActive(application) }
    }
}

public extension PluggableApplicationDelegate {
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        requestServices().forEach { $0.applicationProtectedDataWillBecomeUnavailable(application) }
    }
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        requestServices().forEach { $0.applicationProtectedDataDidBecomeAvailable(application) }
    }
}

public extension PluggableApplicationDelegate {
    
    func applicationWillTerminate(_ application: UIApplication) {
        requestServices().forEach { $0.applicationWillTerminate(application) }
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        requestServices().forEach { $0.applicationDidReceiveMemoryWarning(application) }
    }
}

public extension PluggableApplicationDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        requestServices().forEach { $0.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        requestServices().forEach { $0.application(application, didFailToRegisterForRemoteNotificationsWithError: error) }
    }
}
