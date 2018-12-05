//
//  PlaceholderTextView.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-07-11.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

/// A `UITextView` with a placeholder text.
open class PlaceholderTextView: UITextView {
    
    @IBInspectable open var placeholder: String = "" {
        didSet { placeholderLabel.text = placeholder }
    }
    
    @IBInspectable open var placeholderColor: UIColor = .lightGray {
        didSet { placeholderLabel.textColor = placeholderColor }
    }
    
    // Allow placeholders in UITextView
    private lazy var placeholderLabel: UILabel = {
        UILabel().with {
            $0.text = placeholder
            $0.numberOfLines = 0
            $0.font = font
            $0.textColor = placeholderColor
        }
    }()
    
    private let notificationCenter = NotificationCenter.default
    private let padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        textContainerInset = padding
        
        guard !placeholder.isEmpty else { return }
        addSubview(placeholderLabel)
        
        // Set constraints
        // https://useyourloaf.com/blog/pain-free-constraints-with-layout-anchors/
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding.top).isActive = true
        placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: padding.bottom).isActive = true
        placeholderLabel.widthAnchor.constraint(
            equalTo: widthAnchor,
            constant: -(padding.left + padding.right)
        ).isActive = true
        placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        notificationCenter.addObserver(self, selector: #selector(didBeginEditing), name: UITextView.textDidBeginEditingNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didChangeText), name: UITextView.textDidChangeNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didEndEditing), name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    open override var text: String! {
        get { return super.text }
        set {
            super.text = newValue
            
            // Since observer does not fire when manually set
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}

private extension PlaceholderTextView {
    
    @objc func didBeginEditing(_ notification: Notification) {
        guard notification.object as? UITextView == self else { return }
        placeholderLabel.isHidden = true
    }
    
    @objc func didChangeText(_ notification: Notification) {
        guard notification.object as? UITextView == self else { return }
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    @objc func didEndEditing(_ notification: Notification) {
        guard notification.object as? UITextView == self else { return }
        placeholderLabel.isHidden = !text.isEmpty
    }
}
