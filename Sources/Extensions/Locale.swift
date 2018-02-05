//
//  Locale.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/10/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

public extension Locale {

    /// Unix representation of locale usually used for normalizing.
    static var posix: Locale = {
        Locale(identifier: "en_US_POSIX")
    }()
    
    /// Returns the language name of the locale, or nil if has none.
    var languageName: String? {
        guard let code = languageCode else { return nil }
        return localizedString(forLanguageCode: code)
    }
    
    /// Returns the character direction for the current language code.
    var characterDirection: LanguageDirection {
        guard let code = languageCode else { return .unknown }
        return Locale.characterDirection(forLanguage: code)
    }
}
