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
        _ viewStyle: UIActivityIndicatorViewStyle = .whiteLarge,
        color: UIColor = .gray) -> UIActivityIndicatorView {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            activityIndicator.activityIndicatorViewStyle = viewStyle
            activityIndicator.color = color
            activityIndicator.hidesWhenStopped = true
            activityIndicator.center = self.view.center
            
            self.view.addSubview(activityIndicator)
        
            return activityIndicator
    }

}
