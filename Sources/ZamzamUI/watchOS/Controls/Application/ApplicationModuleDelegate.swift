//
//  ApplicationModuleDelegate.swift
//  ZamzamKit watchOS
//
//  Created by Basem Emara on 2019-07-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import WatchKit

/// Subclassed by the `ExtensionDelegate` to pass lifecycle events to loaded modules.
///
/// The application modules will be processed in sequence.
///
///     class ExtensionDelegate: ApplicationModuleDelegate {
///
///         override func modules() -> [ApplicationModule] {
///             return [
///                 LoggerApplicationModule(),
///                 LocationApplicationModule()
///             ]
///         }
///     }
///
/// Each application module has access to the `ExtensionDelegate` lifecycle events:
///
///     final class LoggerApplicationModule: ApplicationModule {
///         private let log = Logger()
///
///         func applicationDidFinishLaunching(_ application: WKExtension) {
///             log.config(for: application)
///         }
///
///         func applicationDidBecomeActive(_ application: WKExtension) {
///             log.info("App did become active.")
///         }
///
///         func applicationWillResignActive(_ application: WKExtension) {
///             log.warn("App will resign active.")
///         }
///
///         func applicationWillEnterForeground(_ application: WKExtension) {
///             log.warn("App will enter foreground.")
///         }
///
///         func applicationDidEnterBackground(_ application: WKExtension) {
///             log.warn("App did enter background.")
///         }
///     }
open class ApplicationModuleDelegate: NSObject, WKExtensionDelegate {
    
    /// Lazy implementation of application modules list
    public private(set) lazy var lazyModules: [ApplicationModule] = modules()
    
    /// List of application modules for binding to `ExtensionDelegate` events
    open func modules() -> [ApplicationModule] {
        return [ /* Populated from sub-class */ ]
    }
}

public extension ApplicationModuleDelegate {
    
    func applicationDidFinishLaunching() {
        lazyModules.forEach { $0.applicationDidFinishLaunching(.shared()) }
    }
}

public extension ApplicationModuleDelegate {
    
    func applicationDidBecomeActive() {
        lazyModules.forEach { $0.applicationDidBecomeActive(.shared()) }
    }
    
    func applicationWillResignActive() {
        lazyModules.forEach { $0.applicationWillResignActive(.shared()) }
    }
    
    func applicationWillEnterForeground() {
        lazyModules.forEach { $0.applicationWillEnterForeground(.shared()) }
    }
    
    func applicationDidEnterBackground() {
        lazyModules.forEach { $0.applicationDidEnterBackground(.shared()) }
    }
}

/// Conforming to an app module and added to `ExtensionDelegate.modules()` will trigger events.
public protocol ApplicationModule {
    func applicationDidFinishLaunching(_ application: WKExtension)
    
    func applicationDidBecomeActive(_ application: WKExtension)
    func applicationWillResignActive(_ application: WKExtension)
    func applicationWillEnterForeground(_ application: WKExtension)
    func applicationDidEnterBackground(_ application: WKExtension)
}

// MARK: - Optionals

public extension ApplicationModule {
    func applicationDidFinishLaunching(_ application: WKExtension) {}
    
    func applicationDidBecomeActive(_ application: WKExtension) {}
    func applicationWillResignActive(_ application: WKExtension) {}
    func applicationWillEnterForeground(_ application: WKExtension) {}
    func applicationDidEnterBackground(_ application: WKExtension) {}
}
