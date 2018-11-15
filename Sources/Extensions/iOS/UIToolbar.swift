//
//  UIToolbar.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-11-14.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

public extension UIToolbar {
    
    static func makeInputDoneToolbar(target: Any?, action: Selector) -> UIToolbar {
        return UIToolbar().with {
            $0.barStyle = .default
            $0.isTranslucent = true
            $0.isUserInteractionEnabled = true
            $0.sizeToFit()
            $0.setItems([
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(barButtonSystemItem: .done, target: target, action: action)
            ], animated: false)
        }
    }
    
    static func makeInputNextToolbar(target: Any?, action: Selector) -> UIToolbar {
        return UIToolbar().with {
            $0.barStyle = .default
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
            
            $0.setItems([
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                nextButton
            ], animated: false)
        }
    }
}
