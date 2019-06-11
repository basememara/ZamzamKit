//
//  PluggableApplicationDelegate.swift
//  ZamzamKit iOS
//  https://github.com/fmo91/PluggableApplicationDelegate
//
//  Created by Basem Emara on 2018-01-28.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

/// Subclassed by the `AppDelegate` to pass lifecycle events to loaded modules.
///
/// The application modules will be processed in sequence.
///
///     @UIApplicationMain
///     class AppDelegate: ApplicationModuleDelegate {
///
///         override func modules() -> [ApplicationModule] {
///             return [
///                 LoggerApplicationModule(),
///                 NotificationApplicationModule()
///             ]
///         }
///     }
///
/// Each application module has access to the `AppDelegate` lifecycle events:
///
///     final class LoggerApplicationModule: ApplicationModule {
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
open class ApplicationModuleDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    
    /// Lazy implementation of application modules list
    public private(set) lazy var lazyModules: [ApplicationModule] = modules()
    
    /// List of application modules for binding to `AppDelegate` events
    open func modules() -> [ApplicationModule] {
        return [ /* Populated from sub-class */ ]
    }
}

public extension ApplicationModuleDelegate {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return lazyModules.reduce(true) {
            $0 && $1.application(application, willFinishLaunchingWithOptions: launchOptions)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return lazyModules.reduce(true) {
            $0 && $1.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
}

public extension ApplicationModuleDelegate {
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        lazyModules.forEach { $0.applicationWillEnterForeground(application) }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        lazyModules.forEach { $0.applicationDidEnterBackground(application) }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        lazyModules.forEach { $0.applicationDidBecomeActive(application) }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        lazyModules.forEach { $0.applicationWillResignActive(application) }
    }
}

public extension ApplicationModuleDelegate {
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        lazyModules.forEach { $0.applicationProtectedDataWillBecomeUnavailable(application) }
    }
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        lazyModules.forEach { $0.applicationProtectedDataDidBecomeAvailable(application) }
    }
}

public extension ApplicationModuleDelegate {
    
    func applicationWillTerminate(_ application: UIApplication) {
        lazyModules.forEach { $0.applicationWillTerminate(application) }
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        lazyModules.forEach { $0.applicationDidReceiveMemoryWarning(application) }
    }
}
