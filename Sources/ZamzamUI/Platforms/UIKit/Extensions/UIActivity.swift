//
//  UIActivity.swift
//  ZamzamUI
//
//  Created by Basem Emara on 5/21/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIActivity {

    /// Creates an instance of an activity.
    ///
    /// - Parameters:
    ///   - title: Title to display for the activity.
    ///   - imageName: Name of the image.
    ///   - imageBundle: Bundle of the image.
    ///   - canPerform: Function to determine if the activity can be shown. Default is true.
    ///   - handler: Function to perform activity when selected by the user.
    /// - Returns: The custom activity.
    static func make(
        title: String,
        image: UIImage?,
        canPerform: (([Any]) -> Bool)? = nil,
        handler: @escaping () -> Void
    ) -> UIActivity {
        CustomActivity(
            title: title,
            image: image,
            handler: handler
        )
    }
}

@available(iOS 13, *)
public extension UIActivity {
    
    /// Creates an instance of an activity.
    ///
    /// - Parameters:
    ///   - title: Title to display for the activity.
    ///   - imageSystemName: System icon name for the image.
    ///   - canPerform: Function to determine if the activity can be shown. Default is true.
    ///   - handler: Function to perform activity when selected by the user.
    /// - Returns: The custom activity.
    static func make(
        title: String,
        imageSystemName name: String,
        canPerform: (([Any]) -> Bool)? = nil,
        handler: @escaping () -> Void
    ) -> UIActivity {
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: name, withConfiguration: config)
        return make(title: title, image: image, canPerform: canPerform, handler: handler)
    }
}

private extension UIActivity {
    
    class CustomActivity: UIActivity {
        let title: String
        let image: UIImage?
        let canPerform: (([Any]) -> Bool)?
        let handler: () -> Void

        init(title: String, image: UIImage?, canPerform: (([Any]) -> Bool)? = nil, handler: @escaping () -> Void) {
            self.title = title
            self.image = image
            self.canPerform = canPerform
            self.handler = handler
        }
        
        override var activityTitle: String? { title }
        override var activityImage: UIImage? { image }
        override var activityViewController: UIViewController? { nil }
        
        override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
            return canPerform?(activityItems as [Any]) ?? true
        }
        
        override func perform() {
            handler()
            activityDidFinish(true)
        }
    }
}
#endif
