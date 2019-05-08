//
//  Result.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2019-05-08.
//  Copyright © 2019 Zamzam. All rights reserved.
//

public extension Result {
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    var error: Failure? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
