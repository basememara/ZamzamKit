//
//  Thread.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/5/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation

public extension Thread {
    typealias Block = @convention(block) () -> Void
    
    /**
     Execute block, used internally for async/sync functions.
     
     - parameter block: Process to be executed.
     */
    @objc private func execute(block: Block) {
        block()
    }
    
    /**
     Perform block on current thread asynchronously.
     
     - parameter task: Process to be executed.
     */
    func async(execute task: @escaping Block) {
        guard Thread.current != self else { return task() }
        perform(#selector(execute(block:)), on: self, with: task, waitUntilDone: false)
    }
    
    /**
     Perform block on current thread synchronously.
     
     - parameter task: Process to be executed.
     */
    func sync(execute task: @escaping Block) {
        guard Thread.current != self else { return task() }
        perform(#selector(execute(block:)), on: self, with: task, waitUntilDone: true)
    }
}
