//
//  Localizable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 6/27/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public extension Localizable {
    static let pullToRefresh = Localizable(NSLocalizedString("pull.to.refresh", bundle: bundle(forKey: "pull.to.refresh"), comment: "For tables"))
    static let openInSafari = Localizable(NSLocalizedString("open.in.safari", bundle: bundle(forKey: "open.in.safari"), comment: "For opening Safari from share activity"))
    static let ok = Localizable(NSLocalizedString("ok.dialog", bundle: bundle(forKey: "ok.dialog"), comment: "OK text for dialogs"))
    static let cancel = Localizable(NSLocalizedString("cancel.dialog", bundle: bundle(forKey: "cancel.dialog"), comment: "Cancel text for dialogs"))
    static let next = Localizable(NSLocalizedString("next.dialog", bundle: bundle(forKey: "next.dialog"), comment: "Next text for dialogs"))
    static let clear = Localizable(NSLocalizedString("clear.dialog", bundle: bundle(forKey: "clear.dialog"), comment: "Clear text for dialogs"))
    static let camera = Localizable(NSLocalizedString("camera.dialog", bundle: bundle(forKey: "camera.dialog"), comment: "Camera text for dialogs"))
    static let photos = Localizable(NSLocalizedString("photos.dialog", bundle: bundle(forKey: "photos.dialog"), comment: "Photos text for dialogs"))
    static let genericErrorTitle = Localizable(NSLocalizedString("generic.error.title", bundle: bundle(forKey: "generic.error.title"), comment: "General error title for unknown reason"))
}

public extension Localizable {
        
    // Retrive localization from main bundle if overriden, or use current bundle
    static func bundle(forKey key: String) -> Bundle {
        return Bundle.main.localizedString(forKey: key, value: nil, table: nil) == key ? .zamzamCore : .main
    }
}
