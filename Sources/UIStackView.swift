//
//  UIStackView.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-01-09.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

public extension UIStackView {
    
    /// Adds a views to the end of the arrangedSubviews array.
    ///
    /// - Parameter views: List of views.
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
    
    /// Removes and releases all arranged subviews from `UIStackView` and `superview`.
    func deleteArrangedSubviews() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
