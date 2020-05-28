//
//  UIViewController+LifecycleObservers.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2019-05-26.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol ViewControllerLifecycleObserver {
    func remove()
}

public extension UIViewController {
    // https://github.com/essentialdevelopercom/view-controller-lifecycle-observers
    
    /// Event that notifies the view controller is loaded into a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event.
    @discardableResult
    func viewDidLoad(execute task: @escaping () -> Void) -> ViewControllerLifecycleObserver {
        LifecycleObserver(parent: self, viewDidLoadTask: task)
    }
    
    /// Event that notifies the view controller is loaded into a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event with the view controller instance.
    @discardableResult
    func viewDidLoad(execute task: @escaping (UIViewController) -> Void) -> ViewControllerLifecycleObserver {
        LifecycleObserver(parent: self, viewDidLoadTask: { task(self) })
    }
    
    /// Event that notifies the view controller is about to be added to a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event.
    @discardableResult
    func viewWillAppear(execute task: @escaping () -> Void) -> ViewControllerLifecycleObserver {
        LifecycleObserver(parent: self, viewWillAppearTask: task)
    }
    
    /// Event that notifies the view controller is about to be added to a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event with the view controller instance.
    @discardableResult
    func viewWillAppear(execute task: @escaping (UIViewController) -> Void) -> ViewControllerLifecycleObserver {
        LifecycleObserver(parent: self, viewWillAppearTask: { task(self) })
    }
    
    /// Event that notifies the view controller was added to a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event.
    @discardableResult
    func viewDidAppear(execute task: @escaping () -> Void) -> ViewControllerLifecycleObserver {
        LifecycleObserver(parent: self, viewDidAppearTask: task)
    }
    
    /// Event that notifies the view controller was added to a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event with the view controller instance.
    @discardableResult
    func viewDidAppear(execute task: @escaping (UIViewController) -> Void) -> ViewControllerLifecycleObserver {
        LifecycleObserver(parent: self, viewDidAppearTask: { task(self) })
    }
    
    /// Event that notifies the view controller is about to be removed from a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event.
    @discardableResult
    func viewWillDisappear(execute task: @escaping () -> Void) -> ViewControllerLifecycleObserver {
        LifecycleObserver(parent: self, viewWillDisappearTask: task)
    }
    
    /// Event that notifies the view controller is about to be removed from a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event with the view controller instance.
    @discardableResult
    func viewWillDisappear(execute task: @escaping (UIViewController) -> Void) -> ViewControllerLifecycleObserver {
        LifecycleObserver(parent: self, viewWillDisappearTask: { task(self) })
    }
    
    /// Event that notifies the view controller was removed from a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event.
    @discardableResult
    func viewDidDisappear(execute task: @escaping () -> Void) -> ViewControllerLifecycleObserver {
        LifecycleObserver(parent: self, viewDidDisappearTask: task)
    }
    
    /// Event that notifies the view controller was removed from a view hierarchy.
    ///
    /// - Parameter task: The closure to execute.
    /// - Returns: The observer for unsubscribing to event with the view controller instance.
    @discardableResult
    func viewDidDisappear(execute task: @escaping (UIViewController) -> Void) -> ViewControllerLifecycleObserver {
        LifecycleObserver(parent: self, viewDidDisappearTask: { task(self) })
    }
}

private extension UIViewController {
    
    class LifecycleObserver: UIViewController, ViewControllerLifecycleObserver {
        private var viewDidLoadTask: (() -> Void)?
        private var viewWillAppearTask: (() -> Void)?
        private var viewDidAppearTask: (() -> Void)?
        private var viewWillDisappearTask: (() -> Void)?
        private var viewDidDisappearTask: (() -> Void)?
        
        convenience init(
            parent: UIViewController,
            viewDidLoadTask: (() -> Void)? = nil,
            viewWillAppearTask: (() -> Void)? = nil,
            viewDidAppearTask: (() -> Void)? = nil,
            viewWillDisappearTask: (() -> Void)? = nil,
            viewDidDisappearTask: (() -> Void)? = nil
        ) {
            self.init()
            self.viewDidLoadTask = viewDidLoadTask
            self.viewWillAppearTask = viewWillAppearTask
            self.viewDidAppearTask = viewDidAppearTask
            self.viewWillDisappearTask = viewWillDisappearTask
            self.viewDidDisappearTask = viewDidDisappearTask
            self.add(to: parent)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            viewDidLoadTask?()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            viewWillAppearTask?()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            viewDidAppearTask?()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            viewWillDisappearTask?()
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            viewDidDisappearTask?()
        }
        
        private func add(to parent: UIViewController) {
            parent.addChild(self)
            view.isHidden = true
            parent.view.addSubview(view)
            didMove(toParent: parent)
        }
    }
}
#endif
