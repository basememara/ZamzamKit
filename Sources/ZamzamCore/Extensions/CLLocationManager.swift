//
//  CLLocationManager.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/18/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import CoreLocation.CLLocationManager

public extension CLAuthorizationStatus {
    /// Determines if the status is authorized for always or when in use.
    var isAuthorized: Bool {
        var statuses: [CLAuthorizationStatus] = [.authorizedAlways]

        #if os(iOS) || os(watchOS) || os(tvOS)
            statuses.append(.authorizedWhenInUse)
        #elseif os(macOS)
            statuses.append(.authorized)
        #endif

        return statuses.contains(self)
    }
}

public extension CLLocationManager {
    /// Determines if location services is enabled and authorized for always or when in use.
    ///
    /// - Warning: `locationServicesEnabled()` blocks its caller, so keep this off the main actor.
    ///   Use `authorizationStatus.isAuthorized` where only the status matters.
    var isAuthorized: Bool {
        Self.locationServicesEnabled() && authorizationStatus.isAuthorized
    }
}
