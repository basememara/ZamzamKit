//
//  AnimationHelper.swift
//  Pods
//
//  Created by Basem Emara on 1/20/16.
//
//

import Foundation
import WatchKit

public extension AnimationHelper {
    
    public func setBackgroundAnimation(control: WKInterfaceGroup, imageName: String, totalImages: Int, percent: Double, duration: Double = 1.0) {
        let imageCount = Int(Double(totalImages) * percent)
        if imageCount > 0 {
            control.setBackgroundImageNamed(imageName)
            control.startAnimatingWithImagesInRange(
                NSMakeRange(0, imageCount),
                duration: duration,
                repeatCount: 1)
        } else {
            control.setBackgroundImageNamed(imageName + "0")
        }
    }
}