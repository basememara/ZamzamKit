//
//  ExtensionPluggableDelegate.swift
//  ZamzamKit watchOS
//
//  Created by Basem Emara on 2019-07-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

#if os(watchOS)
import WatchKit

/// Subclassed by the `ExtensionDelegate` to pass lifecycle events to loaded plugins.
///
/// The application plugins will be processed in sequence.
///
///     class ExtensionDelegate: ExtensionPluggableDelegate {
///
///         override func plugins() -> [ExtensionPlugin] {
///             return [
///                 LoggerPlugin(),
///                 LocationPlugin()
///             ]
///         }
///     }
///
/// Each application module has access to the `ExtensionDelegate` lifecycle events:
///
///     final class LoggerPlugin: ExtensionPlugin {
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
open class ExtensionPluggableDelegate: NSObject, WKExtensionDelegate {
    
    /// Lazy implementation of application modules list
    public private(set) lazy var lazyPlugins: [ExtensionPlugin] = plugins()
    
    /// List of application plugins for binding to `ExtensionDelegate` events
    open func plugins() -> [ExtensionPlugin] {
        [ /* Populated from sub-class */ ]
    }
}

public extension ExtensionPluggableDelegate {
    
    func applicationDidFinishLaunching() {
        lazyPlugins.forEach { $0.applicationDidFinishLaunching(.shared()) }
    }
}

public extension ExtensionPluggableDelegate {
    
    func applicationDidBecomeActive() {
        lazyPlugins.forEach { $0.applicationDidBecomeActive(.shared()) }
    }
    
    func applicationWillResignActive() {
        lazyPlugins.forEach { $0.applicationWillResignActive(.shared()) }
    }
    
    func applicationWillEnterForeground() {
        lazyPlugins.forEach { $0.applicationWillEnterForeground(.shared()) }
    }
    
    func applicationDidEnterBackground() {
        lazyPlugins.forEach { $0.applicationDidEnterBackground(.shared()) }
    }
}

/// Conforming to an app module and added to `ExtensionDelegate.plugins()` will trigger events.
public protocol ExtensionPlugin {
    func applicationDidFinishLaunching(_ application: WKExtension)
    
    func applicationDidBecomeActive(_ application: WKExtension)
    func applicationWillResignActive(_ application: WKExtension)
    func applicationWillEnterForeground(_ application: WKExtension)
    func applicationDidEnterBackground(_ application: WKExtension)
}

// MARK: - Optionals

public extension ExtensionPlugin {
    func applicationDidFinishLaunching(_ application: WKExtension) {}
    
    func applicationDidBecomeActive(_ application: WKExtension) {}
    func applicationWillResignActive(_ application: WKExtension) {}
    func applicationWillEnterForeground(_ application: WKExtension) {}
    func applicationDidEnterBackground(_ application: WKExtension) {}
}
#endif
