//
//  AlertHelper.swift
//  Pods
//
//  Created by Basem Emara on 1/20/16.
//
//

import Foundation

public extension AlertHelper {
    
    public func open(controller: UIViewController, message: String,
        title: String = "Alert",
        buttonTitle: String = "OK",
        additionalAction: UIAlertAction?) {
            let alertController = UIAlertController (
                title: title,
                message: message,
                preferredStyle: .Alert
            )
            
            if let action = additionalAction {
                alertController.addAction(action)
            }
            
            let okAction = UIAlertAction(title: buttonTitle, style: .Default, handler: nil)
            alertController.addAction(okAction)
            
            controller.presentViewController(alertController, animated: true, completion: nil)
    }
}