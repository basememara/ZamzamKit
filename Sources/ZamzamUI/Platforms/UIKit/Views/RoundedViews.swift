//
//  RoundedViews.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2018-06-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/// A circular `UIView`.
open class RoundedView: UIView {

    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}

/// A circular `UIButton`.
open class RoundedButton: UIButton {

    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}

/// A circular `UIImageView`.
open class RoundedImageView: UIImageView {

    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.height / 2
    }
}
#endif
