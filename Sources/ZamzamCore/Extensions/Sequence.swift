//
//  Sequence.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-09-10.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

public extension Sequence {
    /// Returns the elements of the sequence, sorted using the keypath and given predicate as the comparison between elements.
    func sorted<T>(by keyPath: KeyPath<Element, T>, _ comparator: (T, T) throws -> Bool) rethrows -> [Element] {
        try sorted { try comparator($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    /// Returns the elements of the sequence, sorted using the keypath and given predicate as the comparison between elements.
    func sorted(by keyPath: KeyPath<Element, some Comparable>) -> [Element] {
        sorted(by: keyPath, <)
    }
}
