//
//  ScrollViewWithKeyboard.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2019-05-08.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamCore

open class ScrollViewWithKeyboard: UIScrollView {
    private lazy var notificationCenter: NotificationCenter = .default
    public var activeField: UIView?
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // https://stackoverflow.com/a/8203326
        guard window != nil else { return }
        notificationCenter.addObserver(for: UIResponder.keyboardWillShowNotification, selector: #selector(adjustsInsetsForKeyboard), from: self)
        notificationCenter.addObserver(for: UIResponder.keyboardWillHideNotification, selector: #selector(adjustsInsetsForKeyboard), from: self)
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        guard newWindow == nil else { return }
        notificationCenter.removeObserver(for: UIResponder.keyboardWillShowNotification, from: self)
        notificationCenter.removeObserver(for: UIResponder.keyboardWillHideNotification, from: self)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss keyboard when tapped out of textfield
        endEditing(true)
    }
}

public extension ScrollViewWithKeyboard {
    
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
    
    func scrollToActiveField() {
        guard let activeField = activeField else { return }
        let rect = activeField.convert(activeField.bounds, to: self)
        scrollRectToVisible(rect, animated: true)
    }
}
