//
//  WKInterfaceController.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
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
    
    /// Presents an alert or action sheet over the current interface controller.
    func present(
        alert title: String,
        message: String? = nil,
        buttonText: String = .localized(.ok),
        alertControllerStyle: WKAlertControllerStyle = .alert,
        additionalActions: [WKAlertAction]? = nil,
        includeCancelAction: Bool = false,
        cancelText: String = .localized(.cancel),
        cancelHandler: (() -> Void)? = nil,
        handler: (() -> Void)? = nil)
    {
            var actions = [
                WKAlertAction(title: buttonText, style: .default) {
                    handler?()
                }
            ]
            
            if includeCancelAction {
                actions.append(
                    WKAlertAction(title: cancelText, style: .cancel) {
                        cancelHandler?()
                    }
                )
            }
            
            // Add additional actions if applicable
            if let additionalActions = additionalActions, !additionalActions.isEmpty {
                if alertControllerStyle != .sideBySideButtonsAlert {
                    actions += additionalActions
                } else if actions.count < 2 {
                    // Only two actions are needed for side by side alert
                    actions.append(additionalActions.first!)
                }
            }
        
            presentAlert(
                withTitle: title,
                message: message,
                preferredStyle: alertControllerStyle,
                actions: actions
            )
    }
    
}
