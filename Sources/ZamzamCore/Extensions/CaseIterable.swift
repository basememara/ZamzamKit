//
//  CaseIterable.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-03-26.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

public extension CaseIterable where Self: Equatable, AllCases: BidirectionalCollection {
    /// Returns the case before this one, or `nil` for the first case.
    func previous() -> Self? {
        // https://newbedev.com/how-to-get-next-case-of-enum-i-e-write-a-circulating-method-in-swift-4-2
        let array = Self.allCases
        guard let currentIndex = array.firstIndex(of: self), currentIndex != array.startIndex else { return nil }
        return array[safe: array.index(before: currentIndex)]
    }

    /// Returns the case after this one, or `nil` for the last case.
    func next() -> Self? {
        let array = Self.allCases
        guard let currentIndex = array.firstIndex(of: self) else { return nil }
        return array[safe: array.index(after: currentIndex)]
    }
}
