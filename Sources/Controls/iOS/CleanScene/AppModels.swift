//
//  AppModels.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-02-04.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

/// App model continer for implementing global models.
public enum AppModels {
    
    public struct Error {
        public let title: String
        public let message: String?
        
        public init(title: String, message: String? = nil) {
            self.title = title
            self.message = message
        }
    }
}
