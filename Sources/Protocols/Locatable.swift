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
    
    func updateLocation(locations: [CLLocation]?)
}

public extension Locatable {
    
    func setupLocationManager(
        desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers,
        distanceFilter: Double = 1000.0) {
            // Start requesting GPS location
            if locationManager == nil {
                locationManager = CLLocationManager(self)
            } else {
                locationManager?.tryStartUpdating()
            }
    }
    
    func updateLocation(location: CLLocation?) {
        guard let location = location else { return }
        updateLocation([location])
    }
    
    func updateLocation(latitude latitude: Double, longitude: Double) {
        updateLocation([CLLocation(latitude: latitude, longitude: longitude)])
    }
    
}