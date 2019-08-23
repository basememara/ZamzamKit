//
//  Bundle.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2019-08-22.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

public extension Bundle {
    private class TempClassForBundle {}
    
    /// A representation of the code and resources stored in ZamzamCore bundle directory on disk.
    static let zamzamKit = Bundle(for: TempClassForBundle.self)
}
