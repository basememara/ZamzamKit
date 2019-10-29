//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-28.
//

#if os(iOS)
import UIKit

/// Subclassed by the `SceneDelegate` to pass lifecycle events to loaded plugins.
///
/// The scene plugins will be processed in sequence after calling `plugins() -> [ScenePlugin]`.
///
///     class SceneDelegate: ScenePluggableDelegate {
///
///         override func plugins() -> [ScenePlugin] {[
///             LoggerPlugin(),
///             NotificationPlugin()
///         ]}
///     }
///
/// Each scene plugin has access to the `SceneDelegate` lifecycle events:
///
///     final class LoggerPlugin: ScenePlugin {
///         private let log = Logger()
///
///         func sceneWillEnterForeground() {
///             log.info("Scene will enter foreground.")
///         }
///
///         func sceneDidEnterBackground() {
///             log.info("Scene did enter background.")
///         }
///     }
@available(iOS 13.0, *)
open class ScenePluggableDelegate: UIResponder, UIWindowSceneDelegate {
    public var window: UIWindow?
    
    /// List of scene plugins for binding to `SceneDelegate` events
    public private(set) lazy var pluginInstances: [ScenePlugin] = { plugins() }()
    
    public override init() {
        super.init()
        
        // Load lazy property early
        _ = pluginInstances
    }
    
    /// List of scene plugins for binding to `SceneDelegate` events
    open func plugins() -> [ScenePlugin] {[]} // Override
}

@available(iOS 13.0, *)
public extension ScenePluggableDelegate {
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        pluginInstances.forEach { $0.sceneWillEnterForeground() }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        pluginInstances.forEach { $0.sceneDidEnterBackground() }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        pluginInstances.forEach { $0.sceneDidBecomeActive() }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        pluginInstances.forEach { $0.sceneWillResignActive() }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        pluginInstances.forEach { $0.sceneDidDisconnect() }
    }
}

/// Conforming to an scene module and added to `SceneDelegate.plugins()` will trigger events.
public protocol ScenePlugin {
    func sceneWillEnterForeground()
    func sceneDidEnterBackground()
    func sceneDidBecomeActive()
    func sceneWillResignActive()
    func sceneDidDisconnect()
}

// MARK: - Optionals

public extension ScenePlugin {
    func sceneWillEnterForeground() {}
    func sceneDidEnterBackground() {}
    func sceneDidBecomeActive() {}
    func sceneWillResignActive() {}
    func sceneDidDisconnect() {}
}
#endif
