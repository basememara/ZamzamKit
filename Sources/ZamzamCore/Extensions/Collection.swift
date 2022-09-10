//
//  Collection.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-10-31.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

public extension Collection {
    /// Element at the given index if it exists.
    ///
    /// - Parameter index: index of element.
    subscript(safe index: Index) -> Element? {
        // http://www.vadimbulavin.com/handling-out-of-bounds-exception/
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Types

public extension Optional where Wrapped: Collection {
    /// A Boolean value indicating whether a collection is `nil` or has no elements.
    var isNilOrEmpty: Bool { self?.isEmpty ?? true }
}
