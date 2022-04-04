//
//  Limiter.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2022-04-04.
//  https://iosexample.com/autocomplete-for-a-text-field-in-swiftui-using-async-await/
//  https://peterfriese.dev/swiftui-concurrency-essentials-part2/
//  https://stackoverflow.com/a/69793838
//
//  Copyright © 2022 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate

/// A limiter that will delay work items until time limit for the preceding call is over.
///
///     let debouncer = Limiter(policy: .debounce, duration: 5)
///     var value = ""
///
///     func sendToServer() {
///         debouncer.run {
///             // Example: send to server after no typing
///             // for 5 seconds instead of once per character
///             print(value) // "hello"
///         }
///     }
///
///     value.append("h")
///     sendToServer() // Waits until 5 seconds
///
///     value.append("e")
///     sendToServer() // Waits until 5 seconds
///
///     value.append("l")
///     sendToServer() // Waits until 5 seconds
///
///     value.append("l")
///     sendToServer() // Waits until 5 seconds
///
///     value.append("o")
///     sendToServer() // Fires after 5 seconds
///
public final actor Limiter {
    public enum Policy {
        case throttle
        case debounce
    }

    private let policy: Policy
    private let duration: TimeInterval
    private var task: Task<Void, Error>?

    /// Initialize a new limiter with given delay for work items.
    ///
    /// - Parameters:
    ///   - policy: The strategy for limiting a series of executions.
    ///   - duration: The number of seconds until the execution block is called.
    public init(policy: Policy, duration: TimeInterval) {
        self.policy = policy
        self.duration = duration
    }

    /// Execute a work item and ensures it is not called until the delay is completed.
    ///
    /// - Parameter block: The work item to be invoked on the limiter with the policy.
    public func run(_ operation: @escaping () async -> Void) {
        switch policy {
        case .throttle:
            throttle(operation)
        case .debounce:
            debounce(operation)
        }
    }
}

// MARK: - Helpers

private extension Limiter {
    func throttle(_ operation: @escaping () async -> Void) {
        guard task == nil else { return }

        task = Task {
            try? await Task.sleep(seconds: duration)
            task = nil
        }

        Task {
            await operation()
        }
    }
}

private extension Limiter {
    func debounce(_ operation: @escaping () async -> Void) {
        task?.cancel()

        task = Task {
            try await Task.sleep(seconds: duration)
            await operation()
            task = nil
        }
    }
}
