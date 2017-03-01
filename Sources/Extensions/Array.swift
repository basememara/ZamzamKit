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
    mutating func removeEach(_ handler: @escaping (Element) -> Void) -> Void {
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
    /// https://github.com/SwifterSwift/SwifterSwift
	public var withoutDuplicates: [Element] {
		// Thanks to https://github.com/sairamkotha for improving the preperty
		return reduce([]) { ($0 as [Element]).contains($1) ? $0 : $0 + [$1] }
	}
	
	/// Remove all duplicates from array.
	public mutating func removeDuplicates() {
		// Thanks to https://github.com/sairamkotha for improving the method
		self = reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
	}
	
}
