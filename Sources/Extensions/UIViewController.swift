//
//  UIViewControllerExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    
    /**
     Display an alert action in a convenient way.

     - parameter message:           Body of the alert.
     - parameter title:             Title of the alert.
     - parameter buttonTitle:       Text for the button.
     - parameter additionalActions: Array of alert actions.
     - parameter handler:           Call back handler when main action tapped.
     */
    public func alert(
        message: String? = nil,
        title: String = "Alert",
        buttonTitle: String = "OK",
        additionalActions: [UIAlertAction]? = nil,
        preferredStyle: UIAlertControllerStyle = .Alert,
        enableCancel: Bool = false,
        handler: (() -> Void)? = nil) {
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: preferredStyle
            )
        
            if enableCancel {
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            }
            
            if let additionalActions = additionalActions {
                additionalActions.forEach { item in
                    alertController.addAction(item)
                }
            }
            
            alertController.addAction(UIAlertAction(title: buttonTitle) { handler?() })
            
            self.presentViewController(alertController, animated: true, completion: nil)
    }

}