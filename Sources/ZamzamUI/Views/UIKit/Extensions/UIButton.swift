//
//  UIButton.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2019-05-22.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIButton {
    
    /// The color of the title font with UIAppearance support.
    @objc dynamic var titleFont: UIFont? {
        // UIAppearance: https://stackoverflow.com/a/42410383
        get { return titleLabel?.font }
        set { titleLabel?.font = newValue }
    }
}
#endif
