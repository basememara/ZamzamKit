//
//  UIImageView.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
    
    /// Starts animating the sequential images in the receiver.
    ///
    /// - Parameters:
    ///   - imageName: The root name of the image that will be used to generate an array of `UIImage` objects to use for an animation.
    ///   - totalImages: Total images to generate the list of images used for animation.
    ///   - percent: The percentage of the image to generate.
    ///   - duration: The duration of the animation.
    func setProgressAnimation(_ imageName: String, totalImages: Int, percent: Double, duration: TimeInterval = 1.0) {
        let imageCount = Int(Double(totalImages) * percent)
        
        guard imageCount > 0 else {
            image = UIImage(named: imageName + "0")
            return
        }
        
        var imagesList: [UIImage] = []
        for index in 0...imageCount {
            imagesList.append(UIImage(named: "\(imageName)\(index)")!)
        }
        
        image = imagesList.last
        animationImages = imagesList
        animationDuration = duration
        animationRepeatCount = 1
        startAnimating()
    }
}
