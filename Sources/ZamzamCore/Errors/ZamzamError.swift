//
//  ZamzamError.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/6/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

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
