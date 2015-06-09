//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public class AlertService: NSObject {
    
    public func locationServiceDisabled(controller: UIViewController) {
        var alertController = UIAlertController (
            title: "Location Service Disabled",
            message: "To re-enable, please go to Settings and turn on Location Service for this app.",
            preferredStyle: .Alert
        )
        
        /* Apple warning: Linking against dylib not safe...
        var settingsAction = UIAlertAction(title: "Settings", style: .Default) {
            (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                application.openURL(url)
            }
        }
        alertController.addAction(settingsAction)
        */
        
        var okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        controller.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
