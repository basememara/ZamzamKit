//
//  Result.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/6/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

/**
    Used to represent whether a request was successful or encountered an error.
    Stolen from Alamofire: https://github.com/Alamofire/Alamofire/blob/master/Source/Result.swift
    - Success: The request and all processing operations were successful resulting in the handling of the
               provided associated value.
    - Failure: The request encountered an error resulting in a failure. The associated values are the original data 
               provided by the destination as well as the error that caused the failure.
*/
public enum Result<Value> {
    case success(Value)
    case failure(Error)

    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }

    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
