//
//  ExtensionModuleDelegate.swift
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
///     class ExtensionDelegate: ExtensionModuleDelegate {
///
///         override func modules() -> [ExtensionModule] {
///             return [
///                 LoggerApplicationModule(),
///                 LocationApplicationModule()
///             ]
///         }
///     }
///
/// Each application module has access to the `ExtensionDelegate` lifecycle events:
///
///     final class LoggerApplicationModule: ExtensionModule {
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
open class ExtensionModuleDelegate: NSObject, WKExtensionDelegate {
    
    /// Lazy implementation of application modules list
    public private(set) lazy var lazyModules: [ExtensionModule] = modules()
    
    /// List of application modules for binding to `ExtensionDelegate` events
    open func modules() -> [ExtensionModule] {
        return [ /* Populated from sub-class */ ]
    }
}

public extension ExtensionModuleDelegate {
    
    func applicationDidFinishLaunching() {
        lazyModules.forEach { $0.applicationDidFinishLaunching(.shared()) }
    }
}

public extension ExtensionModuleDelegate {
    
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
public protocol ExtensionModule {
    func applicationDidFinishLaunching(_ application: WKExtension)
    
    func applicationDidBecomeActive(_ application: WKExtension)
    func applicationWillResignActive(_ application: WKExtension)
    func applicationWillEnterForeground(_ application: WKExtension)
    func applicationDidEnterBackground(_ application: WKExtension)
}

// MARK: - Optionals

public extension ExtensionModule {
    func applicationDidFinishLaunching(_ application: WKExtension) {}
    
    func applicationDidBecomeActive(_ application: WKExtension) {}
    func applicationWillResignActive(_ application: WKExtension) {}
    func applicationWillEnterForeground(_ application: WKExtension) {}
    func applicationDidEnterBackground(_ application: WKExtension) {}
}
