//
//  UICollectionViewController.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/1/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit

public extension UICollectionViewController {

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

}