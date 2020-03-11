//
//  LogProvider.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-06-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

public struct LogProvider: LogProviderType {
    private let stores: [LogStore]
    
    public init(stores: [LogStore]) {
        self.stores = stores
    }
}

public extension LogProvider {
    
    func write(_ level: LogAPI.Level, with message: String, path: String, function: String, line: Int, error: Error?, context: [String: CustomStringConvertible]?, completion: (() -> Void)?) {
        let destinations = stores.filter { $0.canWrite(for: level) }
        
        // Skip if does not meet minimum log level
        guard !destinations.isEmpty else {
            completion?()
            return
        }
        
        DispatchQueue.logger.async {
            destinations.forEach {
                $0.write(level, with: message, path: path, function: function, line: line, error: error, context: context)
            }
            
            completion?()
        }
    }
}
