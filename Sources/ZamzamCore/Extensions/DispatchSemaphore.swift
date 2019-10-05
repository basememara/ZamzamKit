//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-03.
//

import Foundation

public extension DispatchSemaphore {
    
    /// Waits then signals a semaphore.
    ///
    ///     let mutex = DispatchSemaphore(value: 1)
    ///     let value = "Abc123"
    ///
    ///     // Called from multiple threads
    ///     func update(value: String) {
    ///         mutex.lock { self.value = "Xyz987" }
    ///     }
    ///
    /// The `Synchronized<Value>` uses this extension for thread-safe tasks.
    func lock<T>(execute task: () throws -> T) rethrows -> T {
        wait()
        defer { signal() }
        return try task()
    }
}
