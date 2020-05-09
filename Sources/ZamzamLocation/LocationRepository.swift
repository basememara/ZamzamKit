//
//  LocationManager.swift
//  ZamzamLocation
//
//  Created by Basem Emara on 3/6/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import CoreLocation
import ZamzamCore

/// A `LocationManager` wrapper with extensions.
public class LocationRepository: NSObject, LocationRepositoryType {
    private let desiredAccuracy: CLLocationAccuracy?
    private let distanceFilter: Double?
    private let activityType: CLActivityType?
    
    /// Subscribes to receive new data when available
    private var didChangeAuthorizationHandlers = Synchronized<[Observer<AuthorizationHandler>]>([])
    private var didChangeAuthorizationSingleUseHandlers = Synchronized<[AuthorizationHandler]>([])
    private var didUpdateLocationsHandlers = Synchronized<[Observer<LocationHandler>]>([])
    private var didUpdateLocationsSingleUseHandlers = Synchronized<[LocationHandler]>([])
    
    #if os(iOS)
    private var didUpdateHeading = Synchronized<[Observer<HeadingHandler>]>([])
    #endif
    
    /// Internal Core Location manager
    private lazy var manager = CLLocationManager().apply {
        $0.desiredAccuracy ?= self.desiredAccuracy
        $0.distanceFilter ?= self.distanceFilter
        
        #if os(iOS)
        $0.activityType ?= self.activityType
        #endif
        
        $0.delegate = self
    }
    
    public required init(
        desiredAccuracy: CLLocationAccuracy? = nil,
        distanceFilter: Double? = nil,
        activityType: CLActivityType? = nil
    ) {
        // Assign values to location manager options
        self.desiredAccuracy = desiredAccuracy
        self.distanceFilter = distanceFilter
        self.activityType = activityType
    
        super.init()
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
    
    var isAuthorized: Bool { CLLocationManager.isAuthorized }
    
    func isAuthorized(for type: LocationAPI.AuthorizationType) -> Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        
        #if os(OSX)
            return type == .always && CLLocationManager.authorizationStatus() == .authorizedAlways
        #else
            return (type == .whenInUse && CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
                || (type == .always && CLLocationManager.authorizationStatus() == .authorizedAlways)
        #endif
    }
    
    func requestAuthorization(for type: LocationAPI.AuthorizationType, startUpdatingLocation: Bool, completion: AuthorizationHandler?) {
        // Handle authorized and exit
        guard !isAuthorized(for: type) else {
            if startUpdatingLocation {
                self.startUpdatingLocation()
            }
            
            completion?(true)
            return
        }
        
        // Request appropiate authorization before exit
        defer {
            #if os(OSX)
                if #available(OSX 10.15, *) {
                    manager.requestAlwaysAuthorization()
                }
            #elseif os(tvOS)
                manager.requestWhenInUseAuthorization()
            #else
                switch type {
                case .whenInUse:
                    manager.requestWhenInUseAuthorization()
                case .always:
                    manager.requestAlwaysAuthorization()
                }
            #endif
        }
        
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
        guard CLLocationManager.authorizationStatus() == .notDetermined else {
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
    
    var location: CLLocation? { manager.location }
    
    func requestLocation(completion: @escaping LocationHandler) {
        didUpdateLocationsSingleUseHandlers.value { $0.append(completion) }
        manager.requestLocation()
    }
    
    func startUpdatingLocation(enableBackground: Bool) {
        #if os(iOS)
        manager.allowsBackgroundLocationUpdates = enableBackground
        #endif
        

        #if !os(tvOS)
        manager.startUpdatingLocation()
        #endif
    }
    
    func stopUpdatingLocation() {
        #if os(iOS)
        manager.allowsBackgroundLocationUpdates = false
        #endif
        
        manager.stopUpdatingLocation()
    }
}

#if os(iOS)
public extension LocationRepository {
    
    func startMonitoringSignificantLocationChanges() {
        manager.startMonitoringSignificantLocationChanges()
    }
    
    func stopMonitoringSignificantLocationChanges() {
        manager.stopMonitoringSignificantLocationChanges()
    }
}

public extension LocationRepository {
    
    var heading: CLHeading? { manager.heading }
    
    func startUpdatingHeading() {
        manager.startUpdatingHeading()
    }
    
    func stopUpdatingHeading() {
        manager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let handlers = didUpdateHeading.value
        handlers.forEach { task in
            DispatchQueue.main.async {
                task.handler(newHeading)
            }
        }
    }
}
#endif

// MARK: - Observers

public extension LocationRepository {
    
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
    
    func removeObservers(with prefix: String) {
        let prefix = prefix + "."
        
        didChangeAuthorizationHandlers.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
        didUpdateLocationsHandlers.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
        
        #if os(iOS)
        didUpdateHeading.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
        #endif
    }
}

// MARK: - Delegates

extension LocationRepository: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        
        // Trigger and empty queues
        let recurringHandlers = didChangeAuthorizationHandlers.value
        recurringHandlers.forEach { task in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                task.handler(self.isAuthorized)
            }
        }
        
        let singleHandlers = didChangeAuthorizationSingleUseHandlers.value
        didChangeAuthorizationSingleUseHandlers.value { $0.removeAll() }
        singleHandlers.forEach { $0(isAuthorized) }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
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
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: Injectable logger
        debugPrint(error)
    }
}
