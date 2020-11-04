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
public struct Atomic<Value> {
    private let mutex = DispatchQueue(label: "\(DispatchQueue.labelPrefix).Atomic", attributes: .concurrent)
    private var _value: Value

    public init(_ value: Value) {
        self._value = value
    }

    /// Returns or modify the thread-safe value.
    public var value: Value { mutex.sync { _value } }

    /// Submits a block for synchronous, thread-safe execution.
    public mutating func value<T>(execute task: (inout Value) -> T) -> T {
        mutex.sync(flags: .barrier) { task(&_value) }
    }
}
