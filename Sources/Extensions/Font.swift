//
//  Font.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2017-11-20.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

public extension UIFont {
    
    /// Specify font trait while leaving size intact.
    func with(traits: UIFontDescriptorSymbolicTraits...) -> UIFont {
        // https://stackoverflow.com/a/39999497/235334
        let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
}
