//
//  UIScrollView.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-02-20.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

public extension UIScrollView {
    
    /// Sets the offset from the content view’s origin to the top.
    ///
    /// - Parameter animated: `true` to animate the transition at a constant
    ///     velocity to the new offset, `false` to make the transition immediate.
    func scrollToTop(animated: Bool = true) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
}
