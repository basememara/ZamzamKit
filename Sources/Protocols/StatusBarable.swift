//
//  StatusBarControllerType.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2017-11-06.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

public protocol StatusBarable: class {
    var sharedApplication: UIApplication { get }
    var statusBar: UIView? { get set }
}

public extension StatusBarable where Self: UIViewController {
    
    /// Determine dynamic status bar height
    var statusBarSize: CGSize {
        let size = sharedApplication.statusBarFrame.size
        
        // Consider landscape and portrait mode
        // https://stackoverflow.com/a/16598350/235334
        return CGSize(
            width: max(size.width, size.height),
            height: min(size.width, size.height)
        )
    }

    /**
     Adds status bar background with color instead of being transparent.
     
     - parameter backgroundColor: Background color of status bar.
     */
    @discardableResult
    func addStatusBar(background color: UIColor) -> UIView? {
        guard !sharedApplication.isStatusBarHidden else { return nil }
        
        let statusBar = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: statusBarSize.width,
            height: statusBarSize.height
        ))
        
        statusBar.backgroundColor = color
        view.addSubview(statusBar)
        
        return statusBar
    }
    
    /**
     Adds status bar background with light or dark mode.
     
     - parameter darkMode: Light or dark mode color of status bar.
     */
    @discardableResult
    func addStatusBar(darkMode: Bool) -> UIView? {
        return addStatusBar(background: darkMode
            ? UIColor(white: 0, alpha: 0.8)
            : UIColor(rgb: (239, 239, 244), alpha: 0.8))
    }
}

public extension StatusBarable where Self: UIViewController {
    
    /// Add visible status bar since transparent by default with scrolling
    func showStatusBar() {
        let color = view.backgroundColor ?? .white
        showStatusBar(background: color.withAlphaComponent(0.8))
    }
    
    /// Add visible status bar since transparent by default with scrolling
    func showStatusBar(background color: UIColor) {
        guard let statusBar = statusBar else {
            self.statusBar = addStatusBar(background: color)
            return
        }
        
        statusBar.isHidden = false
    }
    
    /// Hides status bar
    func hideStatusBar() {
        statusBar?.isHidden = true
    }
    
    func removeStatusBar() {
        statusBar?.removeFromSuperview()
        statusBar = nil
    }
}
