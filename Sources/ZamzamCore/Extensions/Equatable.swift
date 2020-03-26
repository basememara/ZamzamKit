//
//  Equatable.swift
//  ZamzamCore
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

public extension Equatable {

    /// Determines if the value is contained within the sequence of values.
    ///
    ///     "b".within(["a", "b", "c"]) // true
    ///
    ///     let status: OrderStatus = .cancelled
    ///     status.within([.requested, .accepted, .inProgress]) // false
    ///
    /// - Parameter values: Array of values to check.
    /// - Returns: Returns true if the values equals to one of the values in the array.
    func within<T> (_ values: T) -> Bool
        where T: Sequence, T.Iterator.Element == Self {
            values.contains(self)
    }
}
