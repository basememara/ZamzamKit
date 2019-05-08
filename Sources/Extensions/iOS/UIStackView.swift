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
    ///
    /// Chaining commands is possible.
    ///
    ///     stackView
    ///         .deleteArrangedSubviews()
    ///         .addArrangedSubviews([view1, view2, view3])
    @discardableResult
    func deleteArrangedSubviews() -> Self {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        return self
    }
}

public extension UIStackView {
    
    /// Adds a view to the end of the arrangedSubviews array with animation.
    func addArrangedSubview(_ view: UIView, animated: Bool, withDuration duration: TimeInterval = 0.35) {
        guard animated else { return addArrangedSubview(view) }
        
        view.isHidden = true
        view.alpha = 0
        
        addArrangedSubview(view)
        
        UIView.animate(withDuration: duration) {
            view.isHidden = false
            view.alpha = 1
        }
    }
    
    /// Adds a views to the end of the arrangedSubviews array with animation.
    ///
    /// - Parameter views: List of views.
    func addArrangedSubviews(_ views: [UIView], animated: Bool, withDuration duration: TimeInterval = 0.35) {
        guard animated else { return addArrangedSubviews(views) }
        
        views.forEach {
            $0.isHidden = true
            $0.alpha = 0
        }
        
        addArrangedSubviews(views)
        
        UIView.animate(withDuration: duration) {
            views.forEach {
                $0.isHidden = false
                $0.alpha = 1
            }
        }
    }
}
