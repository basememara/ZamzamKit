//
//  UIStackView.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-01-09.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

public extension UIStackView {
    
    /// Removes and releases all arranged subviews from `UIStackView` and `superview`.
    func removeArrangedSubviewsFromSuperview() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
