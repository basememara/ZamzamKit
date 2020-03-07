//
//  ZamzamError.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/6/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation

public enum ZamzamError: Error {
    case general
    case invalidData
    case nonExistent
    case duplicate
    case unauthorized
    case notReachable
    case noInternet
    case timeout
    case parseFailure(Error?)
    case cacheFailure(Error?)
    case serverFailure(Error?)
    case other(Error?)
}

// MARK: - Helpers

public extension ZamzamError {
    
    init(from error: NetworkError?) {
        // Handle no internet
        if let internalError = error?.internalError as? URLError,
            internalError.code  == .notConnectedToInternet {
            self = .noInternet
            return
        }
        
        // Handle timeout
        if let internalError = error?.internalError as? URLError,
            internalError.code  == .timedOut {
            self = .timeout
            return
        }
        
        // Handle by status code
        switch error?.statusCode {
        case 400:
            self = .invalidData
        case 401, 403:
            self = .unauthorized
        default:
            self = .other(error)
        }
    }
}
