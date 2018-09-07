//
//  ZamzamError.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/6/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

public enum ZamzamError: Error {
    case general
    case invalidData
    case nonExistent
    case notReachable
    case unauthorized
    case other(Error?)
}
