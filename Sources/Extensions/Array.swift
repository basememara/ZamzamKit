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

    /// Finds the closest element that matches the criteria forwards or backwards.
    ///
    /// - parameter index:     Index to start from.
    /// - parameter predicate: Criteria to match.
    ///
    /// - returns: Closest element that matches the criteria.
    func closestMatch(from index: Int, where predicate: (Element) -> Bool) -> (Int, Element)? {
        if predicate(self[index]) {
            return (index, self[index])
        }
        
        var delta = 1
        
        while(true) {
            guard index + delta < count || index - delta >= 0 else {
                return nil
            }
            
            if index + delta < count && predicate(self[index + delta]) {
                return (index + delta, self[index + delta])
            }
            
            if index - delta >= 0 && predicate(self[index - delta]) {
                return (index - delta, self[index - delta])
            }
            
            delta = delta + 1
        }
    }
}

// MARK: - Equatables
public extension Array where Element: Equatable {
	
	/// Array with all duplicates removed from it.
	var withoutDuplicates: [Element] {
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
