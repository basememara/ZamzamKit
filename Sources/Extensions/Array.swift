//
//  Array.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/16/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Array {
    
    /// Element at the given index if it exists.
	///
	/// - Parameter index: index of element.
	/// - Returns: optional element (if exists).
    func get(_ index: Int) -> Element? {
		guard startIndex..<endIndex ~= index else { return nil }
		return self[index]
    }
    
    /**
     Remove array items in a thread-safe manner.

     - parameter handler: Handler with array item that was popped.
     */
    mutating func removeEach(handler: @escaping (Element) -> Void) {
        enumerated().reversed().forEach { handler(remove(at: $0.offset)) }
    }
}

public extension Array {
    
    /// Get a random element from the collection
    func random() -> Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
    
    /// Return array in shuffled order.
    func shuffled() -> Array {
        // http://stackoverflow.com/questions/37843647/shuffle-array-swift-3
        guard count > 1 else { return self }
        
        var elements = self
        
        for i in elements.indices.dropLast() {
            let diff = elements.distance(from: i, to: elements.endIndex)
            let j = elements.index(i, offsetBy: numericCast(arc4random_uniform(numericCast(diff))))
            elements.swapAt(i, j)
        }
        
        return elements
    }
}

// MARK: - Equatables
public extension Array where Element: Equatable {
	
    /// Array with all duplicates removed from it.
    var distinct: [Element] {
        // https://github.com/SwifterSwift/SwifterSwift
        return reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }

    /// Remove all duplicates from array.
    mutating func removeDuplicates() {
        self = reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }

    /// Removes and the specified element.
    ///
    /// - Parameter element: An element to search for in the collection.
    mutating func remove(of element: Element) {
        guard let index = index(of: element) else { return }
        remove(at: index)
    }
}


public extension ArraySlice {
    
    /// Returns the array of the slice
    var array: Array<Element> {
        return Array(self)
    }
    
    /// Element at the given index if it exists.
	///
	/// - Parameter index: index of element.
	/// - Returns: optional element (if exists).
    func get(_ index: Int) -> Element? {
		guard startIndex..<endIndex ~= index else { return nil }
		return self[index]
    }
}
