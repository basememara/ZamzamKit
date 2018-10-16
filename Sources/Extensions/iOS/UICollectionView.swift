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
    static let defaultCellIdentifier = "Cell"
    
    /**
     Register NIB to collection view. NIB name and cell reuse identifier can match for convenience.

     - parameter nibName: Name of the NIB.
     - parameter withIdentifier: Name of the reusable cell identifier.
     - parameter inBundle: Bundle if not local.
     */
    func register<T: UICollectionViewCell>(nib type: T.Type, withReuseIdentifier identifier: String = UICollectionView.defaultCellIdentifier, inBundle bundle: Bundle? = nil) {
        register(
            UINib(nibName: String(describing: type), bundle: bundle),
            forCellWithReuseIdentifier: identifier
        )
    }
}

public extension UICollectionView {
    
    /**
     Gets the reusable cell with default identifier name.

     - parameter indexPath: The index path of the cell from the collection.

     - returns: Returns the collection view cell.
     */
    subscript(indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: UICollectionView.defaultCellIdentifier, for: indexPath)
    }
    
    /**
     Gets the reusable cell with default identifier name.
     
     - parameter indexPath: The index path of the cell from the table.
     
     - returns: Returns the table view cell.
     */
    subscript<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: UICollectionView.defaultCellIdentifier, for: indexPath) as! T
    }

    /**
     Gets the reusable cell with the specified identifier name.

     - parameter indexPath: The index path of the cell from the collection.
     - parameter withReuseIdentifier: Name of the reusable cell identifier.

     - returns: Returns the collection view cell.
     */
    subscript(indexPath: IndexPath, withReuseIdentifier identifier: String) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    /**
     Gets the reusable cell with default identifier name.
     
     - parameter indexPath: The index path of the cell from the table.
     - parameter withReuseIdentifier: Name of the reusable cell identifier.
     
     - returns: Returns the table view cell.
     */
    subscript<T: UICollectionViewCell>(indexPath: IndexPath, withReuseIdentifier identifier: String) -> T {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}
