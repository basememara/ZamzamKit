//
//  LocationManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/6/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import CoreLocation

public protocol LocationManagerType {
    typealias LocationObserver = Observer<LocationHandler>
    typealias LocationHandler = (CLLocation) -> Void
    typealias AuthorizationObserver = Observer<AuthorizationHandler>
    typealias AuthorizationHandler = (Bool) -> Void
    
    var isAuthorized: Bool { get }
    var didUpdateLocations: SynchronizedArray<LocationObserver> { get set }
    var didChangeAuthorization: SynchronizedArray<AuthorizationObserver> { get set }
    
    init(desiredAccuracy: CLLocationAccuracy?, distanceFilter: Double?, activityType: CLActivityType?)
    
    func isAuthorized(for type: LocationAuthorizationType) -> Bool
    func startUpdating(enableBackground: Bool)
    func requestAuthorization(for type: LocationAuthorizationType, startUpdating: Bool, completion: AuthorizationHandler?)
    func requestLocation(completion: @escaping LocationHandler)
}

public class LocationManager: NSObject, LocationManagerType, CLLocationManagerDelegate {

    /// Internal Core Location manager
    fileprivate lazy var manager: CLLocationManager = {
        let bleManager = CLLocationManager()
        bleManager.desiredAccuracy ?= self.desiredAccuracy
        bleManager.distanceFilter ?= self.distanceFilter
        
        #if os(iOS)
        bleManager.activityType ?= self.activityType
        #endif
        
        bleManager.delegate = self
        return bleManager
    }()
    
    /// Default location manager options
    fileprivate let desiredAccuracy: CLLocationAccuracy?
    fileprivate let distanceFilter: Double?
    fileprivate let activityType: CLActivityType?
    
    public required init(
        desiredAccuracy: CLLocationAccuracy? = nil,
        distanceFilter: Double? = nil,
        activityType: CLActivityType? = nil) {
            // Assign values to location manager options
            self.desiredAccuracy = desiredAccuracy
            self.distanceFilter = distanceFilter
            self.activityType = activityType
        
            super.init()
    }
    
    /// Subscribes to receive new location data when available.
    public var didUpdateLocations = SynchronizedArray<LocationObserver>()
    fileprivate var didUpdateLocationsSingle = SynchronizedArray<LocationHandler>()
    
    /// Subscribes to receive new authorization data when available.
    public var didChangeAuthorization = SynchronizedArray<AuthorizationObserver>()
    fileprivate var didChangeAuthorizationSingle = SynchronizedArray<AuthorizationHandler>()
    
    deinit {
        // Empty task queues of references
        didUpdateLocations.removeAll()
        didUpdateLocationsSingle.removeAll()
        didChangeAuthorization.removeAll()
        didChangeAuthorizationSingle.removeAll()
    }
}

// CLLocationManagerDelegate functions
public extension LocationManager {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Trigger and empty queues
        didUpdateLocations.forEach { $0.handler(location) }
        didUpdateLocationsSingle.removeAll { $0.forEach { $0(location) } }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        
        // Trigger and empty queues
        didChangeAuthorization.forEach { $0.handler(isAuthorized) }
        didChangeAuthorizationSingle.removeAll { $0.forEach { $0(self.isAuthorized) } }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: Injectable logger
        debugPrint(error)
    }
}

// MARK: - CLLocationManager wrappers
public extension LocationManager {

    #if os(iOS)
    /// A Boolean value indicating whether the app wants to receive location updates when suspended.
    var allowsBackgroundLocationUpdates: Bool {
        get { return manager.allowsBackgroundLocationUpdates }
        set { manager.allowsBackgroundLocationUpdates = newValue }
    }
    #endif
    
    /// Determines if location services is enabled and authorized for always or when in use.
    var isAuthorized: Bool {
        return CLLocationManager.isAuthorized
    }
    
    /// Determines if location services is enabled and authorized for the specified authorization type.
    func isAuthorized(for type: LocationAuthorizationType) -> Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        return (type == .whenInUse && CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
            || (type == .always && CLLocationManager.authorizationStatus() == .authorizedAlways)
    }
    
    /// Starts the generation of updates that report the user’s current location.
    func startUpdating(enableBackground: Bool = false) {
        #if os(iOS)
        manager.allowsBackgroundLocationUpdates = enableBackground
        #endif
        
        manager.startUpdatingLocation()
    }
    
    /// Stops the generation of location updates.
    func stopUpdating() {
        #if os(iOS)
        manager.allowsBackgroundLocationUpdates = false
        #endif
        
        manager.stopUpdatingLocation()
    }
}

// MARK: - Single requests
public extension LocationManager {

    /// Requests permission to use location services.
    ///
    /// - Parameters:
    ///   - type: Type of permission required, whether in the foreground (.whenInUse) or while running (.always).
    ///   - startUpdating: Starts the generation of updates that report the user’s current location.
    ///   - completion: True if the authorization succeeded for the authorization type, false otherwise.
    func requestAuthorization(for type: LocationAuthorizationType = .whenInUse, startUpdating: Bool = false, completion: AuthorizationHandler? = nil) {
        // Handle authorized and exit
        guard !isAuthorized(for: type) else {
            if startUpdating { self.startUpdating() }
            completion?(true)
            return
        }
        
        // Request appropiate authorization before exit
        defer {
            switch type {
            case .whenInUse: manager.requestWhenInUseAuthorization()
            case .always: manager.requestAlwaysAuthorization()
            }
        }
        
        // Handle mismatched allowed and exit
        guard !isAuthorized else {
            if startUpdating { self.startUpdating() }
            
            // Process callback in case authorization dialog not launched by OS
            // since user will be notified first time only and inored subsequently
            completion?(false)
            return
        }
        
        if startUpdating {
            didChangeAuthorizationSingle += { _ in self.startUpdating() }
        }
        
        // Handle denied and exit
        guard CLLocationManager.authorizationStatus() == .notDetermined
            else { completion?(false); return }
        
        if let completion = completion {
            didChangeAuthorizationSingle += completion
        }
    }
    
    /// Request the one-time delivery of the user’s current location.
    ///
    /// - Parameter completion: The completion with the location object.
    func requestLocation(completion: @escaping LocationHandler) {
        didUpdateLocationsSingle += completion
        manager.requestLocation()
    }
}
