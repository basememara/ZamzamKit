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

    /// Causes the view to resign the first responder status.
    @objc func endEditing() {
        view.endEditing(true)
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
    func present(
        alert title: String,
        message: String? = nil,
        buttonText: String = .localized(.ok),
        additionalActions: [UIAlertAction]? = nil,
        preferredStyle: UIAlertController.Style = .alert,
        includeCancelAction: Bool = false,
        cancelText: String = .localized(.cancel),
        cancelHandler: (() -> Void)? = nil,
        configure: ((UIAlertController) -> Void)? = nil,
        handler: (() -> Void)? = nil)
    {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
    
        if includeCancelAction {
            alertController.addAction(
                UIAlertAction(title: cancelText, style: .cancel) { _ in cancelHandler?() }
            )
        }
        
        if let additionalActions = additionalActions {
            additionalActions.forEach { item in
                alertController.addAction(item)
            }
        }
        
        alertController.addAction(UIAlertAction(title: buttonText) { handler?() })
    
        // Handle any last configurations before presenting alert
        configure?(alertController)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /**
     Open Safari view controller overlay.

     - parameter url: URL to display in the browser.
     - parameter modalPresentationStyle: The presentation style of the model view controller.
     */
    func present(
        safari url: String,
        modalPresentationStyle: UIModalPresentationStyle = .overFullScreen,
        barTintColor: UIColor? = nil,
        preferredControlTintColor: UIColor? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil)
    {
        present(
            SFSafariViewController(url: URL(string: url)!).with {
                $0.delegate = self as? SFSafariViewControllerDelegate
                $0.modalPresentationStyle = modalPresentationStyle
                $0.preferredBarTintColor ?= barTintColor
                $0.preferredControlTintColor ?= preferredControlTintColor
            },
            animated: animated,
            completion: completion
        )
    }
    
    /**
     Presents an activity view controller modally that you can use to offer various services from your application.

     - parameter activityItems: The array of data objects on which to perform the activity. The type of objects in the array is variable and dependent on the data your application manages.
     - parameter sourceView: The view containing the anchor rectangle for the popover for supporting iPad device.
     - parameter applicationActivities: An array of UIActivity objects representing the custom services that your application supports.
     */
    func present(activities: [Any], popoverFrom sourceView: UIView, applicationActivities: [UIActivity]? = nil) {
        let activity = UIActivityViewController(activityItems: activities, applicationActivities: applicationActivities)
        
        if let popover = activity.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .any
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
        
        if let popover = activity.popoverPresentationController {
            popover.barButtonItem  = barButtonItem
            popover.permittedArrowDirections = .any
        }

        present(activity, animated: true, completion: nil)
    }
    
    /// Presents a alert controller modally.
    ///
    /// - Parameters:
    ///   - alertControllerToPresent: The view controller to display over the current view controller’s content.
    ///   - sourceView: The view containing the anchor rectangle for the popover.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - completion: The block to execute after the presentation finishes.
    func present(_ alertControllerToPresent: UIAlertController, popoverFrom sourceView: UIView, animated: Bool = true, completion: (() -> Void)? = nil) {
        if let popover = alertControllerToPresent.popoverPresentationController {
            popover.sourceView  = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .any
        }
        
        present(alertControllerToPresent, animated: animated, completion: completion)
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

