//
//  Atomic.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-10-03.
//  https://basememara.com/creating-thread-safe-generic-values-in-swift/
//
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

/// An object that manages the execution of tasks atomically for thread-safety.
///
/// This will be deprecated in favour of a concurrency version.
final class Atomic<Value>: @unchecked Sendable {
    private let mutex = DispatchQueue(label: "\(DispatchQueue.labelPrefix).Atomic", attributes: .concurrent)
    private var _value: Value

    init(_ value: Value) {
        self._value = value
    }

    /// Returns or modify the thread-safe value.
    var value: Value { mutex.sync { _value } }

    /// Submits a block for synchronous, thread-safe execution.
    func value<T>(execute task: (inout Value) -> T) -> T {
        mutex.sync(flags: .barrier) { task(&_value) }
    }
}
