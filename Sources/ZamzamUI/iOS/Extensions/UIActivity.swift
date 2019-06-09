//
//  UIActivity.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/21/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

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
        imageName: String,
        imageBundle: Bundle? = nil,
        canPerform: (([Any]) -> Bool)? = nil,
        handler: @escaping () -> Void
    ) -> UIActivity {
        return CustomActivity(
            title: title,
            imageName: imageName,
            imageBundle: imageBundle,
            handler: handler
        )
    }
}

private class CustomActivity: UIActivity {
    let title: String
    let imageName: String
    let imageBundle: Bundle?
    let canPerform: (([Any]) -> Bool)?
    let handler: () -> Void

    init(title: String, imageName: String, imageBundle: Bundle? = nil, canPerform: (([Any]) -> Bool)? = nil, handler: @escaping () -> Void) {
        self.title = title
        self.imageName = imageName
        self.imageBundle = imageBundle
        self.canPerform = canPerform
        self.handler = handler
    }
    
    override var activityTitle: String? {
        return title
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return canPerform?(activityItems as [Any]) ?? true
    }
    
    override var activityViewController: UIViewController? {
        return nil
    }
    
    override func perform() {
        handler()
        activityDidFinish(true)
    }
    
    override var activityImage: UIImage? {
        return UIImage(named: imageName, inBundle: imageBundle)
    }
}
