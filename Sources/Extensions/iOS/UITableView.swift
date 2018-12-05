//
//  UITableView.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit

public extension UITableView {
    static let defaultCellIdentifier = "Cell"
    
    /// Register NIB to table view. NIB type and cell reuse identifier can match for convenience.
    ///
    /// - Parameters:
    ///   - type: Type of the NIB.
    ///   - identifier: Name of the reusable cell identifier.
    ///   - bundle: Bundle if not local.
    func register<T: UITableViewCell>(nib type: T.Type, withIdentifier identifier: String = UITableView.defaultCellIdentifier, inBundle bundle: Bundle? = nil) {
        register(
            UINib(nibName: String(describing: type), bundle: bundle),
            forCellReuseIdentifier: identifier
        )
    }
}

public extension UITableView {
    static let defaultHeaderFooterIdentifier = "Header"
    
    /// Register NIB to table view. NIB type and header/footer reuse identifier can match for convenience.
    ///
    /// - Parameters:
    ///   - type: Type of the NIB.
    ///   - identifier: Name of the reusable cell identifier.
    ///   - bundle: Bundle if not local.
    func register<T: UITableViewHeaderFooterView>(nib type: T.Type, withIdentifier identifier: String = UITableView.defaultHeaderFooterIdentifier, inBundle bundle: Bundle? = nil) {
        register(
            UINib(nibName: String(describing: type), bundle: bundle),
            forHeaderFooterViewReuseIdentifier: identifier
        )
    }
    
    /// Gets the reusable header with default identifier name.
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: UITableView.defaultHeaderFooterIdentifier) as? T
    }
}

public extension UITableView {
    
    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameter indexPath: The index path of the cell from the table.
    subscript(indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: UITableView.defaultCellIdentifier, for: indexPath)
    }

    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameter indexPath: The index path of the cell from the table.
    subscript<T: UITableViewCell>(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: UITableView.defaultCellIdentifier, for: indexPath) as! T
    }

    /// Gets the reusable cell with the specified identifier name.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the cell from the table.
    ///   - identifier: Name of the reusable cell identifier.
    subscript(indexPath: IndexPath, withIdentifier identifier: String) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
    
    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the cell from the table.
    ///   - identifier: Name of the reusable cell identifier.
    subscript<T: UITableViewCell>(indexPath: IndexPath, withIdentifier identifier: String) -> T {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
}

public extension Scrollable where Self: UITableView {
    
    /// Scrolls to the bottom of table view.
    ///
    /// - Parameter animated: `true` if you want to animate the change in position; `false` if it should be immediate.
    func scrollToBottom(animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        let lastSection = numberOfSections - 1
        
        let lastRow = numberOfRows(inSection: lastSection) - 1
        guard lastRow > 0 else { return }
        
        scrollToRow(
            at: IndexPath(row: lastRow, section: lastSection),
            at: .bottom,
            animated: animated
        )
    }
}
