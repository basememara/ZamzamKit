//
//  StatusBarControllerType.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2017-11-06.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import UIKit

/// Manages status bar view.
///
/// Redraw on device orientation change.
///
///     class ViewController: UIViewController, StatusBarable {
///
///         let application = UIApplication.shared
///         var statusBar: UIView?
///
///         override func viewDidLoad() {
///             showStatusBar()
///
///             NotificationCenter.default.addObserver(
///                 for: UIDevice.orientationDidChangeNotification,
///                 selector: #selector(deviceOrientationDidChange),
///                 from: self
///             )
///         }
///     }
///
///     private extension ViewController {
///
///         @objc func deviceOrientationDidChange() {
///             removeStatusBar()
///             showStatusBar()
///         }
///     }
public protocol StatusBarable: class {
    var application: UIApplication { get }
    var statusBar: UIView? { get set }
}

public extension StatusBarable where Self: UIViewController {
    
    /// Determine dynamic status bar size
    var statusBarSize: CGSize {
        let size = application.statusBarFrame.size
        
        // Consider landscape and portrait mode
        // https://stackoverflow.com/a/16598350
        return CGSize(
            width: max(size.width, size.height),
            height: min(size.width, size.height)
        )
    }

    /// Adds status bar with blur background instead of being transparent.
    ///
    /// - Parameter style: Background color of status bar.
    /// - Returns: The status bar instance.
    @discardableResult
    func addStatusBar(style: UIBlurEffect.Style = .regular) -> UIView? {
        guard !application.isStatusBarHidden else { return nil }
        
        let statusBar = UIVisualEffectView().with {
            $0.effect = UIBlurEffect(style: style)
            $0.frame = CGRect(
                x: 0,
                y: 0,
                width: statusBarSize.width,
                height: statusBarSize.height
            )
        }
        
        view.addSubview(statusBar)
        
        return statusBar
    }
}

public extension StatusBarable where Self: UIViewController {
    
    /// Add visible status bar since transparent by default with scrolling
    func showStatusBar(style: UIBlurEffect.Style = .regular) {
        guard let statusBar = statusBar else {
            self.statusBar = addStatusBar(style: style)
            return
        }
        
        statusBar.isHidden = false
    }
    
    /// Hides status bar
    func hideStatusBar() {
        statusBar?.isHidden = true
    }
    
    /// Unlinks the status bar from its superview and its window, and removes it from the responder chain.
    func removeStatusBar() {
        statusBar?.removeFromSuperview()
        statusBar = nil
    }
}
