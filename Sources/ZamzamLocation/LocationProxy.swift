//
//  LocationProxy.swift
//  ZamzamLocation
//
//  Created by Basem Emara on 2020-05-30.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import CoreLocation
import ZamzamCore

/// A `LocationManager` proxy with publisher.
@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public class LocationProxy: NSObject {
    private let desiredAccuracy: CLLocationAccuracy?
    private let distanceFilter: Double?
    private let activityType: CLActivityType?
    
    private static let authorizationSubject = PassthroughSubject<Bool, Error>()
    public var authorizationPublisher: AnyPublisher<Bool, Error>
    
    private static let locationSubject = PassthroughSubject<CLLocation, Error>()
    public var locationPublisher: AnyPublisher<CLLocation, Error>
    
    #if os(iOS)
    private static let headingSubject = PassthroughSubject<CLHeading, Error>()
    public var headingPublisher: AnyPublisher<CLHeading, Error>
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
        self.desiredAccuracy = desiredAccuracy
        self.distanceFilter = distanceFilter
        self.activityType = activityType
        
        self.authorizationPublisher = Self.authorizationSubject.eraseToAnyPublisher()
        self.locationPublisher = Self.locationSubject.eraseToAnyPublisher()
        self.headingPublisher = Self.headingSubject.eraseToAnyPublisher()
        
        super.init()
    }
}

// MARK: - Authorization

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension LocationProxy {
    
    var isAuthorized: Bool { CLLocationManager.isAuthorized }
    
    func isAuthorized(for type: LocationAPI.AuthorizationType) -> Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        
        #if os(macOS)
        return type == .always && CLLocationManager.authorizationStatus() == .authorizedAlways
        #else
        return (type == .whenInUse && CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
            || (type == .always && CLLocationManager.authorizationStatus() == .authorizedAlways)
        #endif
    }
    
    func requestAuthorization(for type: LocationAPI.AuthorizationType = .whenInUse) {
        // Handle authorized and exit
        guard !isAuthorized(for: type) else {
            Self.authorizationSubject.send(true)
            return
        }
        
        // Request appropiate authorization before exit
        defer {
            #if os(macOS)
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
            // Process callback in case authorization dialog not launched by OS
            // since user will be notified first time only and ignored subsequently
            Self.authorizationSubject.send(false)
            return
        }
        
        // Handle denied and exit
        guard CLLocationManager.authorizationStatus() == .notDetermined else {
            Self.authorizationSubject.send(false)
            return
        }
    }
}

// MARK: - Coordinates

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension LocationProxy {
    
    var location: CLLocation? { manager.location }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func startUpdatingLocation(enableBackground: Bool = false) {
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

@available(iOS 13, *)
public extension LocationProxy {
    
    func startMonitoringSignificantLocationChanges() {
        manager.startMonitoringSignificantLocationChanges()
    }
    
    func stopMonitoringSignificantLocationChanges() {
        manager.stopMonitoringSignificantLocationChanges()
    }
}

@available(iOS 13, *)
public extension LocationProxy {
    
    var heading: CLHeading? { manager.heading }
    
    func startUpdatingHeading() {
        manager.startUpdatingHeading()
    }
    
    func stopUpdatingHeading() {
        manager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        Self.headingSubject.send(newHeading)
    }
}

// MARK: - Delegates

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension LocationProxy: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        Self.authorizationSubject.send(isAuthorized)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Self.locationSubject.send(location)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Self.locationSubject.send(completion: .failure(error))
    }
}
