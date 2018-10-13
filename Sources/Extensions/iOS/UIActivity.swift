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
    static func make(
        title: String,
        imageName: String,
        imageBundle: Bundle? = nil,
        canPerform: (([Any]) -> Bool)? = nil,
        handler: @escaping () -> Void) -> UIActivity
    {
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
    
    override var activityTitle : String? {
        return title
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return canPerform?(activityItems as [Any]) ?? true
    }
    
    override var activityViewController : UIViewController? {
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
