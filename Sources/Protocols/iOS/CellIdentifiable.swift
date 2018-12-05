//
//  CellIdentifiable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/28/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

/// Enables cell indentifiers for static tables.
///
/// Each table view cell must have an identifier set that matches a `CellIdentifier` case.
///
///     class ViewController: UITableViewController {
///
///     }
///
///     extension ViewController: CellIdentifiable {
///
///         enum CellIdentifier: String {
///             case about
///             case subscribe
///             case feedback
///             case tutorial
///         }
///     }
///
///     extension ViewController {
///
///         override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
///             tableView.deselectRow(at: indexPath, animated: true)
///
///             guard let cell = tableView.cellForRow(at: indexPath),
///                 let identifier = CellIdentifier(from: cell) else {
///                     return
///             }
///
///             switch identifier {
///             case .about:
///                 router.showAbout()
///             case .subscribe:
///                 router.showSubscribe()
///             case .feedback:
///                 router.sendFeedback(
///                     subject: .localizedFormat(.emailFeedbackSubject, constants.appDisplayName!)
///                 )
///             case .tutorial:
///                 router.startTutorial()
///             }
///         }
///     }
public protocol CellIdentifiable {
    associatedtype CellIdentifier: RawRepresentable
}

public extension CellIdentifiable where Self: UITableViewController, CellIdentifier.RawValue == String {

    /// Gets the visible cell with the specified identifier name.
    ///
    /// - Parameter identifier: Enum value of the cell identifier.
    /// - Returns: Returns the table view cell.
    func tableViewCell(at identifier: CellIdentifier) -> UITableViewCell? {
        return tableView.visibleCells.first { $0.reuseIdentifier == identifier.rawValue }
    }
}

public extension RawRepresentable where Self.RawValue == String {
    
    init?(from cell: UITableViewCell) {
        guard let identifier = cell.reuseIdentifier else { return nil }
        self.init(rawValue: identifier)
    }
}
