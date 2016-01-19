//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public class AlertHelper: NSObject {
    
    
}

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
    
    public func locationServiceDisabled(application: UIApplication, controller: UIViewController) {
        let settingsAction = UIAlertAction(title: "Settings", style: .Default) {
            (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                application.openURL(url)
            }
        }
        
        open(controller, message: "Location Service Disabled",
            title: "To re-enable, please go to Settings and turn on Location Service for this app.",
            additionalAction: settingsAction)
    }
}