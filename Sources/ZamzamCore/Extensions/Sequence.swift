//
//  Sequence.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-09-10.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

public extension Sequence {
    /// Returns the elements sorted by the value at a key path, ordered by the given predicate.
    ///
    ///     people.sorted(by: \.age, >)
    func sorted<T>(by keyPath: KeyPath<Element, T>, _ comparator: (T, T) throws -> Bool) rethrows -> [Element] {
        try sorted { try comparator($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    /// Returns the elements sorted by the value at a key path, in ascending order.
    ///
    ///     people.sorted(by: \.name)
    func sorted(by keyPath: KeyPath<Element, some Comparable>) -> [Element] {
        sorted(by: keyPath, <)
    }
}
