//
//  URLRequestConvertible.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2022-06-08.
//  Copyright © 2022 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLRequest

/// Types adopting the `URLRequestConvertible` protocol can be used to construct a `URLRequest` object.
public protocol URLRequestConvertible: Sendable {
    /// Returns a `URLRequest`.
    func asURLRequest() -> URLRequest
}
