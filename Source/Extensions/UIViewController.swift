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
    
    public func alert(message: String,
        title: String = "Alert",
        buttonTitle: String = "OK",
        additionalAction: UIAlertAction?) {
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .Alert
            )
            
            if let action = additionalAction {
                alertController.addAction(action)
            }
            
            let okAction = UIAlertAction(title: buttonTitle, style: .Default, handler: nil)
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
    }

}