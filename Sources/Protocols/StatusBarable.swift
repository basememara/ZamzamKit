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
     Adds status bar with blur background instead of being transparent.
     
     - parameter backgroundColor: Background color of status bar.
     */
    @discardableResult
    func addStatusBar(style: UIBlurEffectStyle = .regular) -> UIView? {
        guard !sharedApplication.isStatusBarHidden else { return nil }
        
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
    func showStatusBar(style: UIBlurEffectStyle = .regular) {
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
    
    func removeStatusBar() {
        statusBar?.removeFromSuperview()
        statusBar = nil
    }
}
