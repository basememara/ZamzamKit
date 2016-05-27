//
//  Restorable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/27/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

/// Queue handlers to process on view appear.
protocol Restorable: class {
    var restorationHandlers: [() -> Void] { get set }
}

extension Restorable where Self: UIViewController {

    func willRestorableAppear() {
        // Execute any awaiting tasks
        restorationHandlers.removeEach {
            handler in handler()
        }
    }
    
    func performRestoration(handler: () -> Void) {
        // Execute process in the right lifecycle
        if isViewLoaded() {
            handler()
        } else {
            // Delay execution until view ready
            restorationHandlers.append(handler)
        }
    }
}