//
//  UIViewControllerExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit
import SafariServices

public extension UIViewController {
    
    /**
     Display an alert action in a convenient way.

     - parameter message:           Body of the alert.
     - parameter title:             Title of the alert.
     - parameter buttonTitle:       Text for the button.
     - parameter additionalActions: Array of alert actions.
     - parameter handler:           Call back handler when main action tapped.
     */
    public func alert(title: String,
        message: String? = nil,
        buttonTitle: String = "OK",
        additionalActions: [UIAlertAction]? = nil,
        preferredStyle: UIAlertControllerStyle = .Alert,
        includeCancelAction: Bool = false,
        handler: (() -> Void)? = nil) {
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: preferredStyle
            )
        
            if includeCancelAction {
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            }
            
            if let additionalActions = additionalActions {
                additionalActions.forEach { item in
                    alertController.addAction(item)
                }
            }
            
            alertController.addAction(UIAlertAction(title: buttonTitle) { handler?() })
            
            presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     Open Safari view controller overlay.

     - parameter url: URL to display in the browser.
     - parameter modalPresentationStyle: The presentation style of the model view controller.
     */
    @available(iOSApplicationExtension 9.0, *)
    public func presentSafariController(url: String, modalPresentationStyle: UIModalPresentationStyle = .OverFullScreen) {
        let safariController = SFSafariViewController(URL: NSURL(string: url)!)
        safariController.modalPresentationStyle = .OverFullScreen
        
        safariController.delegate = self as? SFSafariViewControllerDelegate
        
        presentViewController(safariController, animated: true, completion: nil)
    }
    
    /**
     Adds status bar background with color instead of being transparent.

     - parameter backgroundColor: Background color of status bar.
     */
    public func addStatusBar(backgroundColor: UIColor) -> UIView {
        let statusBar = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 20))
        statusBar.backgroundColor = backgroundColor
        self.view.addSubview(statusBar)
        
        return statusBar
    }
    
    /**
     Adds status bar background with light or dark mode.

     - parameter darkMode: Light or dark mode color of status bar.
     */
    public func addStatusBar(darkMode darkMode: Bool) -> UIView {
        return addStatusBar(darkMode
            ? UIColor(white: 0, alpha: 0.8)
            : UIColor(rgb: (239, 239, 244), alpha: 0.8))
    }
    
    /**
     Presents an activity view controller modally that you can use to offer various services from your application.

     - parameter activityItems: The array of data objects on which to perform the activity. The type of objects in the array is variable and dependent on the data your application manages.
     - parameter sourceView: The view containing the anchor rectangle for the popover for supporting iPad device.
     - parameter applicationActivities: An array of UIActivity objects representing the custom services that your application supports.
     */
    public func presentActivityViewController(activityItems: [AnyObject],
        sourceView: UIView, applicationActivities: [UIActivity]? = nil) {
            let activity = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            
            if let popOver = activity.popoverPresentationController {
                popOver.sourceView  = sourceView
                popOver.sourceRect = sourceView.bounds
                popOver.permittedArrowDirections = .Any
            }

            presentViewController(activity, animated: true, completion: nil)
    }
    
    /**
     Presents an activity view controller modally that you can use to offer various services from your application.

     - parameter activityItems: The array of data objects on which to perform the activity. The type of objects in the array is variable and dependent on the data your application manages.
     - parameter barButtonItem: The bar button item containing the anchor rectangle for the popover for supporting iPad device.
     - parameter applicationActivities: An array of UIActivity objects representing the custom services that your application supports.
     */
    public func presentActivityViewController(activityItems: [AnyObject],
        barButtonItem: UIBarButtonItem, applicationActivities: [UIActivity]? = nil) {
            let activity = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            
            if let popOver = activity.popoverPresentationController {
                popOver.barButtonItem  = barButtonItem
                popOver.permittedArrowDirections = .Any
            }

            presentViewController(activity, animated: true, completion: nil)
    }

}