//
//  SequenceType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/20/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation

public extension Sequence {

    /// Converts collection of objects to JSON string
    var jsonString: String? {
        guard let data = self as? [[String: Any]],
            let stringData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
                return nil
        }
        
        return String(data: stringData, encoding: .utf8)
    }
}
