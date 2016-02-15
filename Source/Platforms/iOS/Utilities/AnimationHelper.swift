//
//  AnimationHelper.swift
//  Pods
//
//  Created by Basem Emara on 1/20/16.
//
//

import Foundation
import ZamzamKit

public extension AnimationHelper {
    
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