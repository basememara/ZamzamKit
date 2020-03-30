//
//  Array.swift
//  ZamzamCore
//
//  Created by Basem Emara on 3/16/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

public extension Array {
    
    /// Inserts a new element into the collection at the beginning position.
    ///
    ///        [2, 3, 4, 5].prepend(1) -> [1, 2, 3, 4, 5]
    ///        ["e", "l", "l", "o"].prepend("h") -> ["h", "e", "l", "l", "o"]
    ///
    /// - Parameter newElement: The new element to insert into the collection.
    mutating func prepend(_ newElement: Element) {
        // https://github.com/SwifterSwift/SwifterSwift
        insert(newElement, at: 0)
    }
}

public extension Array where Element: Equatable {
	
    /// Array with all duplicates removed from it.
    ///
    ///     [1, 3, 3, 5, 7, 9].distinct // [1, 3, 5, 7, 9]
    var distinct: [Element] {
        // https://github.com/SwifterSwift/SwifterSwift
        reduce(into: [Element]()) {
            guard !$0.contains($1) else { return }
            $0.append($1)
        }
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
    var array: [Element] { Array(self) }
}

public extension Zip2Sequence {
    
    /// Returns the array of the zipped sequence
    var array: [(Sequence1.Element, Sequence2.Element)] { Array(self) }
}
