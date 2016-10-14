//
//  ViewControllerLocatable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/9/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import CoreLocation

public protocol Locatable: CLLocationManagerDelegate {
    var locationManager: CLLocationManager? { get set }
    
    func updateLocation(_ locations: [CLLocation]?)
}

public extension Locatable {
    
    func setupLocationManager(
        _ desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers,
        distanceFilter: Double = 1000.0,
        monitorSignificantLocationChanges: Bool = false,
        allowsBackgroundLocationUpdates: Bool = false) {
            // Start requesting GPS location
            if locationManager == nil {
                locationManager = CLLocationManager(self,
                    monitorSignificantLocationChanges: monitorSignificantLocationChanges
                        || allowsBackgroundLocationUpdates)
            } else {
                _ = locationManager?.tryStartUpdating(
                    monitorSignificantLocationChanges: monitorSignificantLocationChanges
                        || allowsBackgroundLocationUpdates)
            }
                
            #if os(iOS)
                locationManager?.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
            #endif
    }
    
    func updateLocation(_ location: CLLocation?) {
        guard let location = location else { return }
        updateLocation([location])
    }
    
    func updateLocation(latitude: Double, longitude: Double) {
        updateLocation([CLLocation(latitude: latitude, longitude: longitude)])
    }
    
}
