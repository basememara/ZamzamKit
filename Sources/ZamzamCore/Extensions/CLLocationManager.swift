//
//  CLLocationManager.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/18/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import CoreLocation.CLLocationManager

public extension CLLocationManager {
    
    /// Determines if location services is enabled and authorized for always or when in use.
    static var isAuthorized: Bool {
        var statuses: [CLAuthorizationStatus] = [.authorizedAlways]
        
        #if os(iOS) || os(watchOS) || os(tvOS)
            statuses.append(.authorizedWhenInUse)
        #elseif os(macOS)
            statuses.append(.authorized)
        #endif
        
        return Self.locationServicesEnabled()
            && Self.authorizationStatus().within(statuses)
    }
}
