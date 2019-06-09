//
//  CLLocationManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/18/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation
import CoreLocation

public extension CLLocationManager {
    
    /// Determines if location services is enabled and authorized for always or when in use.
    static var isAuthorized: Bool {
        return CLLocationManager.locationServicesEnabled()
            && CLLocationManager.authorizationStatus()
                .within([.authorizedAlways, .authorizedWhenInUse])
    }
}
