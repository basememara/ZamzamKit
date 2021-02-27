//
//  UIImageView.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import Foundation.NSBundle
import Foundation.NSDate
import UIKit.UIImage
import UIKit.UIImageView

public extension UIImageView {

    /// Returns an image view initialized with the specified image.
    ///
    /// - Parameters:
    ///   - named: The name of the image.
    ///   - bundle: The bundle containing the image file or asset catalog. Specify nil to search the app's main bundle.
    convenience init(imageNamed name: String, inBundle bundle: Bundle? = nil) {
        self.init(image: UIImage(named: name, inBundle: bundle))
    }
}

public extension UIImageView {

    /// Starts animating the sequential images in the receiver.
    ///
    /// - Parameters:
    ///   - imageName: The root name of the image that will be used to generate an array of `UIImage` objects to use for an animation.
    ///   - totalImages: Total images to generate the list of images used for animation.
    ///   - percent: The percentage of the image to generate.
    ///   - duration: The duration of the animation.
    func startAnimating(
        forImageNamed imageName: String,
        beginningSuffixNumber: Int = 0,
        totalImages: Int,
        percent: Double,
        duration: TimeInterval = 1.0
    ) {
        let imageCount = Int(Double(totalImages) * percent)

        guard imageCount > 0 else {
            image = UIImage(named: imageName + "\(beginningSuffixNumber)")
            return
        }

        let imagesList = (beginningSuffixNumber...imageCount).compactMap {
            UIImage(named: "\(imageName)\($0)")
        }

        image = imagesList.last
        animationImages = imagesList
        animationDuration = duration
        animationRepeatCount = 1
        startAnimating()
    }
}
#endif
