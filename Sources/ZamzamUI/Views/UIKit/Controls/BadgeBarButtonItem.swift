//
//  BadgeBarButtonItem.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2018-01-30.
//  https://gist.github.com/yonat/75a0f432d791165b1fd6
//
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit
import ZamzamCore

/// A bar button item with an optional badge value.
open class BadgeBarButtonItem: UIBarButtonItem {
    
    private(set) public lazy var badgeLabel = UILabel().apply {
        $0.text = badgeText?.isEmpty == false ? " \(badgeText ?? "") " : nil
        $0.isHidden = badgeText?.isEmpty != false
        $0.textColor = badgeFontColor
        $0.backgroundColor = badgeBackgroundColor
        
        $0.font = .systemFont(ofSize: badgeFontSize)
        $0.layer.cornerRadius = badgeFontSize * CGFloat(0.6)
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addConstraint(
            NSLayoutConstraint(
                item: $0,
                attribute: .width,
                relatedBy: .greaterThanOrEqual,
                toItem: $0,
                attribute: .height,
                multiplier: 1,
                constant: 0
            )
        )
    }
    
    open var badgeButton: UIButton? { customView as? UIButton }
    
    open var badgeText: String? {
        didSet {
            badgeLabel.text = badgeText?.isEmpty == false ? " \(badgeText ?? "") " : nil
            badgeLabel.isHidden = badgeText?.isEmpty != false
            badgeLabel.sizeToFit()
        }
    }
    
    open var badgeBackgroundColor: UIColor = .red {
        didSet { badgeLabel.backgroundColor = badgeBackgroundColor }
    }
    
    open var badgeFontColor: UIColor = .white {
        didSet { badgeLabel.textColor = badgeFontColor }
    }
    
    open var badgeFontSize: CGFloat = UIFont.smallSystemFontSize {
        didSet {
            badgeLabel.font = .systemFont(ofSize: badgeFontSize)
            badgeLabel.layer.cornerRadius = badgeFontSize * CGFloat(0.6)
            badgeLabel.sizeToFit()
        }
    }
}

public extension BadgeBarButtonItem {
    
    convenience init(button: UIButton, badgeText: String? = nil, target: AnyObject?, action: Selector) {
        self.init(customView: button)
        
        self.badgeText = badgeText
        
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        button.addSubview(badgeLabel)
        
        badgeLabel.addGestureRecognizer(
            UITapGestureRecognizer(target: target, action: action)
        )
        
        button.addConstraint(
            NSLayoutConstraint(
                item: badgeLabel,
                attribute: button.currentTitle?.isEmpty == false ? .top : .centerY,
                relatedBy: .equal,
                toItem: button,
                attribute: .top,
                multiplier: 1,
                constant: 0
            )
        )
        
        button.addConstraint(
            NSLayoutConstraint(
                item: badgeLabel,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: button,
                attribute: .trailing,
                multiplier: 1,
                constant: 0
            )
        )
    }
}

public extension BadgeBarButtonItem {
    
    convenience init(image: UIImage?, badgeText: String? = nil, target: AnyObject?, action: Selector) {
        let button = UIButton(type: .custom).apply {
            $0.frame = CGRect(x: 0, y: 0, width: image?.size.width ?? 40, height: image?.size.height ?? 40)
            $0.setBackgroundImage(image, for: .normal)
        }
        
        self.init(button: button, badgeText: badgeText, target: target, action: action)
    }
    
    convenience init(title: String, badgeText: String? = nil, target: AnyObject?, action: Selector) {
        let button = UIButton(type: .system).apply {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        }
        
        self.init(button: button, badgeText: badgeText, target: target, action: action)
    }
    
    convenience init?(image: String, badgeText: String? = nil, target: AnyObject?, action: Selector) {
        guard let image = UIImage(named: image) else { return nil }
        self.init(image: image, badgeText: badgeText, target: target, action: action)
    }
}
#endif
