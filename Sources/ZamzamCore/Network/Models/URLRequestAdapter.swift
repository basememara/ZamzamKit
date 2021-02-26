//
//  URLRequestAdapter.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-06-15.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLRequest

/// A type that can inspect and optionally adapt a `URLRequest` in some manner if necessary.
public protocol URLRequestAdapter {
    /// Inspects and adapts the specified `URLRequest` in some manner and returns the new request.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to adapt.
    func adapt(_ request: URLRequest) -> URLRequest
}
