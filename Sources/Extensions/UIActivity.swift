//
//  UIActivity.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/21/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

public extension UIActivity {

    /**
     Creates an instance of an activity.

     - parameter title: Title to display for the activity
     - parameter imageName: Name of the image
     - parameter imageBundle: Bundle of the image
     - parameter canPerform: Function to determine if the activity can be shown. Default is true.
     - parameter handler: Function to perform activity when selected by the user.

     - returns: The custom activity
     */
    public static func create(title: String, imageName: String, imageBundle: NSBundle? = nil,
        canPerform: (([AnyObject]) -> Bool)? = nil,
        handler: () -> Void) -> UIActivity {
            return CustomActivity(
                title: title,
                imageName: imageName,
                imageBundle: imageBundle,
                handler: handler)
    }
}

private class CustomActivity: UIActivity {
    let title: String
    let imageName: String
    let imageBundle: NSBundle?
    let canPerform: (([AnyObject]) -> Bool)?
    let handler: () -> Void

    init(title: String, imageName: String, imageBundle: NSBundle? = nil, canPerform: (([AnyObject]) -> Bool)? = nil, handler: () -> Void) {
        self.title = title
        self.imageName = imageName
        self.imageBundle = imageBundle
        self.canPerform = canPerform
        self.handler = handler
    }
    
    override func activityTitle() -> String? {
        return title
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return canPerform?(activityItems) ?? true
    }
    
    override func activityViewController() -> UIViewController? {
        return nil
    }
    
    override func performActivity() {
        handler()
        activityDidFinish(true)
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: imageName, inBundle: imageBundle)
    }
}