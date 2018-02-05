//
//  PluggableController.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-02-04.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

public protocol ControllerService {
    func viewDidLoad(_ controller: UIViewController)
    
    func viewWillAppear(_ controller: UIViewController)
    func viewDidAppear(_ controller: UIViewController)
    
    func viewWillDisappear(_ controller: UIViewController)
    func viewDidDisappear(_ controller: UIViewController)
    
    func viewWillLayoutSubviews(_ controller: UIViewController)
    func viewDidLayoutSubviews(_ controller: UIViewController)
}

public extension ControllerService {
    func viewDidLoad(_ controller: UIViewController) {}
    
    func viewWillAppear(_ controller: UIViewController) {}
    func viewDidAppear(_ controller: UIViewController) {}
    
    func viewWillDisappear(_ controller: UIViewController) {}
    func viewDidDisappear(_ controller: UIViewController) {}
    
    func viewWillLayoutSubviews(_ controller: UIViewController) {}
    func viewDidLayoutSubviews(_ controller: UIViewController) {}
}

open class PluggableController: UIViewController {
    
    private(set) open lazy var services: [ControllerService] = {
        [ /* Populated from sub-class */ ]
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        services.forEach { $0.viewDidLoad(self) }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        services.forEach { $0.viewWillAppear(self) }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        services.forEach { $0.viewDidAppear(self) }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        services.forEach { $0.viewWillDisappear(self) }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        services.forEach { $0.viewDidDisappear(self) }
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        services.forEach { $0.viewWillLayoutSubviews(self) }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        services.forEach { $0.viewDidLayoutSubviews(self) }
    }
}
