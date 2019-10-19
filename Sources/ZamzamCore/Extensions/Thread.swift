//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-05.
//

import Foundation

public extension Thread {
    typealias Task = @convention(block) () -> Void
    
    /// Execute task, used internally for async/sync functions.
    /// - Parameter task: Process to be executed.
    @objc private func execute(task: Task) {
        task()
    }
    
    /// Perform task on current thread asynchronously.
    /// - Parameter task: Process to be executed.
    func async(execute task: @escaping Task) {
        guard Thread.current != self else { return task() }
        perform(#selector(execute(task:)), on: self, with: task, waitUntilDone: false)
    }
    
    /// Perform task on current thread synchronously.
    /// - Parameter task: Perform task on current thread synchronously.
    func sync(execute task: @escaping Task) {
        guard Thread.current != self else { return task() }
        perform(#selector(execute(task:)), on: self, with: task, waitUntilDone: true)
    }
}
