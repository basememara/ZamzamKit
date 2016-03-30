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

    :param: rgb UInt color hex value (f.e.: 0x990000 for a hex color code like #990000)
    :param: alpha Double Optional value that sets the alpha range 0=invisible / 1=totally visible

    */
    convenience init(rgb: Int, alpha: Double = 1.0) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat( rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    /**
     Returns the inverse color
     */
    public var inverseColor: UIColor {
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