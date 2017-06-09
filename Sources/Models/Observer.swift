//
//  Observable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/12/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

/// Type for creating observable properties
public struct Observer<T> {
    public let id: String
    public let handler: T
    
    public init(id: String, handler: T) {
        self.id = id
        self.handler = handler
    }
    
    public init(file: String = #file, line: Int = #line, handler: T) {
        self.init(id: "\(file).\(line)", handler: handler)
    }
}

extension Observer: Equatable {
     public static func ==(lhs: Observer, rhs: Observer) -> Bool {
        return lhs.id == rhs.id
    }
}
