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
    func setupActivityIndicator(
        style: UIActivityIndicatorViewStyle = .whiteLarge,
        color: UIColor = .gray) -> UIActivityIndicatorView {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            activityIndicator.activityIndicatorViewStyle = style
            activityIndicator.color = color
            activityIndicator.hidesWhenStopped = true
            activityIndicator.center = view.center
            
            view.addSubview(activityIndicator)
        
            return activityIndicator
    }
}
