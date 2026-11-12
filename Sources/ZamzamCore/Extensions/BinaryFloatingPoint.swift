//
//  BinaryFloatingPoint.swift
//  ZamzamCore
//
//  Created by Basem Emara on 5/14/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

public extension BinaryFloatingPoint {
    /// Returns the value rounded to a number of decimal places, with a half rounded away from zero.
    ///
    ///     123.12312421.rounded(toPlaces: 3) // 123.123
    ///     Double.pi.rounded(toPlaces: 2) // 3.14
    ///
    /// A negative number of places returns the value unchanged.
    func rounded(toPlaces places: Int) -> Self {
        // https://codereview.stackexchange.com/questions/142748/swift-floatingpoint-rounded-to-places
        guard places >= 0 else { return self }
        let divisor = Self((0..<places).reduce(1.0) { result, _ in result * 10.0 })
        return (self * divisor).rounded() / divisor
    }
}
