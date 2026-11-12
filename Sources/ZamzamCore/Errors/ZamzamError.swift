//
//  ZamzamError.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/6/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

/// A general set of errors for an app to map its failures onto.
public enum ZamzamError: Error {
    /// A failure with no more specific case.
    case general
    /// The input can't be used, such as a repeating notification interval under a minute.
    case invalidData
    /// The item asked for doesn't exist.
    case nonExistent
    /// The item already exists.
    case duplicate
    /// The caller isn't allowed, such as an HTTP status of 401 or 403.
    case unauthorized
    /// The device is offline.
    case noInternet
    /// The operation ran out of time.
    case timeout
    /// Decoding or parsing failed, with the underlying error.
    case parseFailure(Error?)
    /// A local store failed, with the underlying error.
    case cacheFailure(Error?)
    /// The server refused the request, such as an HTTP status of 400, with the underlying error.
    case requestFailure(Error?)
    /// The server or the connection failed, with the underlying error.
    case serverFailure(Error?)
    /// A secure connection couldn't be made, with the underlying error.
    case secureFailure(Error?)
    /// Any other failure, with the underlying error.
    case other(Error?)
}
