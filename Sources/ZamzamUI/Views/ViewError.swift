//
//  ViewError.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2019-12-17.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSUUID
import ZamzamCore

/// Model container for global view errors.
public struct ViewError: Error, Equatable, Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let action: ViewAction?
    
    public init(
        title: String,
        message: String? = nil,
        action: ViewAction? = nil
    ) {
        self.title = title
        self.message = message
        self.action = action
    }
}
