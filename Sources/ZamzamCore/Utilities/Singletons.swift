//
//  Singletons.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-02-06.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

/// Represents a dependency container and provides helpers for managing instances.
public protocol Singletons {}

public extension Singletons {
    /// Provides a single, thread-safe instance of the closure even if called multiple times.
    ///
    /// The file, function, and line number parameters are used to generate a unique identifier
    /// for storing the instance into an in-memory dictionary for subsequent retrievals.
    ///
    ///     protocol SomeContext: Singletons {}
    ///
    ///     extension SomeContext {
    ///
    ///         func networkService() -> NetworkService {
    ///             single {
    ///                 NetworkServiceFoundation()
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - file: The file of the declaration.
    ///   - function: The function name of the declaration.
    ///   - line: The line number of the declaration.
    ///   - instance: A closure that provides the instance.
    /// - Returns: A singleton instance backed by a private static storage.
    func single<T>(
        file: String = #fileID,
        function: String = #function,
        line: Int = #line,
        instance: () -> T
    ) -> T {
        let key = "\(Self.self)/\(file)/\(function)/\(line)/\(T.self)"

        guard let value = Single.storage.value[key] as? T else {
            let resolved = instance()
            Single.storage.value { $0[key] = resolved }
            return resolved
        }

        return value
    }

    /// Removes all the single instances stored in the dependency container.
    func reset() {
        Single.storage.value { $0.removeAll() }
    }
}

// MARK: - Helpers

private struct Single {
    static var storage = Atomic<[String: Any]>([:])
}
