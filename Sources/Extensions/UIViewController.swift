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
    
    public func alert(
        message: String? = nil,
        title: String = "Alert",
        buttonTitle: String = "OK",
        additionalActions: [UIAlertAction]? = nil,
        handler: ((action: UIAlertAction) -> Void)? = nil) {
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .Alert
            )
            
            if let additionalActions = additionalActions {
                additionalActions.forEach { item in
                    alertController.addAction(item)
                }
            }
            
            alertController.addAction(UIAlertAction(
                title: buttonTitle, style: .Default, handler: handler))
            
            self.presentViewController(alertController, animated: true, completion: nil)
    }

}