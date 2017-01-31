//
//  UIColor.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/20/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension UIColor {

    /**
    An additional convenience initializer function that allows to init a UIColor object using a hex color value.

    - param: RGB UInt color hex value (f.e.: 0x990000 for a hex color code like #990000)
    - param: Alpha Double Optional value that sets the alpha range 0=invisible / 1=totally visible.

    */
    convenience init(hex: UInt32, alpha: Double = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    /**
     An additional convenience initializer function that allows to init a UIColor object using integers.

     - parameter rgb: A tuple of integers representing the RGB colors.
     - parameter alpha: Alpha Double Optional value that sets the alpha range 0=invisible / 1=totally visible.
     
     */
    convenience init(rgb: (Int, Int, Int), alpha: Double = 1.0) {
        self.init(
            red: CGFloat(rgb.0) / 255.0,
            green: CGFloat(rgb.1) / 255.0,
            blue: CGFloat(rgb.2) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    /**
     An additional convenience initializer function that allows to init a UIColor object using a RGB string.

     - parameter rgb: A string of integers representing the RGB colors.
     - parameter alpha: Alpha Double Optional value that sets the alpha range 0=invisible / 1=totally visible.
     
     */
    convenience init(rgb: String?, alpha: Double = 1.0) {
        // Validate correct number of colors supplied
        guard let rgbSplit = rgb?.characters
            .split(separator: ",")
            .map(String.init)
            .flatMap({ Int($0.trimmingCharacters(in: .whitespacesAndNewlines)) }),
                rgbSplit.count == 3
                    else {
                        // Return black color if failed
                        self.init(white: 0, alpha: CGFloat(alpha))
                        return
                    }
        
        self.init(rgb: (rgbSplit[0], rgbSplit[1], rgbSplit[2]), alpha: alpha)
    }
    
    /**
     Returns the inverse color
     */
    var inverseColor: UIColor {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: 1.0 - r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
        }
        
        return self
    }
    
}
