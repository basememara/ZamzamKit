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
    
    @IBInspectable dynamic open var placeholder: String = "" {
        didSet { placeholderLabel.text = placeholder }
    }
    
    @IBInspectable dynamic open var placeholderColor: UIColor = .lightGray {
        didSet { placeholderLabel.textColor = placeholderColor }
    }
    
    @IBInspectable dynamic open var placeholderFont: UIFont? {
        didSet { placeholderLabel.font ?= placeholderFont }
    }
    
    @IBInspectable open dynamic var textPaddingTop: CGFloat = 10
    @IBInspectable open dynamic var textPaddingBottom: CGFloat = 10
    @IBInspectable open dynamic var textPaddingLeft: CGFloat = 20
    @IBInspectable open dynamic var textPaddingRight: CGFloat = 20
    
    // Allow placeholders in UITextView
    private lazy var placeholderLabel = UILabel().with {
        $0.text = placeholder
        $0.textColor = placeholderColor
        $0.font ?= placeholderFont
        $0.numberOfLines = 0
    }
    
    private let notificationCenter = NotificationCenter.default
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        textContainerInset = UIEdgeInsets(
            top: textPaddingTop,
            left: textPaddingLeft,
            bottom: textPaddingBottom,
            right: textPaddingRight
        )
        
        guard !placeholder.isEmpty else { return }
        addSubview(placeholderLabel)
        
        // Set constraints
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderLabel.topAnchor
            .constraint(equalTo: topAnchor, constant: textPaddingTop)
            .isActive = true
        
        placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: textPaddingBottom).with {
            $0.priority = .defaultLow
            $0.isActive = true
        }
        
        let cursorSpacing: CGFloat = 4
        
        placeholderLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: textPaddingLeft + cursorSpacing)
            .isActive = true
        
        placeholderLabel.widthAnchor
            .constraint(equalTo: widthAnchor, constant: -(textPaddingLeft + textPaddingRight) - cursorSpacing)
            .isActive = true
        
        notificationCenter.addObserver(self, selector: #selector(textDidBeginEditing), name: UITextView.textDidBeginEditingNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(textDidEndEditing), name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    open override var text: String! {
        get { return super.text }
        set {
            super.text = newValue
            
            // Since observer does not fire when manually set
            placeholderDidChange(placeholderLabel)
        }
    }
    
    @objc open func textDidBeginEditing(_ notification: Notification) {
        guard notification.object as? UITextView == self else { return }
        placeholderDidChange(placeholderLabel)
    }
    
    @objc open func textDidChange(_ notification: Notification) {
        guard notification.object as? UITextView == self else { return }
        placeholderDidChange(placeholderLabel)
    }
    
    @objc open func textDidEndEditing(_ notification: Notification) {
        guard notification.object as? UITextView == self else { return }
        placeholderDidChange(placeholderLabel)
    }
    
    open func placeholderDidChange(_ sender: UILabel) {
        placeholderLabel.isHidden = !text.isEmpty
    }
}

