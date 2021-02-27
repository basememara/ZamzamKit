//
//  UIView.swift
//  ZamzamUI
//
//  Created by Basem Emara on 5/25/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit
import ZamzamCore

public extension UIView {
    /// Unarchives the contents of a XIB file associated with the receiver.
    ///
    /// - Parameters:
    ///   - name: The name of the XIB file. Defaults to the type's class name.
    /// - Returns: The instantiated type with its associated XIB unarchived.
    static func loadNIB(named name: String? = nil) -> Self {
        // Internal function used to handle generics and
        // returning the actual view type instead of `UIView`.
        func loadNIBHelper<T>(named name: String? = nil) -> T where T: UIView {
            let bundle = Bundle(for: T.self)
            let name = name ?? String(describing: T.self)
            return bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T ?? T()
        }

        return loadNIBHelper(named: name)
    }
}

public extension UIView {
    /// A Boolean value that determines whether the view is visible.
    var isVisible: Bool {
        get { !isHidden }
        set { isHidden = !newValue }
    }

    /// Returns the width of the frame.
    var width: CGFloat {
        get { frame.width }
        set { frame.size.width = newValue }
    }

    /// Returns the height of the frame.
    var height: CGFloat {
        get { frame.height }
        set { frame.size.height = newValue }
    }
}

public extension UIView {
    /// Border color of view; also inspectable from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }

        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }

            layer.borderColor = color.cgColor
        }
    }

    /// Border width of view; also inspectable from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    /// Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }

        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
}

public extension UIView {
	/// Add shadow to view.
	///
	/// - Parameters:
	///   - color: shadow color (default is #137992).
	///   - radius: shadow radius (default is 3).
	///   - offset: shadow offset (default is .zero).
	///   - opacity: shadow opacity (default is 0.5).
	func addShadow(
        ofColor color: UIColor = .black,
        radius: CGFloat = 3,
        offset: CGSize = .zero,
        opacity: Float = 0.5
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
	}
}

public extension UIView {
    /// Fade in view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 0.25 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeIn(duration: TimeInterval = 0.25, completion: ((Bool) -> Void)? = nil) {
        guard isHidden || alpha < 1 else {
            completion?(true)
            return
        }

        let originalAlpha = alpha

        if isHidden {
            alpha = 0
        }

        UIView.animate(
            withDuration: duration,
            animations: {
                self.isHidden = false
                self.alpha = originalAlpha
            },
            completion: completion
        )
    }

    /// Fade out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 0.25 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeOut(duration: TimeInterval = 0.25, completion: ((Bool) -> Void)? = nil) {
        guard !isHidden || alpha > 0 else {
            completion?(true)
            return
        }

        let originalAlpha = alpha

        UIView.animate(
            withDuration: duration,
            animations: {
                self.alpha = 0
            },
            completion: {
                self.isHidden = true
                self.alpha = originalAlpha
                completion?($0)
            }
        )
    }

    /// Fade out or in view based on current state.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 0.25 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeToggle(duration: TimeInterval = 0.25, completion: ((Bool) -> Void)? = nil) {
        guard isHidden else { return fadeOut(duration: duration, completion: completion) }
        fadeIn(duration: duration, completion: completion)
    }

    /// Fade out or in view based on current state.
    ///
    /// - Parameters:
    ///   - value: Fade out or in view based on this value.
    ///   - duration: animation duration in seconds (default is 0.25 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeToggle(_ value: Bool, duration: TimeInterval = 0.25, completion: ((Bool) -> Void)? = nil) {
        guard value else { return fadeOut(duration: duration, completion: completion) }
        fadeIn(duration: duration, completion: completion)
    }
}

public extension UIView {
    /// Returns the user interface direction.
    var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
    }
}

public extension UIView {
    /// Adds activity indicator to the center of the view.
    ///
    /// - Parameters:
    ///   - style: The basic appearance of the activity indicator.
    ///   - color: The color of the activity indicator.
    ///   - size: The frame rectangle for the view, measured in points.
    /// - Returns: Returns an instance of the activity indicator.
    func makeActivityIndicator(
        style: UIActivityIndicatorView.Style = .whiteLarge,
        color: UIColor = .gray,
        size: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40)
    ) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(frame: size).apply {
            $0.style = style
            $0.color = color
            $0.hidesWhenStopped = true
        }

        addSubview(activityIndicator)
        activityIndicator.center()

        return activityIndicator
    }
}

// MARK: - Auto Layout

public extension UIView {
    /// Anchor all sides of the view using auto layout constraints.
    ///
    /// - Parameters:
    ///   - view: The ancestor view to pin edges to.
    ///   - insets: The inset distances for view padding.
    ///   - safeArea: Speficy to use safe area layout guide.
    func edges(to view: UIView?, insets: UIEdgeInsets = .zero, safeArea: Bool = false) {
        guard let view = view else {
            assertionFailure("Missing superview for constraint")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false

        if safeArea {
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: insets.top).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom).isActive = true
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: insets.left).isActive = true
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right).isActive = true
        } else {
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right).isActive = true
        }
    }

    /// Anchor all sides of the view using auto layout constraints.
    ///
    /// - Parameters:
    ///   - view: The ancestor view to pin edges to.
    ///   - padding: The inset distances for view padding for all sides.
    ///   - safeArea: Speficy to use safe area layout guide.
    func edges(to view: UIView?, padding: CGFloat, safeArea: Bool = false) {
        edges(to: view, insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding), safeArea: safeArea)
    }

    /// Center the view using auto layout constraints.
    func center() {
        guard let superview = superview else {
            assertionFailure("Missing superview for constraint")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }

    /// Set the aspect ratio for the height and width of the view using auto layout constraints.
    ///
    /// - Parameters:
    ///   - multiplier: The multiplier constant for the constraint.
    func aspectRatioSize(multiplier: CGFloat = 1) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier).isActive = true
    }
}
#endif
