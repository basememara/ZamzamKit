//
//  BinaryFloatingPoint.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/14/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

public extension BinaryFloatingPoint {

    /// Returns this value rounded to an integral value.
    ///
    /// - Parameter places: The number of decimal places to round to.
    /// - Returns: The rounded value.
    func rounded(toPlaces places: Int) -> Self {
        // https://codereview.stackexchange.com/questions/142748/swift-floatingpoint-rounded-to-places
        guard places >= 0 else { return self }
        let divisor = Self((0..<places).reduce(1.0) { (result, _) in result * 10.0 })
        return (self * divisor).rounded() / divisor
    }
}
