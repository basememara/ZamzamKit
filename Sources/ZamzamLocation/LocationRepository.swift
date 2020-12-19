//
//  LocationManager.swift
//  ZamzamLocation
//
//  Created by Basem Emara on 3/6/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import CoreLocation.CLError
import CoreLocation.CLHeading
import CoreLocation.CLLocation
import ZamzamCore

/// A `LocationManager` wrapper with extensions.
public class LocationRepository {
    private let service: LocationService
    
    /// Subscribes to receive new data when available
    private var didChangeAuthorizationHandlers = Atomic<[Observer<AuthorizationHandler>]>([])
    private var didChangeAuthorizationSingleUseHandlers = Atomic<[AuthorizationHandler]>([])
    private var didUpdateLocationsHandlers = Atomic<[Observer<LocationHandler>]>([])
    private var didUpdateLocationsSingleUseHandlers = Atomic<[LocationHandler]>([])
    
    #if os(iOS)
    public typealias HeadingHandler = (CLHeading) -> Void
    private var didUpdateHeading = Atomic<[Observer<HeadingHandler>]>([])
    #endif
    
    public init(service: LocationService) {
        self.service = service
        self.service.delegate = self
    }
    
    deinit {
        // Empty task queues of references
        didChangeAuthorizationHandlers.value { $0.removeAll() }
        didChangeAuthorizationSingleUseHandlers.value { $0.removeAll() }
        didUpdateLocationsHandlers.value { $0.removeAll() }
        didUpdateLocationsSingleUseHandlers.value { $0.removeAll() }
        
        #if os(iOS)
        didUpdateHeading.value { $0.removeAll() }
        #endif
    }
}

// MARK: - Authorization

public extension LocationRepository {
    
    /// Determines if location services is enabled and authorized for always or when in use.
    var isAuthorized: Bool { service.isAuthorized }
    
    /// Determines if location services is enabled and authorized for the specified authorization type.
    func isAuthorized(for type: LocationAPI.AuthorizationType) -> Bool {
        service.isAuthorized(for: type)
    }
    
    /// Requests permission to use location services.
    ///
    /// - Parameters:
    ///   - type: Type of permission required, whether in the foreground (.whenInUse) or while running (.always).
    ///   - startUpdatingLocation: Starts the generation of updates that report the user’s current location.
    ///   - completion: True if the authorization succeeded for the authorization type, false otherwise.
    func requestAuthorization(
        for type: LocationAPI.AuthorizationType = .whenInUse,
        startUpdatingLocation: Bool = false,
        completion: AuthorizationHandler? = nil
    ) {
        // Handle authorized and exit
        guard !isAuthorized(for: type) else {
            if startUpdatingLocation {
                self.startUpdatingLocation()
            }
            
            completion?(true)
            return
        }
        
        // Request appropiate authorization before exit
        defer { service.requestAuthorization(for: type) }
        
        // Handle mismatched allowed and exit
        guard !isAuthorized else {
            if startUpdatingLocation {
                self.startUpdatingLocation()
            }
            
            // Process callback in case authorization dialog not launched by OS
            // since user will be notified first time only and ignored subsequently
            completion?(false)
            return
        }
        
        if startUpdatingLocation {
            didChangeAuthorizationSingleUseHandlers.value { $0.append({ _ in self.startUpdatingLocation() }) }
        }
        
        // Handle denied and exit
        guard service.canRequestAuthorization else {
            completion?(false)
            return
        }
        
        if let completion = completion {
            didChangeAuthorizationSingleUseHandlers.value { $0.append(completion) }
        }
    }
}

// MARK: - Coordinates

public extension LocationRepository {
    
    /// The most recently retrieved user location.
    var location: CLLocation? { service.location }
    
    /// Request the one-time delivery of the user’s current location.
    func requestLocation(completion: @escaping (CLLocation) -> Void) {
        didUpdateLocationsSingleUseHandlers.value {
            $0.append({ [weak self] in
                // Ensure no location subscriptions before stopping requests
                if self?.didUpdateLocationsHandlers.value.isEmpty == true
                    && self?.didUpdateLocationsSingleUseHandlers.value.isEmpty == true {
                    self?.stopUpdatingLocation()
                }
                
                completion($0)
            })
        }
        
        // Use since requestLocation takes too long
        startUpdatingLocation()
    }
    
    /// Starts the generation of updates that report the user’s current location.
    func startUpdatingLocation(enableBackground: Bool = false) {
        service.startUpdatingLocation(enableBackground: enableBackground)
    }
    
    /// Stops the generation of location updates.
    func stopUpdatingLocation() {
        service.stopUpdatingLocation()
    }
}

#if os(iOS)
public extension LocationRepository {
    
    /// Starts the generation of updates based on significant location changes.
    func startMonitoringSignificantLocationChanges() {
        service.startMonitoringSignificantLocationChanges()
    }
    
    /// Stops the delivery of location events based on significant location changes.
    func stopMonitoringSignificantLocationChanges() {
        service.stopMonitoringSignificantLocationChanges()
    }
}

public extension LocationRepository {
    
    /// The most recently reported heading.
    var heading: CLHeading? { service.heading }
    
    /// Starts the generation of updates that report the user’s current heading.
    func startUpdatingHeading() {
        service.startUpdatingHeading()
    }
    
    /// Stops the generation of heading updates.
    func stopUpdatingHeading() {
        service.stopUpdatingHeading()
    }
    
    func locationService(didUpdateHeading newHeading: CLHeading) {
        let handlers = didUpdateHeading.value
        
        handlers.forEach { task in
            DispatchQueue.main.async {
                task.handler(newHeading)
            }
        }
    }
}
#endif

// MARK: - Delegates

extension LocationRepository: LocationServiceDelegate {
    
    public func locationService(didChangeAuthorization authorization: Bool) {
        // Trigger and empty queues
        let recurringHandlers = didChangeAuthorizationHandlers.value
        recurringHandlers.forEach { task in
            DispatchQueue.main.async {
                task.handler(authorization)
            }
        }
        
        let singleHandlers = didChangeAuthorizationSingleUseHandlers.value
        didChangeAuthorizationSingleUseHandlers.value { $0.removeAll() }
        singleHandlers.forEach { $0(authorization) }
    }
    
    public func locationService(didUpdateLocation location: CLLocation) {
        // Trigger and empty queues
        let recurringHandlers = self.didUpdateLocationsHandlers.value
        recurringHandlers.forEach { task in
            DispatchQueue.main.async {
                task.handler(location)
            }
        }
        
        let singleHandlers = didUpdateLocationsSingleUseHandlers.value
        didUpdateLocationsSingleUseHandlers.value { $0.removeAll() }
        singleHandlers.forEach { $0(location) }
    }
    
    public func locationService(didFailWithError error: CLError) {
        // TODO: Injectable logger
        debugPrint(error)
    }
}

// MARK: - Observers

public extension LocationRepository {
    typealias LocationHandler = (CLLocation) -> Void
    typealias AuthorizationHandler = (Bool) -> Void
    
    func addObserver(_ observer: Observer<AuthorizationHandler>) {
        didChangeAuthorizationHandlers.value { $0.append(observer) }
    }
    
    func removeObserver(_ observer: Observer<AuthorizationHandler>) {
        didChangeAuthorizationHandlers.value { $0.remove(observer) }
    }
    
    func addObserver(_ observer: Observer<LocationHandler>) {
        didUpdateLocationsHandlers.value { $0.append(observer) }
    }
    
    func removeObserver(_ observer: Observer<LocationHandler>) {
        didUpdateLocationsHandlers.value { $0.remove(observer) }
    }
    
    #if os(iOS)
    func addObserver(_ observer: Observer<HeadingHandler>) {
        didUpdateHeading.value { $0.append(observer) }
    }
    
    func removeObserver(_ observer: Observer<HeadingHandler>) {
        didUpdateHeading.value { $0.remove(observer) }
    }
    #endif
    
    func removeObservers(with prefix: String = #filePath) {
        let prefix = prefix + "."
        
        didChangeAuthorizationHandlers.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
        didUpdateLocationsHandlers.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
        
        #if os(iOS)
        didUpdateHeading.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
        #endif
    }
}
