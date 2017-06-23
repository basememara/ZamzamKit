//
//  UITableViewCell.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/30/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

public extension UITableViewCell {

    /// The color of the cell when it is selected.
    var selectionColor: UIColor? {
        get { return selectedBackgroundView?.backgroundColor }
        set {
            guard selectionStyle != .none else { return }
            selectedBackgroundView = UIView().with {
                $0.backgroundColor = newValue
            }
        }
    }
}
