//
//  ViewError.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2019-12-17.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

/// Model container for global view errors.
public struct ViewError: Equatable, Error {
    public let title: String?
    public let message: String?
    
    public init(title: String?, message: String? = nil) {
        self.title = title
        self.message = message
    }
}
