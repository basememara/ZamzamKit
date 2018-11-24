//
//  UIColor.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/20/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension UIColor {

    /// An additional convenience initializer function that allows to init a color object using a hex color value.
    ///
    /// For hex code `#990000`, initialize using `0x990000`.
    ///
    ///     UIColor(hex: 0x990000)
    ///
    /// - Parameters:
    ///   - hex: RGB UInt color hex value.
    ///   - alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    convenience init(hex: UInt32, alpha: Double = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    /// An additional convenience initializer function that allows to init a color object using integers.
    ///
    ///     UIColor(rgb: (66, 134, 244))
    ///
    /// - Parameters:
    ///   - rgb: A tuple of integers representing the RGB colors.
    ///   - alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    convenience init(rgb: (Int, Int, Int), alpha: Double = 1.0) {
        self.init(
            red: CGFloat(rgb.0) / 255.0,
            green: CGFloat(rgb.1) / 255.0,
            blue: CGFloat(rgb.2) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
