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
    ///   - buttonStyle: Style to apply to the primary button.
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
        buttonStyle: UIAlertAction.Style = .default,
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
        
        alertController.addAction(
            UIAlertAction(title: buttonText, style: buttonStyle) { _ in handler?() }
        )
    
        // Handle any last configurations before presenting alert
        configure?(alertController)
        
        present(alertController, animated: animated, completion: nil)
    }
    
    /// Display an action sheet to the user.
    ///
    ///     present(
    ///         actionSheet: "Test Action Sheet",
    ///         message: "Choose your action",
    ///         popoverFrom: sender,
    ///         additionalActions: [
    ///             UIAlertAction(title: "Action 1") { },
    ///             UIAlertAction(title: "Action 2") { },
    ///             UIAlertAction(title: "Action 3") { }
    ///         ],
    ///         includeCancelAction: true
    ///     )
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
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .any
        }
        
        // Handle any last configurations before presenting alert
        configure?(alertController)
        
        present(alertController, animated: animated, completion: completion)
    }
    
    /// Display a prompt with a text field to the user.
    ///
    ///     present(
    ///         prompt: "Test Prompt",
    ///         message: "Enter user input.",
    ///         placeholder: "Your placeholder here",
    ///         configure: {
    ///             $0.keyboardType = .phonePad
    ///             $0.textContentType = .telephoneNumber
    ///         },
    ///         response: {
    ///             print("User response: \($0)")
    ///         }
    ///     )
    ///
    /// - Parameters:
    ///   - title: Title of the prompt.
    ///   - message: Body of the prompt.
    ///   - placeholder: The string that is displayed when there is no other text in the text field.
    ///   - buttonText: Text for the primary button.
    ///   - buttonStyle: Style to apply to the primary button.
    ///   - includeCancelAction: Include a cancel action within the alert.
    ///   - cancelText: Text for the cancel button.
    ///   - cancelHandler: Call back handler when cancel action tapped.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - configure: Configure the `UITextField` before it is loaded.
    ///   - response: Call back handler when main action tapped.
    func present(
        prompt title: String,
        message: String? = nil,
        placeholder: String? = nil,
        buttonText: String = .localized(.ok),
        buttonStyle: UIAlertAction.Style = .default,
        includeCancelAction: Bool = true,
        cancelText: String = .localized(.cancel),
        cancelHandler: (() -> Void)? = nil,
        animated: Bool = true,
        configure: ((UITextField) -> Void)? = nil,
        response: @escaping ((String?) -> Void))
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
        
        alertController.addTextField {
            $0.placeholder ?= placeholder
            
            // Handle any last configurations before presenting text field
            configure?($0)
        }
        
        alertController.addAction(
            UIAlertAction(title: buttonText, style: buttonStyle) { _ in
                guard let text = alertController.textFields?.first?.text else {
                    response(nil)
                    return
                }
                
                response(text)
            }
        )
        
        present(alertController, animated: animated, completion: nil)
    }
}

// MARK: - Safari

public extension UIViewController {
    
    /// Present a Safari view controller.
    ///
    /// Use `present(safari:)` or `show(safari:)` depending on desired transition effect.
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
        modalPresentationStyle: UIModalPresentationStyle? = .overFullScreen,
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
    
    /// Present or push a Safari view controller in a primary context.
    ///
    /// Use `present(safari:)` or `show(safari:)` depending on desired transition effect.
    ///
    /// - Parameters:
    ///   - url: URL to display in the browser.
    ///   - modalPresentationStyle: The presentation style of the model view controller.
    ///   - barTintColor: The color to tint the background of the navigation bar and the toolbar.
    ///   - preferredControlTintColor: The color to tint the control buttons on the navigation bar and the toolbar.
    ///   - animated: Pass true to animate the presentation.
    ///   - completion: The block to execute after the presentation finishes.
    func show(
        safari url: String,
        barTintColor: UIColor? = nil,
        preferredControlTintColor: UIColor? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil)
    {
        present(
            safari: url,
            modalPresentationStyle: nil,
            barTintColor: barTintColor,
            preferredControlTintColor: preferredControlTintColor,
            animated: animated,
            completion: completion
        )
    }
}

// MARK: - Activities

public extension UIViewController {
    
    /// Presents an activity view controller modally that you can use to offer various services from your application.
    ///
    ///     let safariActivity = UIActivity.make(
    ///         title: .localized(.openInSafari),
    ///         imageName: "safari-share",
    ///         imageBundle: .zamzamKit,
    ///         handler: {
    ///             guard SCNetworkReachability.isOnline else {
    ///                 return self.present(alert: "Device must be online to view within the browser.")
    ///             }
    ///
    ///             UIApplication.shared.open(link)
    ///         }
    ///     )
    ///
    ///     present(
    ///         activities: ["Test Title", link],
    ///         popoverFrom: sender,
    ///         applicationActivities: [safariActivity]
    ///     )
    ///
    /// - Parameters:
    ///   - activities: The array of data objects on which to perform the activity. The type of objects in the array is variable and dependent on the data your application manages.
    ///   - sourceView: The view containing the anchor rectangle for the popover for supporting iPad device.
    ///   - applicationActivities: An array of UIActivity objects representing the custom services that your application supports.
    func present(activities: [Any], popoverFrom sourceView: UIView, applicationActivities: [UIActivity]? = nil) {
        let activity = UIActivityViewController(activityItems: activities, applicationActivities: applicationActivities)
        
        if let popover = activity.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .any
        }

        present(activity, animated: true, completion: nil)
    }
    
    /// Presents an activity view controller modally that you can use to offer various services from your application.
    ///
    ///     let safariActivity = UIActivity.make(
    ///         title: .localized(.openInSafari),
    ///         imageName: "safari-share",
    ///         imageBundle: .zamzamKit,
    ///         handler: {
    ///             guard SCNetworkReachability.isOnline else {
    ///                 return self.present(alert: "Device must be online to view within the browser.")
    ///             }
    ///
    ///             UIApplication.shared.open(link)
    ///         }
    ///     )
    ///
    ///     present(
    ///         activities: ["Test Title", link],
    ///         barButtonItem: sender,
    ///         applicationActivities: [safariActivity]
    ///     )
    ///
    /// - Parameters:
    ///   - activities: The array of data objects on which to perform the activity. The type of objects in the array is variable and dependent on the data your application manages.
    ///   - barButtonItem: The bar button item containing the anchor rectangle for the popover for supporting iPad device.
    ///   - applicationActivities: An array of UIActivity objects representing the custom services that your application supports.
    func present(activities: [Any], barButtonItem: UIBarButtonItem, applicationActivities: [UIActivity]? = nil) {
        let activity = UIActivityViewController(activityItems: activities, applicationActivities: applicationActivities)
        
        if let popover = activity.popoverPresentationController {
            popover.barButtonItem = barButtonItem
            popover.permittedArrowDirections = .any
        }

        present(activity, animated: true, completion: nil)
    }
}

// MARK: - Dimensions

public extension UIViewController {
    
    /// Calculate points from a percentage of the width of the view.
    ///
    /// - Parameter value: Percentage of the width.
    /// - Returns: Points calculated from percentage of width.
    func percentX(_ value: CGFloat) -> CGFloat {
        return view.frame.width  * value
    }
    
    /// Calculate points from a percentage of the height of the view.
    ///
    /// - Parameter value: Percentage of the height.
    /// - Returns: Points calculated from percentage of height.
    func percentY(_ value: CGFloat) -> CGFloat {
        return view.frame.height * value
    }
}

