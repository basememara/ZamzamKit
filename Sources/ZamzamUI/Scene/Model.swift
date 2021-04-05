//
//  Model.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2019-11-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import ZamzamCore

/// The model component of the view render flow.
public protocol Model: AnyObject, Apply {}

public extension Model {
    /// Mutates the model using key path.
    ///
    ///     struct Model {
    ///         private(set) var object: String
    ///     }
    ///
    ///     print(model.object)
    ///     model(\.object, value) // guards mutations with key paths
    ///     model.object = value // compilation error
    ///
    func callAsFunction<Value>(
        _ keyPath: KeyPath<Self, Value>,
        _ value: Value
    ) {
        guard let writableKeyPath = keyPath as? ReferenceWritableKeyPath<Self, Value> else {
            #warning("Replace assertion with compile-safe guard")
            assertionFailure("Key path '\(keyPath)' is not writable.")
            return
        }

        self[keyPath: writableKeyPath] = value
    }
}

// MARK: - Helpers

public protocol ModelError: AnyObject {
    var error: ViewError? { get set }
}

public extension Model where Self: ModelError {
    func clearError() {
        self(\.error, nil)
    }
}
