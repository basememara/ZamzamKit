//
//  UITableView.swift
//  ZamzamUI
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UITableView {
    static let defaultCellIdentifier = "Cell"

    /// Register XIB to table view.
    ///
    /// - Parameters:
    ///   - xibType: Type of the XIB.
    ///   - identifier: Name of the reusable cell identifier.
    ///   - bundle: Bundle if not local.
    func register<T: UITableViewCell>(
        xib xibType: T.Type,
        withIdentifier identifier: String = UITableView.defaultCellIdentifier,
        inBundle bundle: Bundle? = nil
    ) {
        register(
            UINib(nibName: String(describing: xibType), bundle: bundle),
            forCellReuseIdentifier: identifier
        )
    }

    /// Register a class for use in creating new table view cells.
    ///
    /// - Parameter cellClass: The class of a cell that you want to use in the table view.
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: UITableView.defaultCellIdentifier)
    }
}

public extension UITableView {
    static let defaultHeaderFooterIdentifier = "Section"

    /// Register XIB to table view.
    ///
    /// - Parameters:
    ///   - xibType: Type of the XIB.
    ///   - identifier: Name of the reusable cell identifier.
    ///   - bundle: Bundle if not local.
    func register<T: UITableViewHeaderFooterView>(
        xib xibType: T.Type,
        withIdentifier identifier: String = UITableView.defaultHeaderFooterIdentifier,
        inBundle bundle: Bundle? = nil
    ) {
        register(
            UINib(nibName: String(describing: xibType), bundle: bundle),
            forHeaderFooterViewReuseIdentifier: identifier
        )
    }

    /// Gets the reusable header with default identifier name.
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? {
        dequeueReusableHeaderFooterView(withIdentifier: UITableView.defaultHeaderFooterIdentifier) as? T
    }
}

public extension UITableView {
    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameter indexPath: The index path of the cell from the table.
    subscript(indexPath: IndexPath) -> UITableViewCell {
        dequeueReusableCell(withIdentifier: UITableView.defaultCellIdentifier, for: indexPath)
    }

    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameter indexPath: The index path of the cell from the table.
    subscript<T: UITableViewCell>(indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: UITableView.defaultCellIdentifier, for: indexPath) as? T ?? T()
    }

    /// Gets the reusable cell with the specified identifier name.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the cell from the table.
    ///   - identifier: Name of the reusable cell identifier.
    subscript(indexPath: IndexPath, withIdentifier identifier: String) -> UITableViewCell {
        dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }

    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the cell from the table.
    ///   - identifier: Name of the reusable cell identifier.
    subscript<T: UITableViewCell>(indexPath: IndexPath, withIdentifier identifier: String) -> T {
        dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T ?? T()
    }
}

public extension Scrollable where Self: UITableView {
    /// Scrolls to the top of table view.
    ///
    /// - Parameter animated: `true` if you want to animate the change in position; `false` if it should be immediate.
    func scrollToTop(animated: Bool = true) {
        let indexPath = IndexPath(row: 0, section: 0)

        // Ensure row exists before scrolling
        guard indexPath.section < numberOfSections
            && indexPath.row < numberOfRows(inSection: indexPath.section) else {
                return
        }

        scrollToRow(at: indexPath, at: .top, animated: animated)
    }

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
#endif
