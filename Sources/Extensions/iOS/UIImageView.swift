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
        
        if imageCount > 0 {
            var imagesList: [UIImage] = []
            for index in 0...imageCount {
                imagesList.append(UIImage(named: "\(imageName)\(index)")!)
            }
            
            self.image = imagesList.last
            self.animationImages = imagesList
            self.animationDuration = 1.0
            self.animationRepeatCount = 1
            self.startAnimating()
        } else {
            self.image = UIImage(named: imageName + "0")
        }
    }
    
}
