//
//  ControllerModuleDelegate.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-10-20.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

/// Subclassed by the `UIViewController` to pass lifecycle events to loaded modules.
open class PluggableController: UIViewController {
    
    /// Lazy implementation of controller services list
    private lazy var lazyModules: [ControllerModule] = modules()
    
    /// List of controller services for binding to `UIViewController` events
    open func modules() -> [ControllerModule] {
        return [ /* Populated from sub-class */ ]
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        lazyModules.forEach { $0.viewDidLoad(self) }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lazyModules.forEach { $0.viewWillAppear(self) }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lazyModules.forEach { $0.viewDidAppear(self) }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lazyModules.forEach { $0.viewWillDisappear(self) }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lazyModules.forEach { $0.viewDidDisappear(self) }
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        lazyModules.forEach { $0.viewWillLayoutSubviews(self) }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lazyModules.forEach { $0.viewDidLayoutSubviews(self) }
    }
}
