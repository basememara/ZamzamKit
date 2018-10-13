//
//  Localizable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 6/27/17.
//  http://basememara.com/swifty-localization-xcode-support/
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

/// Collection of static keys used for localization.
public struct Localizable {
    fileprivate let rawValue: String
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension Localizable {
    static let pullToRefresh = Localizable(NSLocalizedString("pull.to.refresh", bundle: .zamzamKit, comment: "For tables"))
    static let openInSafari = Localizable(NSLocalizedString("open.in.safari", bundle: .zamzamKit, comment: "For opening Safari from share activity"))
    static let ok = Localizable(NSLocalizedString("ok.dialog", bundle: .zamzamKit, comment: "For dialogs"))
    static let cancel = Localizable(NSLocalizedString("cancel.dialog", bundle: .zamzamKit, comment: "For dialogs"))
}

public extension String {
    
    /// A string initialized by using format as a template into which values in argList are substituted according the current locale information.
    private static var vaListHandler: (_ key: String, _ arguments: CVaListPointer, _ locale: Locale?) -> String {
        // https://stackoverflow.com/questions/42428504/swift-3-issue-with-cvararg-being-passed-multiple-times
        return { return NSString(format: $0, locale: $2, arguments: $1) as String }
    }

    /// Returns a localized string.
    static func localized(_ key: Localizable) -> String {
        return key.rawValue
    }

    /// Returns a string created by using a given format string as a template into which the remaining argument values are substituted.
    static func localizedFormat(_ key: Localizable, _ arguments: CVarArg...) -> String {
        return withVaList(arguments) { vaListHandler(key.rawValue, $0, nil) } as String
    }

    /// Returns a string created by using a given format string as a template into which the
    /// remaining argument values are substituted according to the user’s default locale.
    static func localizedLocale(_ key: Localizable, _ arguments: CVarArg...) -> String {
        return withVaList(arguments) { vaListHandler(key.rawValue, $0, .current) } as String
    }
}
