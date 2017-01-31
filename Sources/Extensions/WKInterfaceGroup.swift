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
    
    func setBackgroundAnimation(imageName: String, totalImages: Int, percent: Double, duration: Double = 1.0) {
        let imageCount = Int(Double(totalImages) * percent)
        
        guard imageCount > 0 else { return setBackgroundImageNamed(imageName + "0") }
        
        setBackgroundImageNamed(imageName)
        startAnimatingWithImages(
            in: NSMakeRange(0, imageCount),
            duration: duration,
            repeatCount: 1)
    }
    
}
