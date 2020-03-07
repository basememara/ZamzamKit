//
//  NextResponderTextField.swift
//  ZamzamUI
//
//  Created by mohamede1945, @author mohamede1945 on 6/20/15.
//  https://github.com/mohamede1945/NextResponderTextField
//  https://stackoverflow.com/a/5889795
//
//  Copyright (c) 2015 Varaw. All rights reserved.
//

#if os(iOS)
import UIKit

/**
 Represents a next responder `UITextField`.
 
 When the instance becomes first responder, and then the user taps the action button (e.g. return keyboard key)
 then one of the following happens:
 1. If `nextResponderField` is not set, keyboard dismissed.
 2. If `nextResponderField` is a `UIButton` and disabled, then keyboard dismissed.
 3. If `nextResponderField` is a `UIButton` and enabled, then the `UIButton` fires touch up inside event (simulating a tap).
 4. If `nextResponderField` is another implementation of `UIResponder` (e.g. other text field), then it becomes the first responder (e.g. receives keyboard input).
 */
@objc open class NextResponderTextField: UITextField {
    //swiftlint:disable private_outlet
    
    /// Represents the next field. It can be any responder.
    /// If it is UIButton and enabled then the button will be tapped.
    /// If it is UIButton and disabled then the keyboard will be dismissed.
    /// If it is another implementation, it becomes first responder.
    @IBOutlet open weak var nextResponderField: UIResponder?
    
    /**
     Creates a new view with the passed coder.
     
     :param: aDecoder The a decoder
     
     :returns: the created new view.
     */
    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    /**
     Creates a new view with the passed frame.
     
     :param: frame The frame
     
     :returns: the created new view.
     */
    @objc override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    /**
     Sets up the view.
     */
    private func configure() {
        addTarget(self, action: #selector(actionKeyboardButtonTapped(sender:)), for: .editingDidEndOnExit)
    }
    
    /**
     Action keyboard button tapped.
     
     :param: sender The sender of the action parameter.
     */
    @objc private func actionKeyboardButtonTapped(sender: UITextField) {
        switch nextResponderField {
        case let button as UIButton where button.isEnabled:
            button.sendActions(for: .touchUpInside)
        case .some(let responder):
            responder.becomeFirstResponder()
        default:
            resignFirstResponder()
        }
    }
}
#endif
