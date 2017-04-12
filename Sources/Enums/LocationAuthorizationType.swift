//
//  LocationAuthorizationType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/12/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

/// Permission types to use location services.
///
/// - whenInUse: While the app is in the foreground.
/// - always: Whenever the app is running.
public enum LocationAuthorizationType {
    case whenInUse, always
}
