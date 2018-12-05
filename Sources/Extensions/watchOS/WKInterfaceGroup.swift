//
//  WKInterfaceGroup.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import WatchKit

public extension WKInterfaceGroup {
    
    /// Animates the specified images with the given duration and repeat information in the background image.
    ///
    /// - Parameters:
    ///   - imageName: The root name of the image that will be used to generate an array of `UIImage` objects to use for an animation.
    ///   - totalImages: Total images to generate the list of images used for animation.
    ///   - percent: The percentage of the image to generate.
    ///   - duration: The duration of the animation.
    func setBackgroundAnimation(imageName: String, totalImages: Int, percent: Double, duration: Double = 1.0) {
        let imageCount = Int(Double(totalImages) * percent)
        
        guard imageCount > 0 else {
            return setBackgroundImageNamed(imageName + "0")
        }
        
        setBackgroundImageNamed(imageName)
        
        startAnimatingWithImages(
            in: NSMakeRange(0, imageCount),
            duration: duration,
            repeatCount: 1
        )
    }
    
}
