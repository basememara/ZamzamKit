//
//  UICollectionView.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionView {

    public static var defaultCellIdentifier: String {
        return "Cell"
    }
    
    /**
     Register NIB to table view. NIB name and cell reuse identifier can match for convenience.

     - parameter nibName: Name of the NIB.
     - parameter cellIdentifier: Name of the reusable cell identifier.
     - parameter bundleIdentifier: Name of the bundle identifier if not local.
     */
    public func registerNib(nibName: String, cellIdentifier: String = defaultCellIdentifier, bundleIdentifier: String? = nil) {
        self.registerNib(UINib(nibName: nibName,
            bundle: bundleIdentifier != nil ? NSBundle(identifier: bundleIdentifier!) : nil),
            forCellWithReuseIdentifier: cellIdentifier)
    }

    /**
     Gets the reusable cell with default identifier name.

     - parameter indexPath: The index path of the cell from the collection.

     - returns: Returns the collection view cell.
     */
    public subscript(indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.dequeueReusableCellWithReuseIdentifier(UICollectionView.defaultCellIdentifier, forIndexPath: indexPath)
    
    }

    /**
     Gets the reusable cell with the specified identifier name.

     - parameter indexPath: The index path of the cell from the collection.
     - parameter identifier: Name of the reusable cell identifier.

     - returns: Returns the collection view cell.
     */
    public subscript(indexPath: NSIndexPath, identifier: String) -> UICollectionViewCell {
        return self.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    }

}