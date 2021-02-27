//
//  NilOrEmptyAssignment.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-03-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

infix operator ??+: NilCoalescingPrecedence

public extension Optional where Wrapped == String {
    /// Assign value if not nil or empty, otherwise use default value.
    ///
    ///     var test: String
    ///     var value: String?
    ///
    ///     test = value ??+ "Abc"
    ///     // test == "Abc"
    ///
    ///     value = ""
    ///     test = value ??+ "Lmn"
    ///     // test == "Abc"
    ///
    ///     value = "Xyz"
    ///     test = value ??+ "Rst"
    ///     // test == "Xyz"
    static func ??+ (left: Wrapped?, right: Wrapped) -> Wrapped {
        // https://janthielemann.de/random-stuff/providing-default-values-optional-string-empty-optional-string-swift-3-1/
        guard let left = left, !left.isEmpty else { return right }
        return left
    }

    /// Assign value if not nil or empty, otherwise use default value.
    ///
    ///     var test: String
    ///     var value: String?
    ///
    ///     test = value ??+ "Abc"
    ///     // test == "Abc"
    ///
    ///     value = ""
    ///     test = value ??+ "Lmn"
    ///     // test == "Abc"
    ///
    ///     let value2: String? = "Xyz"
    ///     let test2 = value2 ??+ nil
    ///     // test2 == "Xyz"
    static func ??+ (left: Wrapped?, right: Wrapped?) -> Wrapped? {
        guard let left = left, !left.isEmpty else { return right }
        return left
    }
}
