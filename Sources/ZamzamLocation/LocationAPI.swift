//
//  LocationAPI.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2019-08-25.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

/// Namespaec for location
public enum LocationAPI {}

public extension LocationAPI {
    
    /// Permission types to use location services.
    ///
    /// - whenInUse: While the app is in the foreground.
    /// - always: Whenever the app is running.
    enum AuthorizationType {
        case whenInUse, always
    }
}
