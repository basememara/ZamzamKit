//
//  LocationsWorkerType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-09-07.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import CoreLocation

public protocol LocationWorkerType {
    typealias LocationHandler = (CLLocation) -> Void
    typealias AuthorizationHandler = (Bool) -> Void
    
    // MARK: - Authorization
    
    /// Determines if location services is enabled and authorized for always or when in use.
    var isAuthorized: Bool { get }
    
    /// Determines if location services is enabled and authorized for the specified authorization type.
    func isAuthorized(for type: LocationWorker.AuthorizationType) -> Bool
    
    /// Requests permission to use location services.
    ///
    /// - Parameters:
    ///   - type: Type of permission required, whether in the foreground (.whenInUse) or while running (.always).
    ///   - startUpdatingLocation: Starts the generation of updates that report the user’s current location.
    ///   - completion: True if the authorization succeeded for the authorization type, false otherwise.
    func requestAuthorization(for type: LocationWorker.AuthorizationType, startUpdatingLocation: Bool, completion: AuthorizationHandler?)
    
    // MARK: - Coordinates
    
    /// The most recently retrieved user location.
    var location: CLLocation? { get }
    
    /// Request the one-time delivery of the user’s current location.
    ///
    /// - Parameter completion: The completion with the location object.
    func requestLocation(completion: @escaping LocationHandler)
    
    /// Starts the generation of updates that report the user’s current location.
    func startUpdatingLocation(enableBackground: Bool)
    
    /// Stops the generation of location updates.
    func stopUpdatingLocation()
    
    #if os(iOS)
    typealias HeadingHandler = (CLHeading) -> Void
    
    /// The most recently reported heading.
    var heading: CLHeading? { get }
    
    /// Starts the generation of updates based on significant location changes.
    func startMonitoringSignificantLocationChanges()
    
    /// Stops the delivery of location events based on significant location changes.
    func stopMonitoringSignificantLocationChanges()
    
    /// Starts the generation of updates that report the user’s current heading.
    func startUpdatingHeading()
    
    /// Stops the generation of heading updates.
    func stopUpdatingHeading()
    
    func addObserver(_ observer: Observer<HeadingHandler>)
    func removeObserver(_ observer: Observer<HeadingHandler>)
    #endif
    
    // MARK: - Observers
    
    func addObserver(_ observer: Observer<AuthorizationHandler>)
    func removeObserver(_ observer: Observer<AuthorizationHandler>)
    
    func addObserver(_ observer: Observer<LocationHandler>)
    func removeObserver(_ observer: Observer<LocationHandler>)
    
    func removeObservers(with prefix: String)
}

public extension LocationWorkerType {
    
    func requestAuthorization(for type: LocationWorker.AuthorizationType) {
        requestAuthorization(for: type, startUpdatingLocation: false, completion: nil)
    }
    
    func requestAuthorization(for type: LocationWorker.AuthorizationType = .whenInUse, startUpdatingLocation: Bool = false, completion: AuthorizationHandler?) {
        requestAuthorization(for: type, startUpdatingLocation: startUpdatingLocation, completion: completion)
    }
    
    func startUpdatingLocation() {
        startUpdatingLocation(enableBackground: false)
    }
    
    func removeObservers(from file: String = #file) {
        removeObservers(with: file)
    }
}
