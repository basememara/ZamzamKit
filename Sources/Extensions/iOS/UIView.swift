//
//  UIView.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/25/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit

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
        get { return !isHidden }
        set { isHidden = !newValue }
    }
    
    /// Returns the width of the frame.
    var width: CGFloat {
        get { return frame.width }
        set { frame.size.width = newValue }
    }

    /// Returns the height of the frame.
    var height: CGFloat {
        get { return frame.height }
        set { frame.size.height = newValue }
    }
	
	/// Get view's parent view controller
	var parentViewController: UIViewController? {
        // https://github.com/SwifterSwift
		weak var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		return nil
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
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    /// Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
	
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
        opacity: Float = 0.5)
    {
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
    ///   - duration: animation duration in seconds (default is 0.35 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeIn(duration: TimeInterval = 0.25, completion: ((Bool) -> Void)? = nil) {
        guard isHidden || alpha < 1 else { completion?(true); return }
        
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
    ///   - duration: animation duration in seconds (default is 0.35 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeOut(duration: TimeInterval = 0.25, completion: ((Bool) -> Void)? = nil) {
        guard !isHidden || alpha > 0 else { completion?(true); return }
        
        let originalAlpha = alpha
        
        UIView.animate(
            withDuration: duration,
            animations: {
                self.alpha = 0
            },
            completion:  {
                self.isHidden = true
                self.alpha = originalAlpha
                completion?($0)
            }
        )
    }
}

public extension UIView {

    /// Returns the user interface direction.
    var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        return UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
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
        size: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40)) -> UIActivityIndicatorView
    {
        let activityIndicator = UIActivityIndicatorView(frame: size).with {
            $0.style = style
            $0.color = color
            $0.hidesWhenStopped = true
            $0.center = center
        }
        
        addSubview(activityIndicator)
        
        return activityIndicator
    }
}

public extension UIView {
    
    /// Anchor all sides of the view using auto layout constraints.
    ///
    /// - Parameter view: The ancestor view to pin edges to.
    func edges(to view: UIView?) {
        guard let view = view else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
