//
//  Array.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/16/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Array {
    
    /// Remove array items in a thread-safe manner and executes
    /// the hander on each item of the array.
    ///
    /// The handler will be executed on each item in reverse order
    /// to ensure items that are appended to the array during this
    /// process does not interfere with the mutation.
    ///
    ///     var array = [1, 3, 5, 7, 9]
    ///     array.removeEach { print($0) }
    ///     // Prints "9" "7" "5" "3" "1"
    ///     array -> []
    ///
    /// - Parameter handler: Handler with array item that was popped.
    mutating func removeEach(handler: @escaping (Element) -> Void) {
        enumerated().reversed().forEach { handler(remove(at: $0.offset)) }
    }
}

// MARK: - Equatables
public extension Array where Element: Equatable {
	
    /// Array with all duplicates removed from it.
    ///
    ///     [1, 3, 3, 5, 7, 9].distinct -> [1, 3, 5, 7, 9]
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
    ///     array -> [1, 3, 5, 7, 9]
    mutating func removeDuplicates() {
        self = distinct
    }

    /// Removes the first occurance of the matched element.
    ///
    ///     var array = ["a", "b", "c", "d", "e", "a"]
    ///     array.remove("a")
    ///     array -> ["b", "c", "d", "e", "a"]
    ///
    /// - Parameter element: The element to remove from the array.
    mutating func remove(_ element: Element) {
        guard let index = index(of: element) else { return }
        remove(at: index)
    }
}


public extension ArraySlice {
    
    /// Returns the array of the slice
    var array: Array<Element> {
        return Array(self)
    }
}
