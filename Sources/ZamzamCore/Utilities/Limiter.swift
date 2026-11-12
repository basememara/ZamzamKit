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

/// Limits how often work runs, by throttling or debouncing calls.
///
///     let limiter = Limiter(policy: .debounce, duration: 0.5)
///
///     func textChanged(to text: String) async {
///         await limiter.run {
///             // Runs once typing has paused for half a second
///             await search(for: text)
///         }
///     }
public actor Limiter {
    /// How a limiter treats calls that come close together.
    public enum Policy: Sendable {
        /// Runs a call at once, then drops every call until the duration has passed.
        case throttle
        /// Waits for the duration after the latest call and runs that one. The calls before it are dropped.
        case debounce
    }

    private let policy: Policy
    private let duration: TimeInterval
    private var task: Task<Void, Error>?

    /// Creates a limiter.
    ///
    /// - Parameter duration: The seconds a throttle stays closed after a call, or a debounce waits after the latest one.
    public init(policy: Policy, duration: TimeInterval) {
        self.policy = policy
        self.duration = duration
    }

    /// Runs the operation, delays it or drops it, as the policy decides. Returns without waiting for the operation.
    public func run(_ operation: @escaping @Sendable () async -> Void) {
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
    func throttle(_ operation: @escaping @Sendable () async -> Void) {
        guard task == nil else { return }

        task = Task {
            try? await Task.sleep(for: .seconds(duration))
            task = nil
        }

        Task {
            await operation()
        }
    }
}

private extension Limiter {
    func debounce(_ operation: @escaping @Sendable () async -> Void) {
        task?.cancel()

        // Cleared before the operation runs, so one still running can't clear a newer call's task
        task = Task {
            try await Task.sleep(for: .seconds(duration))
            task = nil
            await operation()
        }
    }
}
