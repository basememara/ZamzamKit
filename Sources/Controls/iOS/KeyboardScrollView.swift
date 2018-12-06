//
//  KeyboardScrollView.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-11-14.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

/// A `UIScrollView` that extends the insets when the keyboard is shown.
open class KeyboardScrollView: UIScrollView {
    private let notificationCenter: NotificationCenter = .default
    
    open var activeField: UIView?
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss keyboard when tapped out of textfield
        endEditing(true)
    }
}

extension KeyboardScrollView {
    
    /// Adjusts layout to prevent keyboard overlaying UI elements
    @IBInspectable open var automaticallyAdjustsInsetsForKeyboard: Bool {
        get { return false /* Not stored */ }
        set {
            guard newValue else { return }
            notificationCenter.addObserver(for: UIResponder.keyboardWillShowNotification, selector: #selector(adjustsInsetsForKeyboard), from: self)
            notificationCenter.addObserver(for: UIResponder.keyboardWillHideNotification, selector: #selector(adjustsInsetsForKeyboard), from: self)
        }
    }
    
    @objc private func adjustsInsetsForKeyboard(_ notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        
        let keyboardHeight = notification.name == UIResponder.keyboardWillShowNotification
            ? keyboardFrame.cgRectValue.size.height : 0
        
        contentInset.bottom = keyboardHeight
        scrollIndicatorInsets.bottom = keyboardHeight
        
        // Scroll to active text field if it is hidden by keyboard
        // https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html#//apple_ref/doc/uid/TP40009542-CH5-SW7
        guard notification.name == UIResponder.keyboardWillShowNotification else { return }
        scrollToActiveField()
    }
    
    open func scrollToActiveField() {
        guard let activeField = activeField else { return }
        let rect = activeField.convert(activeField.bounds, to: self)
        scrollRectToVisible(rect, animated: true)
    }
}
