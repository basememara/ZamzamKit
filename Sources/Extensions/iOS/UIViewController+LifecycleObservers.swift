//
//  UIViewController+LifecycleObservers.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2019-05-26.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

public protocol ViewControllerLifecycleObserver {
    func remove()
}

public extension UIViewController {
    // https://github.com/essentialdevelopercom/view-controller-lifecycle-observers
    
    /// Event that notifies the view controller is about to be added to a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event.
    @discardableResult
    func viewWillAppear(execute task: @escaping (UIViewController?) -> Void) -> ViewControllerLifecycleObserver {
        return LifecycleObserver(parent: self, viewWillAppearTask: task)
    }
    
    /// Event that notifies the view controller was added to a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event.
    @discardableResult
    func viewDidAppear(execute task: @escaping (UIViewController?) -> Void) -> ViewControllerLifecycleObserver {
        return LifecycleObserver(parent: self, viewDidAppearTask: task)
    }
    
    /// Event that notifies the view controller is about to be removed from a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event.
    @discardableResult
    func viewWillDisappear(execute task: @escaping (UIViewController?) -> Void) -> ViewControllerLifecycleObserver {
        return LifecycleObserver(parent: self, viewWillDisappearTask: task)
    }
    
    /// Event that notifies the view controller was removed from a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event.
    @discardableResult
    func viewDidDisappear(execute task: @escaping (UIViewController?) -> Void) -> ViewControllerLifecycleObserver {
        return LifecycleObserver(parent: self, viewDidDisappearTask: task)
    }
    
    private class LifecycleObserver: UIViewController, ViewControllerLifecycleObserver {
        private var viewWillAppearTask: ((UIViewController?) -> Void)?
        private var viewDidAppearTask: ((UIViewController?) -> Void)?
        private var viewWillDisappearTask: ((UIViewController?) -> Void)?
        private var viewDidDisappearTask: ((UIViewController?) -> Void)?
        
        convenience init(
            parent: UIViewController,
            viewWillAppearTask: ((UIViewController?) -> Void)? = nil,
            viewDidAppearTask: ((UIViewController?) -> Void)? = nil,
            viewWillDisappearTask: ((UIViewController?) -> Void)? = nil,
            viewDidDisappearTask: ((UIViewController?) -> Void)? = nil
        ) {
            self.init()
            self.viewWillAppearTask = viewWillAppearTask
            self.viewDidAppearTask = viewDidAppearTask
            self.viewWillDisappearTask = viewWillDisappearTask
            self.viewDidDisappearTask = viewDidDisappearTask
            self.add(to: parent)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            viewWillAppearTask?(parent)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            viewDidAppearTask?(parent)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            viewWillDisappearTask?(parent)
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            viewDidDisappearTask?(parent)
        }
        
        private func add(to parent: UIViewController) {
            parent.addChild(self)
            view.isHidden = true
            parent.view.addSubview(view)
            didMove(toParent: parent)
        }
    }
}
