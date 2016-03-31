//
//  UITableView.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    
    /**
     Register NIB to table view. NIB name and cell reuse identifier can match for convenience.

     - parameter nibName:          Name of the NIB.
     - parameter bundleIdentifier: Name of the bundle identifier if not local.
     - parameter cellReuseIdentifier: Name of the cell identifier if difference than NIB name.
     */
    public func registerNib(nibName: String, bundleIdentifier: String? = nil, cellReuseIdentifier: String? = nil) {
        self.registerNib(UINib(nibName: nibName,
            bundle: bundleIdentifier != nil ? NSBundle(identifier: bundleIdentifier!) : nil),
            forCellReuseIdentifier: cellReuseIdentifier ?? nibName)
    }

}