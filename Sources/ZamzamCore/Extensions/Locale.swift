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
    /// The name of the locale's language, written in that language, or `nil` when the locale has no language code.
    var languageName: String? {
        guard let code = language.languageCode?.identifier else { return nil }
        return localizedString(forLanguageCode: code)
    }
}
