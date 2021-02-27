//
//  Locale.swift
//  ZamzamCore
//
//  Created by Basem Emara on 4/10/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation.NSLocale

public extension Locale {
    /// Unix representation of locale usually used for normalizing.
    static let posix = Locale(identifier: "en_US_POSIX")
}

public extension Locale {
    /// Returns the language name of the locale, or nil if has none.
    var languageName: String? {
        guard let code = languageCode else { return nil }
        return localizedString(forLanguageCode: code)
    }

    /// Returns the character direction for the current language code.
    var characterDirection: LanguageDirection {
        guard let code = languageCode else { return .unknown }
        return Self.characterDirection(forLanguage: code)
    }
}
