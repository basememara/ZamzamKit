//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-03.
//

import Foundation

public extension NSLocking {
    
    /// Attempts to acquire a lock, blocking a thread’s execution until the
    /// process can be executed, then relinquishes a previously acquired lock.
    ///
    ///     let mutex = NSLock()
    ///     let value = "Abc123"
    ///
    ///     // Called from multiple threads
    ///     func update(value: String) {
    ///         mutex.lock { self.value = "Xyz987" }
    ///     }
    ///
    /// The `Synchronized<Value>` uses this extension for thread-safe tasks.
    func lock<T>(execute task: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try task()
    }
}
