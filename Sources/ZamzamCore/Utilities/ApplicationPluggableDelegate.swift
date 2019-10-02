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
/// The application plugins will be processed in sequence.
///
///     @UIApplicationMain
///     class AppDelegate: ApplicationPluggableDelegate {
///
///         override func plugins() -> [ApplicationPlugin] {
///             return [
///                 LoggerPlugin(),
///                 NotificationPlugin()
///             ]
///         }
///     }
///
/// Each application module has access to the `AppDelegate` lifecycle events:
///
///     final class LoggerPlugin: ApplicationPlugin {
///         private let log = Logger()
///
///         func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
///             log.config(for: application)
///             return true
///         }
///
///         func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
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
    
    /// Lazy implementation of application modules list
    public private(set) lazy var lazyPlugins: [ApplicationPlugin] = plugins()
    
    /// List of application modules for binding to `AppDelegate` events
    open func plugins() -> [ApplicationPlugin] {
        return [ /* Populated from sub-class */ ]
    }
}

public extension ApplicationPluggableDelegate {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Ensure all delegates called even if condition fails early
        //swiftlint:disable reduce_boolean
        return lazyPlugins.reduce(true) {
            $0 && $1.application(application, willFinishLaunchingWithOptions: launchOptions)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Ensure all delegates called even if condition fails early
        //swiftlint:disable reduce_boolean
        return lazyPlugins.reduce(true) {
            $0 && $1.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
}

public extension ApplicationPluggableDelegate {
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        lazyPlugins.forEach { $0.applicationWillEnterForeground(application) }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        lazyPlugins.forEach { $0.applicationDidEnterBackground(application) }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        lazyPlugins.forEach { $0.applicationDidBecomeActive(application) }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        lazyPlugins.forEach { $0.applicationWillResignActive(application) }
    }
}

public extension ApplicationPluggableDelegate {
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        lazyPlugins.forEach { $0.applicationProtectedDataWillBecomeUnavailable(application) }
    }
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        lazyPlugins.forEach { $0.applicationProtectedDataDidBecomeAvailable(application) }
    }
}

public extension ApplicationPluggableDelegate {
    
    func applicationWillTerminate(_ application: UIApplication) {
        lazyPlugins.forEach { $0.applicationWillTerminate(application) }
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        lazyPlugins.forEach { $0.applicationDidReceiveMemoryWarning(application) }
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
