//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-01.
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
    @available(*, deprecated, message: "Use atomic instead.")
    mutating func removeEach(handler: @escaping (Element) -> Void) {
        enumerated().reversed().forEach { handler(remove(at: $0.offset)) }
    }
}

public extension Array where Element: Equatable {

    /// Remove all duplicates from array.
    ///
    ///     var array = [1, 3, 3, 5, 7, 9]
    ///     array.removeDuplicates()
    ///     array // [1, 3, 5, 7, 9]
    @available(*, deprecated, message: "Avoid mutable objects. Use distinct instead.")
    mutating func removeDuplicates() {
        self = distinct
    }
}


public extension Collection where Iterator.Element == (String, Any) {
    
    /// Converts collection of objects to JSON string
    @available(*, deprecated, message: "Use codable instead.")
    var jsonString: String? {
        guard JSONSerialization.isValidJSONObject(self),
            let stringData = try? JSONSerialization.data(withJSONObject: self, options: []) else {
                return nil
        }
        
        return String(data: stringData, encoding: .utf8)
    }
}
