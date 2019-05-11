//
//  UIViewControllerExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import UIKit
import SafariServices

public extension UIViewController {
    
    /// Constructs an instance of the UIViewController type.
    ///
    /// - Parameters:
    ///   - storyboard: The Storyboard where the UIViewController is bound to.
    ///   - bundle: The bundle where the Storyboard is stored.
    ///   - identifier: The identifier of the UIViewController on the Storyboard,
    ///         or will fallback on the UIViewController designated as the initial
    ///         storyboard, or the UIViewController in the Storyboard with the
    ///         same identifier as the type name.
    /// - Returns: An instance of the UIViewController type.
    static func make<T: UIViewController>(
        fromStoryboard storyboard: String,
        inBundle bundle: Bundle? = nil,
        identifier: String? = nil
    ) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier ?? "")
            : (storyboard.instantiateInitialViewController()
                ?? storyboard.instantiateViewController(withIdentifier: String(describing: T.self)))) as? T else {
                    // Check crash logs for occurances, confirm remote logger properly setup
                    fatalError("Invalid controller for storyboard \(storyboard).")
        }
        
        return controller
    }
}

public extension UIViewController {
    
    /// The root view controller for the container view controller, or returns itself if it is not embeded.
    var contentViewController: UIViewController {
        return (self as? UINavigationController)?.viewControllers.first
            ?? (self as? UITabBarController)?.selectedViewController
            ?? self
    }

    /// Causes the view to resign the first responder status.
    @objc func endEditing() {
        view.endEditing(true)
    }
}

// MARK: - Default parameters

public extension UIViewController {
    
    /// Presents a view controller modally.
    ///
    /// - Parameters:
    ///   - viewControllerToPresent: The view controller to display over the current view controller’s content.
    ///   - completion: The block to execute after the presentation finishes.
    func present(_ viewControllerToPresent: UIViewController, completion: (() -> Void)? = nil) {
        present(viewControllerToPresent, animated: true, completion: completion)
    }
    
    /// Presents or pushes a view controller in a primary context.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to display.
    ///   - sender: The object that initiated the request.
    func show(viewController: UIViewController, sender: Any? = nil) {
        show(viewController, sender: sender)
    }
}

// MARK: - Exit

public extension UIViewController {
    
    /// Dismisses the view controller that was presented.
    ///
    /// - Parameters:
    ///   - completion: The block to execute after the view controller is dismissed.
    func dismiss(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
    
    /// Dismisses or pops the view controller that was presented modally by the view controller.
    ///
    /// This method dismisses the view controller or pops it if it is part of a navigation controller.
    /// If the view controller is the last in the stack of a navigation controller, this method will
    /// dismiss the navigation controller. In other words, it will no longer be presented modally.
    ///
    /// - Parameters:
    ///   - animated: Set this value to true to animate the transition.
    ///   - completion: The block to execute after the the task finishes.
    func dismissOrPop(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let navigationController = navigationController else {
            dismiss(animated: animated, completion: completion)
            return
        }
        
        guard navigationController.viewControllers.count > 1 else {
            navigationController.dismiss(animated: animated, completion: completion)
            return
        }
        
        navigationController.popViewController(animated: animated, completion: completion)
    }
    
    /// Closes the view controller and container that was presenting it.
    ///
    /// - Parameters:
    ///   - animated: Set this value to true to animate the transition.
    ///   - completion: The block to execute after the the task finishes.
    func close(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController?.dismiss(animated: animated, completion: completion)
            ?? dismiss(animated: animated, completion: completion)
    }
}

public extension UIViewController {
    
    /// Adds the specified view controller as a child of the current view controller.
    ///
    ///     add(child: viewController1)
    ///     add(child: viewController2, to: containerView)
    ///
    /// - Parameters:
    ///   - viewController: The child view controller.
    ///   - containerView: The target view, or `nil` to use the current view controller `view`.
    func add(child viewController: UIViewController, to containerView: UIView? = nil) {
        // https://cocoacasts.com/managing-view-controllers-with-container-view-controllers/
        // https://useyourloaf.com/blog/container-view-controllers/
        guard let containerView = containerView ?? view else { return }
        
        addChild(viewController)
        
        containerView.addSubview(viewController.view)
        viewController.view.edges(to: containerView)
        
        viewController.didMove(toParent: self)
    }
    
    /// Removes and unlink the view controller from its parent, and notifies any listeners.
    func remove() {
        // https://www.swiftbysundell.com/posts/using-child-view-controllers-as-plugins-in-swift
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
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
    /// - Returns: Returns the alert controller instance that was presented.
    @discardableResult
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
        handler: (() -> Void)? = nil
    ) -> UIAlertController {
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
        return alertController
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
    /// - Returns: Returns the alert controller instance that was presented.
    @discardableResult
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
        completion: (() -> Void)? = nil
    ) -> UIAlertController {
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
        return alertController
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
    ///   - barButtonItem: The bar button item containing the anchor rectangle for the popover for supporting iPad device.
    ///   - additionalActions: Array of alert actions.
    ///   - includeCancelAction: Include a cancel action within the alert.
    ///   - cancelText: Text for the cancel button.
    ///   - cancelHandler: Call back handler when cancel action tapped.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - configure: Configure the `UIAlertController` before it is loaded.
    ///   - completion: The block to execute after the presentation finishes.
    /// - Returns: Returns the alert controller instance that was presented.
    @discardableResult
    func present(
        actionSheet title: String?,
        message: String? = nil,
        barButtonItem: UIBarButtonItem,
        additionalActions: [UIAlertAction],
        includeCancelAction: Bool = false,
        cancelText: String = .localized(.cancel),
        cancelHandler: (() -> Void)? = nil,
        animated: Bool = true,
        configure: ((UIAlertController) -> Void)? = nil,
        completion: (() -> Void)? = nil
    ) -> UIAlertController {
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
            popover.barButtonItem = barButtonItem
            popover.permittedArrowDirections = .any
        }
        
        // Handle any last configurations before presenting alert
        configure?(alertController)
        
        present(alertController, animated: animated, completion: completion)
        return alertController
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
    /// - Returns: Returns the alert controller instance that was presented.
    @discardableResult
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
        response: @escaping ((String?) -> Void)
    ) -> UIAlertController {
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
        return alertController
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
    /// - Returns: Returns the alert controller instance that was presented.
    @discardableResult
    func present(
        safari url: String,
        modalPresentationStyle: UIModalPresentationStyle? = .overFullScreen,
        barTintColor: UIColor? = nil,
        preferredControlTintColor: UIColor? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) -> SFSafariViewController {
        guard let url = URL(string: url) else {
            fatalError("Invalid url.")
        }
        
        let controller = SFSafariViewController(url: url).with {
            $0.delegate = self as? SFSafariViewControllerDelegate
            $0.modalPresentationStyle ?= modalPresentationStyle
            $0.preferredBarTintColor ?= barTintColor
            $0.preferredControlTintColor ?= preferredControlTintColor
        }
        
        present(controller, animated: animated, completion: completion)
        return controller
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
    /// - Returns: Returns the alert controller instance that was presented.
    @discardableResult
    func show(
        safari url: String,
        barTintColor: UIColor? = nil,
        preferredControlTintColor: UIColor? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) -> SFSafariViewController {
        return present(
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
    /// - Returns: Returns the activity view controller instance that was presented.
    @discardableResult
    func present(activities: [Any], popoverFrom sourceView: UIView, applicationActivities: [UIActivity]? = nil) -> UIActivityViewController {
        let activity = UIActivityViewController(activityItems: activities, applicationActivities: applicationActivities)
        
        if let popover = activity.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .any
        }

        present(activity, animated: true, completion: nil)
        return activity
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
    /// - Returns: Returns the activity view controller instance that was presented.
    @discardableResult
    func present(activities: [Any], barButtonItem: UIBarButtonItem, applicationActivities: [UIActivity]? = nil) -> UIActivityViewController {
        let activity = UIActivityViewController(activityItems: activities, applicationActivities: applicationActivities)
        
        if let popover = activity.popoverPresentationController {
            popover.barButtonItem = barButtonItem
            popover.permittedArrowDirections = .any
        }

        present(activity, animated: true, completion: nil)
        return activity
    }
}

private extension UIViewController {
    //swiftlint:disable file_length
}
