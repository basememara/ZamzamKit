//
//  Array.swift
//  ZamzamCore
//
//  Created by Basem Emara on 3/16/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

public extension Array {
    /// Splits the array into consecutive groups of `size` elements. The last group holds what remains.
    ///
    ///     [1, 2, 3, 4, 5].chunked(into: 2) // [[1, 2], [3, 4], [5]]
    ///
    /// A size below 1 or above `count` returns the whole array as one group. An empty array returns `[[]]`.
    func chunked(into size: Int) -> [[Element]] {
        guard !isEmpty, 1...count ~= size else { return [self] }

        // https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
        return stride(from: 0, to: count, by: size)
            .map { Array(self[$0..<Swift.min($0 + size, count)]) }
    }
}

public extension Array where Element: Equatable {
    /// Returns the array without its repeated elements, keeping the first of each in its original order.
    ///
    ///     [1, 3, 3, 5, 7, 9].removeDuplicates() // [1, 3, 5, 7, 9]
    ///
    /// - Complexity: O(*n*²), where *n* is the length of the array.
    func removeDuplicates() -> [Element] {
        // https://github.com/SwifterSwift/SwifterSwift
        reduce(into: [Element]()) {
            guard !$0.contains($1) else { return }
            $0.append($1)
        }
    }

    /// Removes the first element equal to `element`, if there is one.
    ///
    ///     var array = ["a", "b", "c", "a"]
    ///     array.remove("a")
    ///     array // ["b", "c", "a"]
    mutating func remove(_ element: Element) {
        guard let index = firstIndex(of: element) else { return }
        remove(at: index)
    }
}

public extension ArraySlice {
    /// Returns the array of the slice
    var array: [Element] { Array(self) }
}
