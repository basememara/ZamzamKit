//
//  Equatable.swift
//  ZamzamCore
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

public extension CaseIterable where Self: Equatable {
    /// Returns the first index where the specified case appears in the enum.
    ///
    ///     enum Direction: CaseIterable {
    ///         case north
    ///         case east
    ///         case south
    ///         case west
    ///     }
    ///
    ///     Direction.north.index() // 0
    ///     Direction.east.index() // 1
    ///     Direction.south.index() // 2
    ///     Direction.west.index() // 3
    ///
    func index() -> Self.AllCases.Index? {
        Self.allCases.firstIndex(of: self)
    }
}
