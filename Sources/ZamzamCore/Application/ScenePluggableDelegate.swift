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
extension ScenePluggableDelegate {
    
    open func sceneWillEnterForeground(_ scene: UIScene) {
        pluginInstances.forEach { $0.sceneWillEnterForeground() }
    }
    
    open func sceneDidEnterBackground(_ scene: UIScene) {
        pluginInstances.forEach { $0.sceneDidEnterBackground() }
    }
    
    open func sceneDidBecomeActive(_ scene: UIScene) {
        pluginInstances.forEach { $0.sceneDidBecomeActive() }
    }
    
    open func sceneWillResignActive(_ scene: UIScene) {
        pluginInstances.forEach { $0.sceneWillResignActive() }
    }
    
    open func sceneDidDisconnect(_ scene: UIScene) {
        pluginInstances.forEach { $0.sceneDidDisconnect() }
    }
}

/// Conforming to an scene module and added to `SceneDelegate.plugins()` will trigger events.
public protocol ScenePlugin {
    
    /// Tells the delegate that the scene is about to begin running in the foreground and become visible to the user.
    func sceneWillEnterForeground()
    
    /// Tells the delegate that the scene is running in the background and is no longer onscreen.
    func sceneDidEnterBackground()
    
    /// Tells the delegate that the scene became active and is now responding to user events.
    func sceneDidBecomeActive()
    
    /// Tells the delegate that the scene is about to resign the active state and stop responding to user events.
    func sceneWillResignActive()
    
    /// Tells the delegate that UIKit removed a scene from your app.
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
