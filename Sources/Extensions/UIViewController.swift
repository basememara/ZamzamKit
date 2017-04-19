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
	
	/// Check if ViewController is onscreen and not hidden.
	var isVisible: Bool {
		// http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
		return isViewLoaded && view.window != nil
	}
}

public extension UIViewController {

    /**
     Adds status bar background with color instead of being transparent.

     - parameter backgroundColor: Background color of status bar.
     */
    func addStatusBar(background color: UIColor) -> UIView {
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        statusBar.backgroundColor = color
        self.view.addSubview(statusBar)
        
        return statusBar
    }
    
    /**
     Adds status bar background with light or dark mode.

     - parameter darkMode: Light or dark mode color of status bar.
     */
    func addStatusBar(darkMode: Bool) -> UIView {
        return addStatusBar(background: darkMode
            ? UIColor(white: 0, alpha: 0.8)
            : UIColor(rgb: (239, 239, 244), alpha: 0.8))
    }
}

// MARK: - Presenters
public extension UIViewController {
    
    /**
     Display an alert action in a convenient way.

     - parameter message:           Body of the alert.
     - parameter title:             Title of the alert.
     - parameter buttonTitle:       Text for the button.
     - parameter additionalActions: Array of alert actions.
     - parameter handler:           Call back handler when main action tapped.
     */
    func present(alert title: String,
        message: String? = nil,
        buttonText: String = "OK",
        additionalActions: [UIAlertAction]? = nil,
        preferredStyle: UIAlertControllerStyle = .alert,
        includeCancelAction: Bool = false,
        handler: (() -> Void)? = nil) {
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: preferredStyle
            )
        
            if includeCancelAction {
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            }
            
            if let additionalActions = additionalActions {
                additionalActions.forEach { item in
                    alertController.addAction(item)
                }
            }
            
            alertController.addAction(UIAlertAction(title: buttonText) { handler?() })
            
            present(alertController, animated: true, completion: nil)
    }
    
    /**
     Open Safari view controller overlay.

     - parameter url: URL to display in the browser.
     - parameter modalPresentationStyle: The presentation style of the model view controller.
     */
    func present(safari url: String, modalPresentationStyle: UIModalPresentationStyle = .overFullScreen) {
        let safariController = SFSafariViewController(url: URL(string: url)!)
        safariController.modalPresentationStyle = .overFullScreen
        
        safariController.delegate = self as? SFSafariViewControllerDelegate
        
        present(safariController, animated: true, completion: nil)
    }
    
    /**
     Presents an activity view controller modally that you can use to offer various services from your application.

     - parameter activityItems: The array of data objects on which to perform the activity. The type of objects in the array is variable and dependent on the data your application manages.
     - parameter sourceView: The view containing the anchor rectangle for the popover for supporting iPad device.
     - parameter applicationActivities: An array of UIActivity objects representing the custom services that your application supports.
     */
    func present(activities: [Any], sourceView: UIView, applicationActivities: [UIActivity]? = nil) {
        let activity = UIActivityViewController(activityItems: activities, applicationActivities: applicationActivities)
        
        if let popOver = activity.popoverPresentationController {
            popOver.sourceView = sourceView
            popOver.sourceRect = sourceView.bounds
            popOver.permittedArrowDirections = .any
        }

        present(activity, animated: true, completion: nil)
    }
    
    /**
     Presents an activity view controller modally that you can use to offer various services from your application.

     - parameter activityItems: The array of data objects on which to perform the activity. The type of objects in the array is variable and dependent on the data your application manages.
     - parameter barButtonItem: The bar button item containing the anchor rectangle for the popover for supporting iPad device.
     - parameter applicationActivities: An array of UIActivity objects representing the custom services that your application supports.
     */
    func present(activities: [Any], barButtonItem: UIBarButtonItem, applicationActivities: [UIActivity]? = nil) {
        let activity = UIActivityViewController(activityItems: activities, applicationActivities: applicationActivities)
        
        if let popOver = activity.popoverPresentationController {
            popOver.barButtonItem  = barButtonItem
            popOver.permittedArrowDirections = .any
        }

        present(activity, animated: true, completion: nil)
    }

}

public extension UIViewController {
    
    /**
     Calculate points from a percentage of the width of the view.
     
     - parameter value: Percentage of the width.
     
     - returns: Points calculated from percentage of width.
     */
    func percentX(_ value: CGFloat) -> CGFloat {
        return view.frame.width  * value
    }
    
    /**
     Calculate points from a percentage of the height of the view.
     
     - parameter value: Percentage of the height.
     
     - returns: Points calculated from percentage of height.
     */
    func percentY(_ value: CGFloat) -> CGFloat {
        return view.frame.height * value
    }
}

