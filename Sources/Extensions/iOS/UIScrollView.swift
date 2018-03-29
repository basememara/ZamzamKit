//
//  UIScrollView.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-02-20.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

extension UIScrollView: Scrollable { }

public extension Scrollable where Self: UIScrollView {
    
    /// Sets the offset from the content view’s origin to the top.
    ///
    /// - Parameter animated: `true` to animate the transition at a constant
    ///     velocity to the new offset, `false` to make the transition immediate.
    func scrollToTop(animated: Bool = true) {
        setContentOffset(
            CGPoint(x: CGFloat(0), y: {
                guard #available(iOS 11, *) else { return -contentInset.top }
                return -adjustedContentInset.top
            }()),
            animated: animated
        )
    }
    
    /// Sets the offset from the content view’s origin to the bottom.
    ///
    /// - Parameter animated: `true` to animate the transition at a constant
    ///     velocity to the new offset, `false` to make the transition immediate.
    func scrollToBottom(animated: Bool = true) {
        // https://stackoverflow.com/q/952412/235334
        setContentOffset(
            CGPoint(x: 0, y: max(contentSize.height - bounds.size.height, 0)),
            animated: animated
        )
    }
}
