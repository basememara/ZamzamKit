//
//  UICollectionView.swift
//  ZamzamUI
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UICollectionView {
    static let defaultCellIdentifier = "Cell"

    /// Register XIB to collection view.
    ///
    /// - Parameters:
    ///   - xibType: Type of the XIB.
    ///   - identifier: Name of the reusable cell identifier.
    ///   - bundle: Bundle if not local.
    func register<T: UICollectionViewCell>(
        xib xibType: T.Type,
        withReuseIdentifier identifier: String = UICollectionView.defaultCellIdentifier,
        inBundle bundle: Bundle? = nil
    ) {
        register(
            UINib(nibName: String(describing: xibType), bundle: bundle),
            forCellWithReuseIdentifier: identifier
        )
    }

    /// Register a class for use in creating new collection view cells.
    ///
    /// - Parameter cellClass: The class of a cell that you want to use in the collection view.
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: UICollectionView.defaultCellIdentifier)
    }
}

public extension UICollectionView {
    static let defaultSectionIdentifier = "Section"

    /// Register supplementary XIB to collection view.
    ///
    /// - Parameters:
    ///   - xibType: Type of the XIB.
    ///   - elementKind: The kind of supplementary view to create.
    ///   - identifier: Name of the reusable view identifier.
    ///   - bundle: Bundle if not local.
    func register<T: UICollectionReusableView>(
        supplementary xibType: T.Type,
        ofKind elementKind: String,
        withIdentifier identifier: String = UICollectionView.defaultSectionIdentifier,
        inBundle bundle: Bundle? = nil
    ) {
        register(
            UINib(nibName: String(describing: xibType), bundle: bundle),
            forSupplementaryViewOfKind: elementKind,
            withReuseIdentifier: identifier
        )
    }

    /// Gets the reusable supplementary view with default identifier name.
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: UICollectionView.defaultSectionIdentifier,
            for: indexPath
        ) as? T ?? T()
    }

    /// Register header XIB to collection view.
    ///
    /// - Parameters:
    ///   - xibType: Type of the XIB.
    ///   - identifier: Name of the reusable view identifier.
    ///   - bundle: Bundle if not local.
    func register<T: UICollectionReusableView>(
        header xibType: T.Type,
        withIdentifier identifier: String = UICollectionView.defaultSectionIdentifier,
        inBundle bundle: Bundle? = nil
    ) {
        register(supplementary: xibType, ofKind: UICollectionView.elementKindSectionHeader, withIdentifier: identifier, inBundle: bundle)
    }

    /// Gets the reusable header with default identifier name.
    func dequeueReusableHeaderView<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            for: indexPath
        )
    }

    /// Register footer XIB to collection view.
    ///
    /// - Parameters:
    ///   - xibType: Type of the XIB.
    ///   - identifier: Name of the reusable view identifier.
    ///   - bundle: Bundle if not local.
    func register<T: UICollectionReusableView>(
        footer xibType: T.Type,
        withIdentifier identifier: String = UICollectionView.defaultSectionIdentifier,
        inBundle bundle: Bundle? = nil
    ) {
        register(supplementary: xibType, ofKind: UICollectionView.elementKindSectionFooter, withIdentifier: identifier, inBundle: bundle)
    }

    /// Gets the reusable footer with default identifier name.
    func dequeueReusableFooterView<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            for: indexPath
        )
    }
}

public extension UICollectionView {
    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameter indexPath: The index path of the cell from the collection.
    subscript(indexPath: IndexPath) -> UICollectionViewCell {
        dequeueReusableCell(withReuseIdentifier: UICollectionView.defaultCellIdentifier, for: indexPath)
    }

    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameter indexPath: The index path of the cell from the collection.
    subscript<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: UICollectionView.defaultCellIdentifier, for: indexPath) as? T ?? T()
    }

    /// Gets the reusable cell with the specified identifier name.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the cell from the collection.
    ///   - identifier: Name of the reusable cell identifier.
    subscript(indexPath: IndexPath, withReuseIdentifier identifier: String) -> UICollectionViewCell {
        dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the cell from the collection.
    ///   - identifier: Name of the reusable cell identifier.
    subscript<T: UICollectionViewCell>(indexPath: IndexPath, withReuseIdentifier identifier: String) -> T {
        dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T ?? T()
    }
}
#endif
