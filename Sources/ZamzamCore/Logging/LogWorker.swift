//
//  Logger.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-06-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

public struct LogWorker: LogWorkerType {
    private let stores: [LogStore]
    
    public init(stores: [LogStore]) {
        self.stores = stores
    }
}

public extension LogWorker {
    
    func verbose(_ message: String, path: String, function: String, line: Int, context: [String: Any]?) {
        stores.forEach { $0.verbose(message, path: path, function: function, line: line, context: context) }
    }
    
    func debug(_ message: String, path: String, function: String, line: Int, context: [String: Any]?) {
        stores.forEach { $0.debug(message, path: path, function: function, line: line, context: context) }
    }
    
    func info(_ message: String, path: String, function: String, line: Int, context: [String: Any]?) {
        stores.forEach { $0.info(message, path: path, function: function, line: line, context: context) }
    }
    
    func warning(_ message: String, path: String, function: String, line: Int, context: [String: Any]?) {
        stores.forEach { $0.warning(message, path: path, function: function, line: line, context: context) }
    }
    
    func error(_ message: String, path: String, function: String, line: Int, context: [String: Any]?) {
        stores.forEach { $0.error(message, path: path, function: function, line: line, context: context) }
    }
}
