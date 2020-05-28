//
//  ViewError.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2019-12-17.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

/// Model container for global view errors.
public struct ViewError: Equatable {
    public let title: String?
    public let message: String?
    
    public init(title: String?, message: String? = nil) {
        self.title = title
        self.message = message
    }
}

#if canImport(SwiftUI)
import Foundation.NSBundle
import SwiftUI

/// Model container for global view errors.
@available(iOS 13, *)
public struct ViewErrorKey: Equatable {
    public let title: LocalizedStringKey
    public let message: LocalizedStringKey?
    public let bundle: Bundle?
    
    public init(
        title: LocalizedStringKey,
        message: LocalizedStringKey? = nil,
        bundle: Bundle? = nil
    ) {
        self.title = title
        self.message = message
        self.bundle = bundle
    }
}
#endif
