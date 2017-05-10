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
    let id: String
    let handler: T
    
    public init(id: String, handler: T) {
        self.id = id
        self.handler = handler
    }
    
    public init(file: String = #file, function: String = #function, handler: T) {
        self.init(id: "\(file).\(function)", handler: handler)
    }
}

extension Observer: Equatable {
     public static func ==(lhs: Observer, rhs: Observer) -> Bool {
        return lhs.id == rhs.id
    }
}
