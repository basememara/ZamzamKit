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
    
    func setProgressAnimation(_ imageName: String, totalImages: Int, percent: Double, duration: Double = 1.0) {
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
        animationDuration = 1.0
        animationRepeatCount = 1
        startAnimating()
    }
}
