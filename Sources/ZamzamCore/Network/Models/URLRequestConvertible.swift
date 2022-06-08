//
//  URLRequestConvertible.swift
//  FCSECore
//
//  Created by Basem Emara on 2022-06-08.
//  Copyright © 2022 Fan Controlled Sports & Entertainment, Inc. All rights reserved.
//

import Foundation.NSURLRequest

/// Types adopting the `URLRequestConvertible` protocol can be used to construct a `URLRequest` object.
public protocol URLRequestConvertible {
    /// Returns a `URLRequest`.
    func asURLRequest() -> URLRequest
}
