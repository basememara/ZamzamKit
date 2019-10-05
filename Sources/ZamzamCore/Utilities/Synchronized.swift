//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-03.
//

import Foundation

/// An object that manages the execution of tasks atomically.
public struct Synchronized<Value> {
    private let mutex = DispatchSemaphore(value: 1)
    private var _value: Value

    public init(_ value: Value) {
        self._value = value
    }
    
    /// Returns or modify the value.
    public var value: Value { mutex.lock { _value } }
    
    /// Submits a block for synchronous execution with this lock.
    public mutating func value<T>(execute task: (inout Value) throws -> T) rethrows -> T {
        try mutex.lock { try task(&_value) }
    }
}
