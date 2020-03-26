//
//  File.swift
//  
//
//  Created by Basem Emara on 2020-03-26.
//

import Foundation.NSURLError

public extension ZamzamError {
    
    init(from error: NetworkAPI.Error?) {
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
