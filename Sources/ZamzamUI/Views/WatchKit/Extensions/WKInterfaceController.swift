//
//  WKInterfaceController.swift
//  ZamzamUI
//
//  Created by Basem Emara on 3/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if os(watchOS)
import WatchKit

public extension WKInterfaceController {
    
    /// Presents a single interface controller modally.
    ///
    /// - Parameters:
    ///   - type: The type of the interface controller you want to display.
    ///   - context: An object to pass to the new interface controller.
    func present<T: WKInterfaceController>(controller type: T.Type, context: Any? = nil) {
        presentController(withName: String(describing: type.self), context: context)
    }
}

public extension WKInterfaceController {
    
    /// Presents an alert over the current interface controller.
    ///
    ///     present(
    ///         alert: "Test",
    ///         message: "This is the message.",
    ///         includeCancelAction: true
    ///     )
    ///
    /// - Parameters:
    ///   - title: Title of the alert.
    ///   - message: Body of the alert.
    ///   - buttonText: Text for the primary button.
    ///   - additionalActions: Array of alert actions.
    ///   - includeCancelAction: Include a cancel action within the alert.
    ///   - cancelText: Text for the cancel button.
    ///   - cancelHandler: Call back handler when cancel action tapped.
    ///   - handler: Call back handler when main action tapped.
    func present(
        alert title: String?,
        message: String? = nil,
        buttonText: String = .localized(.ok),
        additionalActions: [WKAlertAction]? = nil,
        includeCancelAction: Bool = false,
        cancelText: String = .localized(.cancel),
        cancelHandler: (() -> Void)? = nil,
        handler: (() -> Void)? = nil
    ) {
        var actions = [
            WKAlertAction(title: buttonText, style: .default) {
                handler?()
            }
        ]
        
        if let additionalActions = additionalActions {
            actions.append(contentsOf: additionalActions)
        }
        
        if includeCancelAction {
            actions.append(
                WKAlertAction(title: cancelText, style: .cancel) {
                    cancelHandler?()
                }
            )
        }
    
        presentAlert(
            withTitle: title,
            message: message,
            preferredStyle: .alert,
            actions: actions
        )
    }
    
    /// Presents an action sheet over the current interface controller.
    ///
    ///     present(
    ///         actionSheet: "Test",
    ///         message: "This is the message.",
    ///         additionalActions: [
    ///             WKAlertAction(title: "Action 1", handler: {}),
    ///             WKAlertAction(title: "Action 2", handler: {}),
    ///             WKAlertAction(title: "Action 3", style: .destructive, handler: {})
    ///         ],
    ///         includeCancelAction: true
    ///     )
    ///
    /// - Parameters:
    ///   - title: Title of the alert.
    ///   - message: Body of the alert.
    ///   - additionalActions: Array of alert actions.
    ///   - includeCancelAction: Include a cancel action within the alert.
    ///   - cancelText: Text for the cancel button.
    ///   - cancelHandler: Call back handler when cancel action tapped.
    func present(
        actionSheet title: String,
        message: String? = nil,
        additionalActions: [WKAlertAction],
        includeCancelAction: Bool = false,
        cancelText: String = .localized(.cancel),
        cancelHandler: (() -> Void)? = nil
    ) {
        var actions = additionalActions
        
        if includeCancelAction {
            actions.append(
                WKAlertAction(title: cancelText, style: .cancel) {
                    cancelHandler?()
                }
            )
        }
        
        presentAlert(
            withTitle: title,
            message: message,
            preferredStyle: .actionSheet,
            actions: actions
        )
    }
    
    /// Presents an side-by-side alert over the current interface controller.
    ///
    ///     present(
    ///         sideBySideAlert: "Test",
    ///         message: "This is the message."
    ///     )
    ///
    /// - Parameters:
    ///   - title: Title of the alert.
    ///   - message: Body of the alert.
    ///   - buttonText: Text for the primary button.
    ///   - cancelText: Text for the cancel button.
    ///   - cancelHandler: Call back handler when cancel action tapped.
    ///   - handler: Call back handler when main action tapped.
    func present(
        sideBySideAlert title: String,
        message: String? = nil,
        buttonText: String = .localized(.ok),
        cancelText: String = .localized(.cancel),
        cancelHandler: (() -> Void)? = nil,
        handler: (() -> Void)? = nil
    ) {
        presentAlert(
            withTitle: title,
            message: message,
            preferredStyle: .sideBySideButtonsAlert,
            actions: [
                WKAlertAction(title: cancelText, style: .cancel) {
                    cancelHandler?()
                },
                WKAlertAction(title: buttonText, style: .default) {
                    handler?()
                }
            ]
        )
    }
}
#endif
