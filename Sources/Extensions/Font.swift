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
    ///
    ///     textLabel?.font = textLabel?.font.with(traits: [.traitBold])
    func with(traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits)) else {
            return self
        }
        
        // https://stackoverflow.com/a/39999497/235334
        return UIFont(descriptor: descriptor, size: 0)
    }
}
