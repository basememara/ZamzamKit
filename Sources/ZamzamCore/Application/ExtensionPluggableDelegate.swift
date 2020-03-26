//
//  ExtensionPluggableDelegate.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-07-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

#if os(watchOS)
import WatchKit

/// Subclassed by the `ExtensionDelegate` to pass lifecycle events to loaded plugins.
///
/// The application plugins will be processed in sequence after calling `plugins() -> [ExtensionPlugin]`.
///
///     class ExtensionDelegate: ExtensionPluggableDelegate {
///
///         override func plugins() -> [ExtensionPlugin] {[
///             LoggerPlugin(),
///             LocationPlugin()
///         ]}
///     }
///
/// Each application plugin has access to the `ExtensionDelegate` lifecycle events:
///
///     struct LoggerPlugin: ExtensionPlugin {
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
///             log.warning("App will resign active.")
///         }
///
///         func applicationWillEnterForeground(_ application: WKExtension) {
///             log.warning("App will enter foreground.")
///         }
///
///         func applicationDidEnterBackground(_ application: WKExtension) {
///             log.warning("App did enter background.")
///         }
///     }
open class ExtensionPluggableDelegate: NSObject, WKExtensionDelegate {
    
    /// List of application plugins for binding to `ExtensionDelegate` events
    public private(set) lazy var pluginInstances: [ExtensionPlugin] = { plugins() }()
    
    public override init() {
        super.init()
        
        // Load lazy property early
        _ = pluginInstances
    }
    
    /// List of application plugins for binding to `ExtensionDelegate` events
    open func plugins() -> [ExtensionPlugin] {[]} // Override
}

public extension ExtensionPluggableDelegate {
    
    func applicationDidFinishLaunching() {
        pluginInstances.forEach { $0.applicationDidFinishLaunching(.shared()) }
    }
}

public extension ExtensionPluggableDelegate {
    
    func applicationDidBecomeActive() {
        pluginInstances.forEach { $0.applicationDidBecomeActive(.shared()) }
    }
    
    func applicationWillResignActive() {
        pluginInstances.forEach { $0.applicationWillResignActive(.shared()) }
    }
    
    func applicationWillEnterForeground() {
        pluginInstances.forEach { $0.applicationWillEnterForeground(.shared()) }
    }
    
    func applicationDidEnterBackground() {
        pluginInstances.forEach { $0.applicationDidEnterBackground(.shared()) }
    }
}

/// Conforming to an app plugin and added to `ExtensionDelegate.application()` will trigger events.
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
