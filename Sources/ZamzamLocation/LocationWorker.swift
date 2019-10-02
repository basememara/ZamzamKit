//
//  LocationManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/6/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import CoreLocation
import ZamzamCore

/// A `LocationManager` wrapper with extensions.
public class LocationWorker: NSObject, LocationWorkerType {
    private let desiredAccuracy: CLLocationAccuracy?
    private let distanceFilter: Double?
    private let activityType: CLActivityType?
    
    /// Subscribes to receive new data when available
    private var didChangeAuthorizationHandlers = SynchronizedArray<Observer<AuthorizationHandler>>()
    private var didChangeAuthorizationSingleUseHandlers = SynchronizedArray<AuthorizationHandler>()
    private var didUpdateLocationsHandlers = SynchronizedArray<Observer<LocationHandler>>()
    private var didUpdateLocationsSingleUseHandlers = SynchronizedArray<LocationHandler>()
    
    #if os(iOS)
    private var didUpdateHeading = SynchronizedArray<Observer<HeadingHandler>>()
    #endif
    
    /// Internal Core Location manager
    private lazy var manager = CLLocationManager().with {
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
        didChangeAuthorizationHandlers.removeAll()
        didChangeAuthorizationSingleUseHandlers.removeAll()
        didUpdateLocationsHandlers.removeAll()
        didUpdateLocationsSingleUseHandlers.removeAll()
        
        #if os(iOS)
        didUpdateHeading.removeAll()
        #endif
    }
}

// MARK: - Authorization

public extension LocationWorker {
    
    var isAuthorized: Bool {
        return CLLocationManager.isAuthorized
    }
    
    func isAuthorized(for type: LocationModels.AuthorizationType) -> Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        
        #if os(OSX)
            return type == .always && CLLocationManager.authorizationStatus() == .authorizedAlways
        #else
            return (type == .whenInUse && CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
                || (type == .always && CLLocationManager.authorizationStatus() == .authorizedAlways)
        #endif
    }
    
    func requestAuthorization(for type: LocationModels.AuthorizationType, startUpdatingLocation: Bool, completion: AuthorizationHandler?) {
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
            didChangeAuthorizationSingleUseHandlers += { _ in self.startUpdatingLocation() }
        }
        
        // Handle denied and exit
        guard CLLocationManager.authorizationStatus() == .notDetermined else {
            completion?(false)
            return
        }
        
        if let completion = completion {
            didChangeAuthorizationSingleUseHandlers += completion
        }
    }
}

// MARK: - Coordinates

public extension LocationWorker {
    
    var location: CLLocation? {
        return manager.location
    }
    
    func requestLocation(completion: @escaping LocationHandler) {
        didUpdateLocationsSingleUseHandlers += completion
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
public extension LocationWorker {
    
    func startMonitoringSignificantLocationChanges() {
        manager.startMonitoringSignificantLocationChanges()
    }
    
    func stopMonitoringSignificantLocationChanges() {
        manager.stopMonitoringSignificantLocationChanges()
    }
}

public extension LocationWorker {
    
    var heading: CLHeading? {
        return manager.heading
    }
    
    func startUpdatingHeading() {
        manager.startUpdatingHeading()
    }
    
    func stopUpdatingHeading() {
        manager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        didUpdateHeading.forEach { task in
            DispatchQueue.main.async {
                task.handler(newHeading)
            }
        }
    }
}
#endif

// MARK: - Observers

public extension LocationWorker {
    
    func addObserver(_ observer: Observer<AuthorizationHandler>) {
        didChangeAuthorizationHandlers += observer
    }
    
    func removeObserver(_ observer: Observer<AuthorizationHandler>) {
        didChangeAuthorizationHandlers -= observer
    }
    
    func addObserver(_ observer: Observer<LocationHandler>) {
        didUpdateLocationsHandlers += observer
    }
    
    func removeObserver(_ observer: Observer<LocationHandler>) {
        didUpdateLocationsHandlers -= observer
    }
    
    #if os(iOS)
    func addObserver(_ observer: Observer<HeadingHandler>) {
        didUpdateHeading += observer
    }
    
    func removeObserver(_ observer: Observer<HeadingHandler>) {
        didUpdateHeading -= observer
    }
    #endif
    
    func removeObservers(with prefix: String) {
        let prefix = prefix + "."
        
        didChangeAuthorizationHandlers.remove(where: { $0.id.hasPrefix(prefix) })
        didUpdateLocationsHandlers.remove(where: { $0.id.hasPrefix(prefix) })
        
        #if os(iOS)
        didUpdateHeading.remove(where: { $0.id.hasPrefix(prefix) })
        #endif
    }
}

// MARK: - Delegates

extension LocationWorker: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        
        // Trigger and empty queues
        didChangeAuthorizationHandlers.forEach { task in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                task.handler(self.isAuthorized)
            }
        }
        
        didChangeAuthorizationSingleUseHandlers.removeAll { [weak self] in
            guard let self = self else { return }
            $0.forEach { $0(self.isAuthorized) }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Trigger and empty queues
        didUpdateLocationsHandlers.forEach { task in
            DispatchQueue.main.async {
                task.handler(location)
            }
        }
        
        didUpdateLocationsSingleUseHandlers.removeAll {
            $0.forEach { $0(location) }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: Injectable logger
        debugPrint(error)
    }
}
