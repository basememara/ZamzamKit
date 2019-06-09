//
//  UIToolbar.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-11-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

public extension UIToolbar {
    
    /// Create an instance of a `UIToolbar` with a `Done` button that performs the action.
    ///
    ///     class ViewController: UIViewController {
    ///
    ///         private lazy var inputDoneToolbar: UIToolbar = .makeInputDoneToolbar(
    ///             target: self,
    ///             action: #selector(endEditing)
    ///         )
    ///     }
    ///
    ///     extension ViewController: UITextViewDelegate {
    ///
    ///         func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    ///             textView.inputAccessoryView = inputDoneToolbar
    ///             return true
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - target: The object that receives the action message.
    ///   - action: The action to send to target when this item is selected.
    ///   - clearAction: The action to send to target when this item is cleared.
    /// - Returns: A control that displays the done button along the bottom edge of your interface.
    static func makeInputDoneToolbar(target: Any?, action: Selector, clearAction: Selector? = nil) -> UIToolbar {
        return UIToolbar().with {
            $0.isTranslucent = true
            $0.isUserInteractionEnabled = true
            $0.sizeToFit()
            
            var items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(barButtonSystemItem: .done, target: target, action: action)
            ]
            
            if let clearAction = clearAction {
                let clearButton = UIBarButtonItem(
                    title: .localized(.clear),
                    style: .plain,
                    target: target,
                    action: clearAction
                )
                
                clearButton.setTitleTextAttributes([
                    .font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
                ], for: .normal)
                
                items.insert(clearButton, at: 0)
            }
            
            $0.setItems(items, animated: false)
        }
    }
    
    /// Create an instance of a `UIToolbar` with a `Next` button that performs the action.
    ///
    /// - Parameters:
    ///   - target: The object that receives the action message.
    ///   - action: The action to send to target when this item is selected.
    ///   - clearAction: The action to send to target when this item is cleared.
    /// - Returns: A control that displays the next button along the bottom edge of your interface.
    static func makeInputNextToolbar(target: Any?, action: Selector, clearAction: Selector? = nil) -> UIToolbar {
        return UIToolbar().with {
            $0.isTranslucent = true
            $0.isUserInteractionEnabled = true
            $0.sizeToFit()
            
            let nextButton = UIBarButtonItem(
                title: .localized(.next),
                style: .plain,
                target: target,
                action: action
            )
            
            nextButton.setTitleTextAttributes([
                .font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
            ], for: .normal)
            
            var items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                nextButton
            ]
            
            if let clearAction = clearAction {
                let clearButton = UIBarButtonItem(
                    title: .localized(.clear),
                    style: .plain,
                    target: target,
                    action: clearAction
                )
                
                clearButton.setTitleTextAttributes([
                    .font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
                ], for: .normal)
                
                items.insert(clearButton, at: 0)
            }
            
            $0.setItems(items, animated: false)
        }
    }
}
