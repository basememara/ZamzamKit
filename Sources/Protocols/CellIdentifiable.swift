//
//  CellIdentifiable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/28/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

public protocol CellIdentifiable {
    associatedtype CellIdentifier: RawRepresentable
}

public extension CellIdentifiable where Self: UITableViewController, CellIdentifier.RawValue == String {

    /**
     Gets the visible cell with the specified identifier name.

     - parameter identifier: Enum value of the cell identifier.

     - returns: Returns the table view cell.
     */
    func tableView(cell identifier: CellIdentifier) -> UITableViewCell? {
        return tableView.visibleCells.first { $0.reuseIdentifier == identifier.rawValue }
    }
}
