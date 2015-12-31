//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation
import WatchKit

public class AnimationService: NSObject {
    
    @available (watchOS 2, *)
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
    
    @available (iOS 8.3, *)
    public func setProgressAnimation(imageView: UIImageView, imageName: String, totalImages: Int, percent: Double, duration: Double = 1.0) {
        let imageCount = Int(Double(totalImages) * percent)
        if imageCount > 0 {
            var imagesList: [UIImage] = []
            for index in 0...imageCount {
                imagesList.append(UIImage(named: "\(imageName)\(index)")!)
            }
            
            imageView.image = imagesList.last
            imageView.animationImages = imagesList
            imageView.animationDuration = 1.0
            imageView.animationRepeatCount = 1
            imageView.startAnimating()
        } else {
            imageView.image = UIImage(named: imageName + "0")
        }
    }
}
