//
//  UIBarButtonItem.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/3/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {

    /// Initializes a UIBarButtonItem with an image more conveniently.
    ///
    /// - Parameters:
    ///   - imageName: Image name.
    ///   - bundle: The bundle containing the image file or asset catalog. Specify nil to search the app's main bundle.
    ///   - target: Target of the context.
    ///   - action: Action to trigger.
    convenience init(imageName: String, inBundle bundle: Bundle? = nil, target: Any?, action: Selector) {
        self.init(
            image: UIImage(
                named: imageName,
                inBundle: bundle
            ),
            style: .plain,
            target: target,
            action: action
        )
    }
}
