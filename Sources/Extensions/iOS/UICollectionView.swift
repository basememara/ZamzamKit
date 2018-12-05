//
//  UICollectionView.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit

public extension UICollectionView {
    static let defaultCellIdentifier = "Cell"
    
    /// Register NIB to collection view. NIB name and cell reuse identifier can match for convenience.
    ///
    /// - Parameters:
    ///   - type: Name of the NIB.
    ///   - identifier: Name of the reusable cell identifier.
    ///   - bundle: Bundle if not local.
    func register<T: UICollectionViewCell>(nib type: T.Type, withReuseIdentifier identifier: String = UICollectionView.defaultCellIdentifier, inBundle bundle: Bundle? = nil) {
        register(
            UINib(nibName: String(describing: type), bundle: bundle),
            forCellWithReuseIdentifier: identifier
        )
    }
}

public extension UICollectionView {
    
    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameter indexPath: The index path of the cell from the collection.
    subscript(indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: UICollectionView.defaultCellIdentifier, for: indexPath)
    }
    
    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameter indexPath: The index path of the cell from the collection.
    subscript<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: UICollectionView.defaultCellIdentifier, for: indexPath) as! T
    }

    /// Gets the reusable cell with the specified identifier name.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the cell from the collection.
    ///   - identifier: Name of the reusable cell identifier.
    subscript(indexPath: IndexPath, withReuseIdentifier identifier: String) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the cell from the collection.
    ///   - identifier: Name of the reusable cell identifier.
    subscript<T: UICollectionViewCell>(indexPath: IndexPath, withReuseIdentifier identifier: String) -> T {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}
