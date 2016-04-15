//
//  UITableViewController.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/7/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit

public extension UITableViewController {

    /**
     Adds activity indicator to the table view.
     http://stackoverflow.com/questions/29912852/how-to-show-activity-indicator-while-tableview-loads

     - returns: Returns an instance of the activity indicator that is centered.
     */
    public func setupActivityIndicator(
        viewStyle: UIActivityIndicatorViewStyle = .WhiteLarge,
        color: UIColor = .grayColor()) -> UIActivityIndicatorView {
            let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
            activityIndicator.activityIndicatorViewStyle = viewStyle
            activityIndicator.color = color
            activityIndicator.hidesWhenStopped = true
            activityIndicator.center = self.view.center
            
            self.view.addSubview(activityIndicator)
        
            return activityIndicator
    }
    
        /**
     Adds refresh control for pull to refresh functionality.

     - parameter action: Action to trigger for reload.
     - parameter title:  Title of the refresh title.
     - parameter font:   Font of the title.
     - parameter color:  Color of the title.
     */
    public func setupRefreshControl(action: Selector,
        title: String = "Pull to refresh",
        font: UIFont = UIFont(name: "AvenirNext-Medium", size: 18.0)!,
        color: UIColor = .lightGrayColor()) {
            let control = UIRefreshControl()
            control.attributedTitle = NSAttributedString(string: title, attributes: [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: color
            ])
            control.addTarget(self, action: action, forControlEvents: .ValueChanged)
        
            self.refreshControl = control
    }

}