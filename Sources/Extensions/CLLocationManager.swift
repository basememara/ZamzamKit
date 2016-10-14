//
//  CLLocationManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/18/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import CoreLocation

public extension CLLocationManager {
    
    public convenience init(_ delegate: CLLocationManagerDelegate,
        desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers,
        distanceFilter: Double = 1000.0,
        forceInitialRequest: Bool = false,
        monitorSignificantLocationChanges: Bool = false) {
        self.init()
        
        self.delegate = delegate
        self.desiredAccuracy = desiredAccuracy
        self.distanceFilter = distanceFilter
        _ = self.tryStartUpdating(forceInitialRequest,
            monitorSignificantLocationChanges: monitorSignificantLocationChanges)
    }
    
    /**
     Cross-platform method for updating location
     Calls startUpdatingLocation for iOS
     Calls requestLocation for watchOS
     */
    public func tryStartUpdating(_ forceInitialRequest: Bool = false,
        monitorSignificantLocationChanges: Bool = false) -> Bool {
            if CLLocationManager.isAuthorized() {
                #if os(iOS)
                    if forceInitialRequest {
                        if #available(iOS 9.0, *) {
                            requestLocation()
                        }
                    }
                    
                    if monitorSignificantLocationChanges {
                        startMonitoringSignificantLocationChanges()
                    } else {
                        startUpdatingLocation()
                    }
                #elseif os(watchOS)
                    requestLocation()
                #endif
                
                return true
            }
            
            return false
    }
    
    public static func isAuthorized() -> Bool {
        // Globally disabled
        if !CLLocationManager.locationServicesEnabled() {
            return false
        }
        
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }

}
