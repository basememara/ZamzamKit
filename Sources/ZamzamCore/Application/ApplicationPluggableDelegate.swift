//
//  ApplicationPluggableDelegate.swift
//  ZamzamKit iOS
//  https://github.com/fmo91/PluggableApplicationDelegate
//
//  Created by Basem Emara on 2018-01-28.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/// Subclassed by the `AppDelegate` to pass lifecycle events to loaded plugins.
///
/// The application plugins will be processed in sequence after calling `install(plugins:)`.
///
///     @UIApplicationMain
///     class AppDelegate: ApplicationPluggableDelegate {
///
///         private let plugins: [ApplicationPlugin] = [
///             LoggerPlugin(),
///             NotificationPlugin()
///         ]
///
///         override init() {
///             super.init()
///             install(plugins)
///         }
///     }
///
/// Each application plugin has access to the `AppDelegate` lifecycle events:
///
///     final class LoggerPlugin: ApplicationPlugin {
///         private let log = Logger()
///
///         func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
///             log.config(for: application)
///             return true
///         }
///
///         func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
///             log.info("App did finish launching.")
///             return true
///         }
///
///         func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
///             log.warn("App did receive memory warning.")
///         }
///
///         func applicationWillTerminate(_ application: UIApplication) {
///             log.warn("App will terminate.")
///         }
///     }
open class ApplicationPluggableDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    private var plugins: [ApplicationPlugin] = []
    
    /// Bind application plugins to `AppDelegate` events
    public func install(_ plugins: [ApplicationPlugin]) {
        self.plugins = plugins
    }
}

extension ApplicationPluggableDelegate {
    
    open func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Ensure all delegates called even if condition fails early
        //swiftlint:disable reduce_boolean
        plugins.reduce(true) {
            $0 && $1.application(application, willFinishLaunchingWithOptions: launchOptions)
        }
    }
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Ensure all delegates called even if condition fails early
        //swiftlint:disable reduce_boolean
        plugins.reduce(true) {
            $0 && $1.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
}

extension ApplicationPluggableDelegate {
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        plugins.forEach { $0.applicationWillEnterForeground(application) }
    }
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        plugins.forEach { $0.applicationDidEnterBackground(application) }
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        plugins.forEach { $0.applicationDidBecomeActive(application) }
    }
    
    open func applicationWillResignActive(_ application: UIApplication) {
        plugins.forEach { $0.applicationWillResignActive(application) }
    }
}

extension ApplicationPluggableDelegate {
    
    open func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        plugins.forEach { $0.applicationProtectedDataWillBecomeUnavailable(application) }
    }
    
    open func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        plugins.forEach { $0.applicationProtectedDataDidBecomeAvailable(application) }
    }
}

extension ApplicationPluggableDelegate {
    
    open func applicationWillTerminate(_ application: UIApplication) {
        plugins.forEach { $0.applicationWillTerminate(application) }
    }
    
    open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        plugins.forEach { $0.applicationDidReceiveMemoryWarning(application) }
    }
}

/// Conforming to an app module and added to `AppDelegate.plugins()` will trigger events.
public protocol ApplicationPlugin {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    
    func applicationWillEnterForeground(_ application: UIApplication)
    func applicationDidEnterBackground(_ application: UIApplication)
    func applicationDidBecomeActive(_ application: UIApplication)
    func applicationWillResignActive(_ application: UIApplication)
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication)
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication)
    
    func applicationWillTerminate(_ application: UIApplication)
    func applicationDidReceiveMemoryWarning(_ application: UIApplication)
}

// MARK: - Optionals

public extension ApplicationPlugin {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { return true }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { return true }
    
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillResignActive(_ application: UIApplication) {}
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {}
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {}
    
    func applicationWillTerminate(_ application: UIApplication) {}
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {}
}

public protocol RemoteNotificationPluginDelegate: class {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
}

public extension RemoteNotificationPluginDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {}
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {}
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}
}
#endif
