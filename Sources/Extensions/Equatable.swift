//
//  Equatable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Equatable {

    /// Determines if the value is contained within the array of values.
    ///
    ///     "b".within(["a", "b", "c"]) -> true
    ///
    ///     let status: OrderStatus = .cancelled
    ///     status.within([.requeseted, .accepted, .inProgress]) -> false
    ///
    /// - Parameter values: Array of values to check.
    /// - Returns: Returns true if the values equals to one of the values in the array.
    func within<Seq: Sequence> (_ values: Seq) -> Bool where Seq.Iterator.Element == Self {
        return values.contains(self)
    }
}
