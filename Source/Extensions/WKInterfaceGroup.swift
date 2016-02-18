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
    
    public func setBackgroundAnimation(imageName: String, totalImages: Int, percent: Double, duration: Double = 1.0) {
        let imageCount = Int(Double(totalImages) * percent)
        
        if imageCount > 0 {
            self.setBackgroundImageNamed(imageName)
            self.startAnimatingWithImagesInRange(
                NSMakeRange(0, imageCount),
                duration: duration,
                repeatCount: 1)
        } else {
            self.setBackgroundImageNamed(imageName + "0")
        }
    }
    
}