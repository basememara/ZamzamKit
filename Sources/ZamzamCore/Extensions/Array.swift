//
//  Array.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/16/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation

// MARK: - Equatables

public extension Array where Element: Equatable {
	
    /// Array with all duplicates removed from it.
    ///
    ///     [1, 3, 3, 5, 7, 9].distinct // [1, 3, 5, 7, 9]
    var distinct: [Element] {
        // https://github.com/SwifterSwift/SwifterSwift
        return reduce(into: [Element]()) {
            guard !$0.contains($1) else { return }
            $0.append($1)
        }
    }

    /// Remove all duplicates from array.
    ///
    ///     var array = [1, 3, 3, 5, 7, 9]
    ///     array.removeDuplicates()
    ///     array // [1, 3, 5, 7, 9]
    mutating func removeDuplicates() {
        self = distinct
    }

    /// Removes the first occurance of the matched element.
    ///
    ///     var array = ["a", "b", "c", "d", "e", "a"]
    ///     array.remove("a")
    ///     array // ["b", "c", "d", "e", "a"]
    ///
    /// - Parameter element: The element to remove from the array.
    mutating func remove(_ element: Element) {
        guard let index = firstIndex(of: element) else { return }
        remove(at: index)
    }
}

public extension ArraySlice {
    
    /// Returns the array of the slice
    var array: [Element] {
        return Array(self)
    }
}

public extension Zip2Sequence {
    
    /// Returns the array of the zipped sequence
    var array: [(Sequence1.Element, Sequence2.Element)] {
        return Array(self)
    }
}
