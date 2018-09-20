//
//  Thread.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/5/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

public extension Thread {
    typealias Block = @convention(block) () -> Void
    
    /**
     Execute block, used internally for async/sync functions.
     
     - parameter block: Process to be executed.
     */
    @objc private func run(block: Block) {
        block()
    }

    /**
     Perform block on current thread asynchronously.
     
     - parameter block: Process to be executed.
     */
    public func async(execute: @escaping Block) {
        guard Thread.current != self else { return execute() }
        perform(#selector(run(block:)), on: self, with: execute, waitUntilDone: false)
    }

    /**
     Perform block on current thread synchronously.
     
     - parameter block: Process to be executed.
     */
    public func sync(execute: @escaping Block) {
        guard Thread.current != self else { return execute() }
        perform(#selector(run(block:)), on: self, with: execute, waitUntilDone: true)
    }
}
