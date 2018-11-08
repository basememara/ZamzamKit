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

// MARK: - Alerts

public extension UIViewController {
    
    /// Display an alert message to the user.
    ///
    /// - Parameters:
    ///   - title: Title of the alert.
    ///   - message: Body of the alert.
    ///   - buttonText: Text for the primary button.
    ///   - additionalActions: Array of alert actions.
    ///   - includeCancelAction: Include a cancel action within the alert.
    ///   - cancelText: Text for the cancel button.
    ///   - cancelHandler: Call back handler when cancel action tapped.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - configure: Configure the `UIAlertController` before it is loaded.
    ///   - handler: Call back handler when main action tapped.
    func present(
        alert title: String,
        message: String? = nil,
        buttonText: String = .localized(.ok),
        additionalActions: [UIAlertAction]? = nil,
        includeCancelAction: Bool = false,
        cancelText: String = .localized(.cancel),
        cancelHandler: (() -> Void)? = nil,
        animated: Bool = true,
        configure: ((UIAlertController) -> Void)? = nil,
        handler: (() -> Void)? = nil)
    {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
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
        
        present(alertController, animated: animated, completion: nil)
    }
    
    /// Display an action sheet to the user.
    ///
    /// - Parameters:
    ///   - title: Title of the alert.
    ///   - message: Body of the alert.
    ///   - sourceView: The view containing the anchor rectangle for the popover.
    ///   - additionalActions: Array of alert actions.
    ///   - includeCancelAction: Include a cancel action within the alert.
    ///   - cancelText: Text for the cancel button.
    ///   - cancelHandler: Call back handler when cancel action tapped.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - configure: Configure the `UIAlertController` before it is loaded.
    ///   - completion: The block to execute after the presentation finishes.
    func present(
        actionSheet title: String?,
        message: String? = nil,
        popoverFrom sourceView: UIView,
        additionalActions: [UIAlertAction],
        includeCancelAction: Bool = false,
        cancelText: String = .localized(.cancel),
        cancelHandler: (() -> Void)? = nil,
        animated: Bool = true,
        configure: ((UIAlertController) -> Void)? = nil,
        completion: (() -> Void)? = nil)
    {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )
        
        additionalActions.forEach { item in
            alertController.addAction(item)
        }
        
        if includeCancelAction {
            alertController.addAction(
                UIAlertAction(title: cancelText, style: .cancel) { _ in cancelHandler?() }
            )
        }
        
        // Handle popover for iPad's, etc if available
        if let popover = alertController.popoverPresentationController {
            popover.sourceView  = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .any
        }
        
        // Handle any last configurations before presenting alert
        configure?(alertController)
        
        present(alertController, animated: animated, completion: completion)
    }
}

// MARK: - Safari

public extension UIViewController {
    
    /// Open Safari view controller.
    ///
    /// - Parameters:
    ///   - url: URL to display in the browser.
    ///   - modalPresentationStyle: The presentation style of the model view controller.
    ///   - barTintColor: The color to tint the background of the navigation bar and the toolbar.
    ///   - preferredControlTintColor: The color to tint the control buttons on the navigation bar and the toolbar.
    ///   - animated: Pass true to animate the presentation.
    ///   - completion: The block to execute after the presentation finishes.
    func present(
        safari url: String,
        modalPresentationStyle: UIModalPresentationStyle? = nil,
        barTintColor: UIColor? = nil,
        preferredControlTintColor: UIColor? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil)
    {
        present(
            SFSafariViewController(url: URL(string: url)!).with {
                $0.delegate = self as? SFSafariViewControllerDelegate
                $0.modalPresentationStyle ?= modalPresentationStyle
                $0.preferredBarTintColor ?= barTintColor
                $0.preferredControlTintColor ?= preferredControlTintColor
            },
            animated: animated,
            completion: completion
        )
    }
}

// MARK: - Activities

public extension UIViewController {
    
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
}

// MARK: - Dimensions

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

